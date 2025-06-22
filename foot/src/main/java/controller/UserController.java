package controller;

import model.User;
import model.Stadium;
import model.Booking;
import model.Product;
import model.Category;
import model.PurchaseOrder;
import model.UserOrderView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import jakarta.servlet.http.HttpSession;

import dao.UserDao;
import dao.StadiumDao;
import dao.BookingDao;
import service.UserService;
import service.BookingService;
import service.ProductService;
import service.OrderService;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Controller
public class UserController {

    @Autowired
    private UserService userService;
    @Autowired
    private UserDao userDao;
    @Autowired
    private StadiumDao stadiumDao;
    @Autowired
    private BookingDao bookingDao;
    @Autowired
    private BookingService bookingService;

    @Autowired
    private ProductService productService;
    @Autowired
    private OrderService orderService;

    @GetMapping("/")
    public String root() {
        return "redirect:/login";
    }

    @GetMapping("/login")
    public String showLoginForm(Model model) {
        model.addAttribute("user", new User());
        model.addAttribute("pageTitle", "Login");
        return "login";
    }

    @PostMapping("/login")
    public String login(@ModelAttribute("user") User user,
                        HttpSession session,
                        Model model) {
        if (userService.login(user.getUsername(), user.getPassword())) {
            session.setAttribute("username", user.getUsername());
            User loggedInUser = userDao.findByUsername(user.getUsername());
            if (loggedInUser == null) {
                model.addAttribute("error", "User not found in database");
                model.addAttribute("pageTitle", "Login");
                return "login";
            }
            session.setAttribute("role", loggedInUser.getRole().toString());
            if (loggedInUser.getRole() == User.Role.ADMIN) {
                return "redirect:/admin";
            }
            return "redirect:/home";
        } else {
            model.addAttribute("error", "Invalid username or password");
            model.addAttribute("pageTitle", "Login");
            return "login";
        }
    }

    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        model.addAttribute("user", new User());
        model.addAttribute("pageTitle", "Register");
        return "register";
    }

    @PostMapping("/register")
    public String register(@ModelAttribute("user") User user,
                           Model model) {
        if (userService.register(user)) {
            return "redirect:/login";
        } else {
            model.addAttribute("error", "Username or email already exists");
            model.addAttribute("pageTitle", "Register");
            return "register";
        }
    }

    /*** HOME ***/
    @GetMapping("/home")
    public String home(@RequestParam(value = "categoryId", required = false) Long categoryId,
                       HttpSession session,
                       Model model) {
        String username = (String) session.getAttribute("username");
        if (username == null) return "redirect:/login";

        List<Category> categories = productService.getAllCategories();
        List<Product> products = (categoryId != null)
                ? productService.getProductsByCategory(categoryId)
                : productService.getAllProducts();

        model.addAttribute("categories", categories);
        model.addAttribute("products", products);
        model.addAttribute("selectedCategoryId", categoryId);

        model.addAttribute("username", username);
        model.addAttribute("pageTitle", "Home");
        model.addAttribute("contentPage", "home");
        return "layouts/user_layout";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }

    /*** ĐẶT SÂN ***/
    @GetMapping("/stadiums")
    public String viewStadiums(HttpSession session, Model model) {
        String username = (String) session.getAttribute("username");
        if (username == null) return "redirect:/login";

        List<Stadium> stadiums = stadiumDao.findAll();
        List<String> uniqueAreas = stadiums.stream()
                .map(Stadium::getArea)
                .distinct()
                .sorted()
                .collect(Collectors.toList());
        List<String> uniqueFieldType = stadiums.stream()
                .map(s -> s.getFieldType().toString())
                .distinct()
                .sorted()
                .collect(Collectors.toList());

        model.addAttribute("stadiums", stadiums);
        model.addAttribute("uniqueAreas", uniqueAreas);
        model.addAttribute("uniqueFieldType", uniqueFieldType);
        model.addAttribute("username", username);
        model.addAttribute("pageTitle", "Đặt Sân Bóng");
        model.addAttribute("contentPage", "stadiums");
        return "layouts/user_layout";
    }

    @GetMapping("/stadiums/{id}/book")
    public String showBookingForm(@PathVariable Long id,
                                  HttpSession session,
                                  Model model) {
        String username = (String) session.getAttribute("username");
        if (username == null) return "redirect:/login";

        Stadium stadium = stadiumDao.findById(id);
        if (stadium == null) return "redirect:/stadiums";

        model.addAttribute("stadium", stadium);
        model.addAttribute("booking", new Booking());
        model.addAttribute("username", username);
        model.addAttribute("pageTitle", "Đặt Sân - " + stadium.getName());
        model.addAttribute("contentPage", "booking-form");
        return "layouts/user_layout";
    }

    @PostMapping("/stadiums/{id}/book")
    public String bookStadium(@PathVariable Long id,
                              @ModelAttribute Booking booking,
                              @RequestParam String bookingDate,
                              @RequestParam String startTime,
                              @RequestParam String endTime,
                              HttpSession session,
                              RedirectAttributes ra) {
        String username = (String) session.getAttribute("username");
        if (username == null) return "redirect:/login";

        User user = userDao.findByUsername(username);
        Stadium stadium = stadiumDao.findById(id);
        if (user == null || stadium == null) {
            ra.addFlashAttribute("error", "Không tìm thấy user hoặc sân!");
            return "redirect:/stadiums";
        }
        try {
            booking.setUserId(user.getId());
            booking.setStadiumId(id);
            booking.setBookingDate(LocalDate.parse(bookingDate));
            booking.setStartTime(LocalTime.parse(startTime));
            booking.setEndTime(LocalTime.parse(endTime));
            booking.setStatus(Booking.Status.PENDING);
            bookingService.createBooking(booking);
            ra.addFlashAttribute("success", "Đặt sân thành công!");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Lỗi khi đặt sân: " + e.getMessage());
            e.printStackTrace();
        }
        return "redirect:/stadiums";
    }

    @GetMapping("/my-bookings")
    public String viewMyBookings(HttpSession session, Model model) {
        String username = (String) session.getAttribute("username");
        if (username == null) return "redirect:/login";

        User user = userDao.findByUsername(username);
        List<Booking> bookings = bookingDao.findByUserId(user.getId());
        model.addAttribute("bookings", bookings);
        model.addAttribute("username", username);
        model.addAttribute("pageTitle", "Lịch Sử Đặt Sân");
        model.addAttribute("contentPage", "my-bookings");
        return "layouts/user_layout";
    }

    @PostMapping("/bookings/{id}/cancel")
    public String cancelBooking(@PathVariable Long id,
                                HttpSession session,
                                RedirectAttributes ra) {
        String username = (String) session.getAttribute("username");
        if (username == null) return "redirect:/login";

        User user = userDao.findByUsername(username);
        try {
            Booking booking = bookingDao.findById(id);
            if (booking == null || !booking.getUserId().equals(user.getId())) {
                ra.addFlashAttribute("error", "Không tìm thấy đơn hoặc không có quyền!");
            } else if (!booking.canBeCancelled()) {
                ra.addFlashAttribute("error", "Không thể hủy đơn này!");
            } else {
                bookingDao.updateStatus(id, Booking.Status.CANCELLED);
                ra.addFlashAttribute("success", "Hủy đơn thành công!");
            }
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Lỗi khi hủy: " + e.getMessage());
            e.printStackTrace();
        }
        return "redirect:/my-bookings";
    }

    /*** XEM CHI TIẾT SẢN PHẨM ***/
    @GetMapping("/product/{id}")
    public String viewProductDetail(@PathVariable Long id,
                                    HttpSession session,
                                    Model model) {
        String username = (String) session.getAttribute("username");
        if (username == null) return "redirect:/login";

        Product product = productService.getProductById(id);
        if (product == null) return "redirect:/home";

        model.addAttribute("product", product);
        model.addAttribute("username", username);
        model.addAttribute("pageTitle", product.getName());
        model.addAttribute("contentPage", "product-detail");
        return "layouts/user_layout";
    }

    /*** MUA & THANH TOÁN ***/
    @GetMapping("/checkout")
    public String showCheckoutForm(@RequestParam Long productId,
                                   @RequestParam int quantity,
                                   HttpSession session,
                                   Model model,
                                   RedirectAttributes ra) {
        String username = (String) session.getAttribute("username");
        if (username == null) return "redirect:/login";

        Product product = productService.getProductById(productId);
        if (product == null) {
            ra.addFlashAttribute("error", "Sản phẩm không tồn tại");
            return "redirect:/home";
        }
        model.addAttribute("product", product);
        model.addAttribute("quantity", quantity);
        model.addAttribute("username", username);
        model.addAttribute("pageTitle", "Xác nhận đặt hàng");
        model.addAttribute("contentPage", "checkout-form");
        return "layouts/user_layout";
    }

    @PostMapping("/checkout/confirm")
    public String confirmCheckout(@RequestParam Long productId,
                                  @RequestParam int quantity,
                                  @RequestParam String shippingName,
                                  @RequestParam String shippingPhone,
                                  @RequestParam String shippingAddress,
                                  @RequestParam(required = false) String size,
                                  HttpSession session,
                                  Model model,
                                  RedirectAttributes ra) {
        String username = (String) session.getAttribute("username");
        if (username == null) return "redirect:/login";

        User user = userDao.findByUsername(username);
        Product product = productService.getProductById(productId);
        if (product == null) {
            ra.addFlashAttribute("error", "Sản phẩm không tồn tại");
            return "redirect:/home";
        }

        try {
            orderService.placeOrder(
                user, product, quantity,
                shippingName, shippingPhone, shippingAddress, size
            );
            model.addAttribute("product", product);
            model.addAttribute("quantity", quantity);
            model.addAttribute("pageTitle", "Checkout Result");
            model.addAttribute("contentPage", "checkout-result");
            return "layouts/user_layout";
        } catch (IllegalArgumentException ex) {
            ra.addFlashAttribute("error", ex.getMessage());
            return "redirect:/product/" + productId;
        }
    }

    @GetMapping("/order-history")
    public String orderHistory(HttpSession session, Model model) {
        String username = (String) session.getAttribute("username");
        if (username == null) return "redirect:/login";

        User user = userDao.findByUsername(username);
        if (user == null) {
            // Handle user not found appropriately
            return "redirect:/login";
        }

        List<UserOrderView> orders = orderService.getUserOrderHistory(user.getId());

        model.addAttribute("orders", orders);
        model.addAttribute("username", username);
        model.addAttribute("pageTitle", "Lịch Sử Đặt Hàng");
        model.addAttribute("contentPage", "order-history");
        return "layouts/user_layout";
    }

}
