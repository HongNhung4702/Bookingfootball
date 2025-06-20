<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h2>Order Management</h2>
<table class="table table-striped table-bordered">
    <thead class="table-dark">
    <tr>
        <th>ID</th>
        <th>User</th>
        <th>Product Code</th>
        <th>Product Name</th>
        <th>Quantity</th>
        <th>Total ($)</th>
        <th>Paid?</th>
        <th>Status</th>
        <th>Ship to</th>
        <th>Phone</th>
        <th>Address</th>
        <th>Created At</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="o" items="${orders}">
        <tr>
            <td>${o.orderId}</td>
            <td>${o.userName}</td>
            <td>${o.productId}</td>
            <td>${o.productName}</td>
            <td>${o.quantity}</td>
            <td>${o.totalAmount}</td>
            <td>${o.paymentStatus}</td>
            <td>${o.status}</td>
            <td>${o.shippingName}</td>
            <td>${o.shippingPhone}</td>
            <td>${o.shippingAddress}</td>
            <td>${dateFormatter.format(o.createdAt)}</td>
        </tr>
    </c:forEach>
    </tbody>
</table>
