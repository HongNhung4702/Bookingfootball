package service;

import dao.OrderDetailDao;
import dao.ProductDao;
import dao.PurchaseOrderDao;
import model.OrderDetail;
import model.Product;
import model.PurchaseOrder;
import model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import model.UserOrderView;
import java.util.stream.Collectors;

@Service
public class OrderService {
    @Autowired private PurchaseOrderDao orderDao;
    @Autowired private OrderDetailDao detailDao;
    @Autowired private ProductDao productDao;

    public PurchaseOrder placeOrder(User user,
                                    Product product,
                                    int quantity,
                                    String shippingName,
                                    String shippingPhone,
                                    String shippingAddress,
                                    String size) {
        if (quantity <= 0) {
            throw new IllegalArgumentException("Số lượng phải lớn hơn 0");
        }
        if (quantity > product.getStock()) {
            throw new IllegalArgumentException("Không đủ hàng trong kho");
        }

        // --- tính giá ---
        BigDecimal unitPrice = BigDecimal.valueOf(product.getPrice());
        BigDecimal totalAmount = unitPrice.multiply(BigDecimal.valueOf(quantity));

        // --- tạo đối tượng PurchaseOrder ---
        PurchaseOrder order = new PurchaseOrder();
        order.setUserId(user.getId());
        order.setShippingName(shippingName);
        order.setShippingPhone(shippingPhone);
        order.setShippingAddress(shippingAddress);
        order.setTotalAmount(totalAmount);
        order.setStatus("PENDING");
        order.setPaymentStatus("UNPAID");
        order.setCreatedAt(LocalDateTime.now());

        // --- lưu & lấy ID PurchaseOrderDao ---
        Long orderId = orderDao.create(order);
        order.setId(orderId);

        // --- giảm stock ---
        productDao.updateStock(product.getId(), product.getStock() - quantity);

        // --- Tạo & lưu OrderDetail ---
        OrderDetail detail = new OrderDetail();
        detail.setPurchaseOrderId(orderId);
        detail.setProductId(product.getId());
        detail.setQuantity(quantity);
        detail.setUnitPrice(unitPrice);
        detail.setSize(size);
        detailDao.create(detail);

        return order;
    }

    public List<PurchaseOrder> getOrdersByUserId(Long userId) {
        return orderDao.findByUserId(userId);
    }

    public List<UserOrderView> getUserOrderHistory(Long userId) {
        return orderDao.findUserOrderViewsByUserId(userId);
    }

    public void deleteOrderForUser(Long orderId, Long userId) {
        orderDao.markUserDeleted(orderId, userId);
    }

    public void deleteAllOrdersForUser(Long userId) {
        orderDao.markAllUserDeleted(userId);
    }
}
