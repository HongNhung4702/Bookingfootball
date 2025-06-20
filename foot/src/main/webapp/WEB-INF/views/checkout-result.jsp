<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container mt-4">
    <div class="alert alert-success">
        <h4 class="alert-heading">Thanh toán thành công!</h4>
        <p>Đơn hàng của bạn đã được ghi nhận:</p>
        <hr>
        <p><strong>Mã đơn:</strong> ${order.id}</p>
        <p><strong>Sản phẩm:</strong> ${product.name}</p>
        <p><strong>Số lượng:</strong> ${quantity}</p>
        <p><strong>Tổng tiền:</strong> ${order.totalAmount} $</p>
    </div>
    <a href="<c:url value='/home'/>" class="btn btn-primary">Quay về Trang chủ</a>
</div>
