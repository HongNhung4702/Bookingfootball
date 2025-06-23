<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Header -->
<div class="row mb-4">
    <div class="col-12">
        <div class="d-flex justify-content-between align-items-center">
            <h2><i class="fas fa-box-open me-2"></i>Order Management</h2>
        </div>
    </div>
</div>

<!-- Orders Table Card -->
<div class="card shadow-sm">
    <div class="card-header bg-light">
        <h5 class="mb-0">
            <i class="fas fa-list me-2"></i>Orders List
        </h5>
        <form class="row g-2 mt-2" method="get" action="${pageContext.request.contextPath}/admin/orders">
            <div class="col-auto">
                <input type="number" min="1" max="31" class="form-control" name="day" placeholder="Day" value="${filterDay != null ? filterDay : ''}">
            </div>
            <div class="col-auto">
                <input type="number" min="1" max="12" class="form-control" name="month" placeholder="Month" value="${filterMonth != null ? filterMonth : ''}">
            </div>
            <div class="col-auto">
                <input type="number" min="2000" max="2100" class="form-control" name="year" placeholder="Year" value="${filterYear != null ? filterYear : ''}">
            </div>
            <div class="col-auto">
                <button type="submit" class="btn btn-primary"><i class="fas fa-filter"></i> Filter</button>
                <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-secondary">Reset</a>
            </div>
        </form>
    </div>
    <div class="card-body p-0">
        <c:choose>
            <c:when test="${empty orders}">
                <div class="text-center py-5">
                    <i class="fas fa-box-open fa-3x text-muted mb-3"></i>
                    <h5 class="text-muted">No orders found.</h5>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="table-dark">
                            <tr>
                                <th>Order ID</th>
                                <th>Customer</th>
                                <th>Product</th>
                                <th>Size</th>
                                <th>Total</th>
                                <th>Payment</th>
                                <th>Status</th>
                                <th>Created At</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${orders}">
                                <tr>
                                    <td><strong>#${order.orderId}</strong></td>
                                    <td>
                                        <div>
                                            <strong>${order.shippingName}</strong>
                                            <br><small class="text-muted">User: ${order.userName}</small>
                                        </div>
                                    </td>
                                    <td>
                                        <div>
                                            <strong>${order.productName}</strong>
                                            <br><small class="text-muted">Qty: ${order.quantity}</small>
                                        </div>
                                    </td>
                                    <td>${order.size}</td>
                                    <td>
                                        <span class="fw-bold text-success">
                                            <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="" minFractionDigits="0"/> VNĐ
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge bg-${order.paymentStatusBadgeClass}">
                                            ${order.paymentStatus}
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge bg-${order.statusBadgeClass}">
                                            ${order.status}
                                        </span>
                                    </td>
                                    <td>${order.formattedCreatedAt}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
