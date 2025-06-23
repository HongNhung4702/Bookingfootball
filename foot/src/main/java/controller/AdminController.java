package controller;

import model.Product;
import model.Category;
import model.Booking;
import model.PurchaseOrder;
import model.OrderAdminView;
import service.ProductService;
import service.BookingService;
import service.AdminOrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.multipart.MultipartFile;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpServletRequest;

import java.io.File;
import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.List;

import model.Stadium;
import dao.StadiumDao;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired private ProductService productService;
    @Autowired private BookingService bookingService;
    @Autowired private AdminOrderService adminOrderService;
    @Autowired private StadiumDao stadiumDao;

    // Kiểm tra có phải ADMIN không
    private boolean isAdmin(HttpSession session) {
        String role = (String) session.getAttribute("role");
        return "ADMIN".equals(role);
    }

    // ===== DASHBOARD =====
    @GetMapping
    public String adminDashboard(HttpSession session, Model model) {
        if (!isAdmin(session)) {
            return "redirect:/login";
        }

        // Lấy danh sách sản phẩm sắp cạn kho
        List<Product> lowStockProducts = productService.getLowStockProducts(10);
        // Lấy số booking đang chờ
        List<Object[]> pendingBookings = bookingService.getPendingBookingsWithDetails();

        model.addAttribute("username", session.getAttribute("username"));
        model.addAttribute("pageTitle", "Admin Dashboard");
        model.addAttribute("contentPage", "admin/dashboard");
        model.addAttribute("lowStockProducts", lowStockProducts);
        model.addAttribute("pendingBookingsCount", pendingBookings.size());

        return "layouts/admin_layout";
    }

    // ===== ORDER MANAGEMENT =====
    @GetMapping("/orders")
    public String orderList(@RequestParam(value = "day", required = false) Integer day,
                            @RequestParam(value = "month", required = false) Integer month,
                            @RequestParam(value = "year", required = false) Integer year,
                            HttpSession session, Model model) {
        if (!isAdmin(session)) {
            return "redirect:/login";
        }
        List<OrderAdminView> orders;
        if (day != null || month != null || year != null) {
            orders = adminOrderService.listOrdersByDateFilter(day, month, year);
        } else {
            orders = adminOrderService.listAllOrders();
        }
        model.addAttribute("username", session.getAttribute("username"));
        model.addAttribute("pageTitle", "Order Management");
        model.addAttribute("contentPage", "admin/orders");
        model.addAttribute("orders", orders);
        model.addAttribute("dateFormatter", java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        model.addAttribute("filterDay", day);
        model.addAttribute("filterMonth", month);
        model.addAttribute("filterYear", year);
        return "layouts/admin_layout";
    }

    // ===== PRODUCT MANAGEMENT =====
    @GetMapping("/products")
    public String productList(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";

        List<Product> products   = productService.getAllProducts();
        List<Category> categories = productService.getAllCategories();

        model.addAttribute("username", session.getAttribute("username"));
        model.addAttribute("pageTitle", "Product Management");
        model.addAttribute("contentPage", "admin/products");
        model.addAttribute("products", products);
        model.addAttribute("categories", categories);

        return "layouts/admin_layout";
    }

    @GetMapping("/products/add")
    public String addProductForm(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";

        model.addAttribute("username", session.getAttribute("username"));
        model.addAttribute("pageTitle", "Add Product");
        model.addAttribute("contentPage", "admin/product-form");
        model.addAttribute("product", new Product());
        model.addAttribute("categories", productService.getAllCategories());
        model.addAttribute("isEdit", false);

        return "layouts/admin_layout";
    }

    @GetMapping("/products/edit/{id}")
    public String editProductForm(@PathVariable Long id, HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";

        Product p = productService.getProductById(id);
        if (p == null) return "redirect:/admin/products";

        model.addAttribute("username", session.getAttribute("username"));
        model.addAttribute("pageTitle", "Edit Product");
        model.addAttribute("contentPage", "admin/product-form");
        model.addAttribute("product", p);
        model.addAttribute("categories", productService.getAllCategories());
        model.addAttribute("isEdit", true);

        return "layouts/admin_layout";
    }

    @PostMapping("/products/save")
    public String saveProduct(@ModelAttribute Product product,
                              @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                              @RequestParam(value = "existingImageUrl", required = false) String existingImageUrl,
                              HttpSession session,
                              RedirectAttributes ra,
                              HttpServletRequest request) {
        if (!isAdmin(session)) return "redirect:/login";

        try {
            if (imageFile != null && !imageFile.isEmpty()) {
                String url = saveUploadedImage(imageFile, request);
                product.setImageUrl(url);
            } else if ((product.getImageUrl() == null || product.getImageUrl().isBlank())
                    && existingImageUrl != null && !existingImageUrl.isBlank()) {
                product.setImageUrl(existingImageUrl);
            }

            productService.saveProduct(product);
            ra.addFlashAttribute("successMessage", "Product saved successfully!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Error saving product: " + e.getMessage());
        }

        return "redirect:/admin/products";
    }

    private String saveUploadedImage(MultipartFile imageFile, HttpServletRequest req) throws IOException {
        String webappPath = req.getServletContext().getRealPath("/");
        String uploadDir  = webappPath + "images" + File.separator + "products" + File.separator;
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        String orig = imageFile.getOriginalFilename();
        String ext  = orig != null && orig.contains(".") ? orig.substring(orig.lastIndexOf(".")) : "";
        String filename = "prod_" + System.currentTimeMillis() + ext;

        File dest = new File(dir, filename);
        imageFile.transferTo(dest);
        return "/images/products/" + filename;
    }

    @PostMapping("/products/delete/{id}")
    public String deleteProduct(@PathVariable Long id,
                                HttpSession session,
                                RedirectAttributes ra) {
        if (!isAdmin(session)) return "redirect:/login";

        try {
            productService.deleteProduct(id);
            ra.addFlashAttribute("successMessage", "Product deleted successfully!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Error deleting product: " + e.getMessage());
        }

        return "redirect:/admin/products";
    }

    // ===== CATEGORY MANAGEMENT =====
    @GetMapping("/categories")
    public String categoryList(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";

        model.addAttribute("username", session.getAttribute("username"));
        model.addAttribute("pageTitle", "Category Management");
        model.addAttribute("contentPage", "admin/categories");
        model.addAttribute("categories", productService.getAllCategories());
        return "layouts/admin_layout";
    }

    @GetMapping("/categories/add")
    public String addCategoryForm(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";

        model.addAttribute("username", session.getAttribute("username"));
        model.addAttribute("pageTitle", "Add Category");
        model.addAttribute("contentPage", "admin/category-form");
        model.addAttribute("category", new Category());
        model.addAttribute("isEdit", false);
        return "layouts/admin_layout";
    }

    @GetMapping("/categories/edit/{id}")
    public String editCategoryForm(@PathVariable Long id,
                                   HttpSession session,
                                   Model model) {
        if (!isAdmin(session)) return "redirect:/login";

        Category c = productService.getCategoryById(id);
        if (c == null) return "redirect:/admin/categories";

        model.addAttribute("username", session.getAttribute("username"));
        model.addAttribute("pageTitle", "Edit Category");
        model.addAttribute("contentPage", "admin/category-form");
        model.addAttribute("category", c);
        model.addAttribute("isEdit", true);
        return "layouts/admin_layout";
    }

    @PostMapping("/categories/save")
    public String saveCategory(@ModelAttribute Category category,
                               HttpSession session,
                               RedirectAttributes ra) {
        if (!isAdmin(session)) return "redirect:/login";

        try {
            if (productService.isCategoryNameExists(category.getName(), category.getId())) {
                ra.addFlashAttribute("errorMessage", "Category name already exists!");
            } else {
                productService.saveCategory(category);
                ra.addFlashAttribute("successMessage", "Category saved successfully!");
            }
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Error saving category: " + e.getMessage());
        }
        return "redirect:/admin/categories";
    }

    @PostMapping("/categories/delete/{id}")
    public String deleteCategory(@PathVariable Long id,
                                 HttpSession session,
                                 RedirectAttributes ra) {
        if (!isAdmin(session)) return "redirect:/login";

        try {
            productService.deleteCategory(id);
            ra.addFlashAttribute("successMessage", "Category deleted successfully!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Error deleting category: " + e.getMessage());
        }
        return "redirect:/admin/categories";
    }

    // ===== INVENTORY MANAGEMENT =====
    @GetMapping("/inventory")
    public String inventoryList(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";

        List<Product> all  = productService.getAllProducts();
        List<Product> low  = productService.getLowStockProducts(10);

        model.addAttribute("username", session.getAttribute("username"));
        model.addAttribute("pageTitle", "Inventory Management");
        model.addAttribute("contentPage", "admin/inventory");
        model.addAttribute("products", all);
        model.addAttribute("lowStockProducts", low);
        return "layouts/admin_layout";
    }

    @PostMapping("/inventory/update-stock")
    public String updateStock(@RequestParam Long productId,
                              @RequestParam Integer stock,
                              HttpSession session,
                              RedirectAttributes ra) {
        if (!isAdmin(session)) return "redirect:/login";

        try {
            productService.updateStock(productId, stock);
            ra.addFlashAttribute("successMessage", "Stock updated successfully!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Error updating stock: " + e.getMessage());
        }
        return "redirect:/admin/inventory";
    }

    // ===== BOOKING MANAGEMENT =====
    @GetMapping("/bookings")
    public String bookingList(@RequestParam(required = false) String status,
                              HttpSession session,
                              Model model) {
        if (!isAdmin(session)) return "redirect:/login";

        List<Object[]> bookings;
        if (status != null && !status.isEmpty()) {
            try {
                Booking.Status bs = Booking.Status.valueOf(status.toUpperCase());
                bookings = bookingService.getBookingsWithDetailsByStatus(bs);
            } catch (IllegalArgumentException e) {
                bookings = bookingService.getBookingsWithDetails();
            }
        } else {
            bookings = bookingService.getBookingsWithDetails();
        }

        model.addAttribute("username", session.getAttribute("username"));
        model.addAttribute("pageTitle", "Booking Management");
        model.addAttribute("contentPage", "admin/bookings");
        model.addAttribute("bookings", bookings);
        model.addAttribute("selectedStatus", status);
        return "layouts/admin_layout";
    }

    @PostMapping("/bookings/approve/{id}")
    public String approveBooking(@PathVariable Long id,
                                 HttpSession session,
                                 RedirectAttributes ra) {
        if (!isAdmin(session)) return "redirect:/login";

        try {
            bookingService.updateBookingStatus(id, Booking.Status.APPROVED);
            ra.addFlashAttribute("successMessage", "Booking approved successfully!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Error approving booking: " + e.getMessage());
        }
        return "redirect:/admin/bookings";
    }

    @PostMapping("/bookings/reject/{id}")
    public String rejectBooking(@PathVariable Long id,
                                HttpSession session,
                                RedirectAttributes ra) {
        if (!isAdmin(session)) return "redirect:/login";

        try {
            bookingService.updateBookingStatus(id, Booking.Status.REJECTED);
            ra.addFlashAttribute("successMessage", "Booking rejected successfully!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Error rejecting booking: " + e.getMessage());
        }
        return "redirect:/admin/bookings";
    }

    // ===== STADIUM MANAGEMENT =====
    @GetMapping("/stadiums")
    public String stadiumList(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";

        List<Stadium> stadiums = stadiumDao.findAll();
        model.addAttribute("stadiums", stadiums);
        model.addAttribute("pageTitle", "Stadium Management");
        model.addAttribute("contentPage", "admin/stadiums");
        return "layouts/admin_layout";
    }

    @GetMapping("/stadiums/add")
    public String addStadiumForm(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";

        model.addAttribute("stadium", new Stadium());
        model.addAttribute("pageTitle", "Add New Stadium");
        model.addAttribute("contentPage", "admin/stadium-form");
        model.addAttribute("fieldTypes", Stadium.FieldType.values());
        model.addAttribute("isEdit", false);
        return "layouts/admin_layout";
    }

    @GetMapping("/stadiums/edit/{id}")
    public String editStadiumForm(@PathVariable Long id, HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";

        Stadium stadium = stadiumDao.findById(id);
        if (stadium == null) {
            return "redirect:/admin/stadiums";
        }
        model.addAttribute("stadium", stadium);
        model.addAttribute("pageTitle", "Edit Stadium");
        model.addAttribute("contentPage", "admin/stadium-form");
        model.addAttribute("fieldTypes", Stadium.FieldType.values());
        model.addAttribute("isEdit", true);
        return "layouts/admin_layout";
    }

    @PostMapping("/stadiums/save")
    public String saveStadium(@ModelAttribute Stadium stadium,
                              @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                              @RequestParam(value = "existingImageUrl", required = false) String existingImageUrl,
                              HttpSession session,
                              RedirectAttributes ra,
                              HttpServletRequest request) {
        if (!isAdmin(session)) return "redirect:/login";
        try {
            if (imageFile != null && !imageFile.isEmpty()) {
                String url = saveUploadedStadiumImage(imageFile, request);
                stadium.setImageUrl(url);
            } else if ((stadium.getImageUrl() == null || stadium.getImageUrl().isBlank())
                    && existingImageUrl != null && !existingImageUrl.isBlank()) {
                stadium.setImageUrl(existingImageUrl);
            }
            stadiumDao.save(stadium);
            ra.addFlashAttribute("successMessage", "Stadium saved successfully!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Error saving stadium: " + e.getMessage());
        }
        return "redirect:/admin/stadiums";
    }

    private String saveUploadedStadiumImage(MultipartFile imageFile, HttpServletRequest req) throws IOException {
        String webappPath = req.getServletContext().getRealPath("/");
        String uploadDir  = webappPath + "images" + File.separator + "stadiums" + File.separator;
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();
        String orig = imageFile.getOriginalFilename();
        String ext  = orig != null && orig.contains(".") ? orig.substring(orig.lastIndexOf(".")) : "";
        String filename = "stadium_" + System.currentTimeMillis() + ext;
        File dest = new File(dir, filename);
        imageFile.transferTo(dest);
        return "/images/stadiums/" + filename;
    }

    @PostMapping("/stadiums/delete/{id}")
    public String deleteStadium(@PathVariable Long id,
                                HttpSession session,
                                RedirectAttributes ra) {
        if (!isAdmin(session)) return "redirect:/login";
        try {
            stadiumDao.deleteById(id);
            ra.addFlashAttribute("successMessage", "Stadium deleted successfully!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Error deleting stadium: " + e.getMessage());
        }
        return "redirect:/admin/stadiums";
    }
}
