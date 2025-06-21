package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class OrderAdminView {
    // Thông tin đơn hàng
    private Long orderId;
    private String userName;
    private String shippingName;
    private String shippingPhone;
    private String shippingAddress;
    private BigDecimal totalAmount;
    private String status;
    private String paymentStatus;
    private LocalDateTime createdAt;

    // Thông tin sản phẩm
    private Long productId;
    private String productName;
    private int quantity;

    // --- Helper Methods for JSP ---
    public String getStatusBadgeClass() {
        if (status == null) return "secondary";
        switch (status.toUpperCase()) {
            case "PENDING": return "warning text-dark";
            case "APPROVED":
            case "COMPLETED":
                return "success";
            case "REJECTED":
            case "CANCELLED":
                return "danger";
            default:
                return "secondary";
        }
    }

    public String getPaymentStatusBadgeClass() {
        if (paymentStatus == null) return "secondary";
        switch (paymentStatus.toUpperCase()) {
            case "PAID": return "success";
            case "UNPAID": return "warning text-dark";
            default: return "secondary";
        }
    }

    public String getFormattedCreatedAt() {
        if (createdAt == null) return "-";
        return createdAt.format(DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss"));
    }

    // Getters & Setters
    public Long getOrderId() { return orderId; }
    public void setOrderId(Long orderId) { this.orderId = orderId; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getShippingName() { return shippingName; }
    public void setShippingName(String shippingName) { this.shippingName = shippingName; }

    public String getShippingPhone() { return shippingPhone; }
    public void setShippingPhone(String shippingPhone) { this.shippingPhone = shippingPhone; }

    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
} 