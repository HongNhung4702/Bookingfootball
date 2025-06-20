<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container mt-4">
    <h2>Admin Dashboard</h2>

    <div class="row">
        <!-- Thẻ Thống kê sản phẩm sắp hết kho -->
        <div class="col-md-6 mb-4">
            <div class="card border-warning">
                <div class="card-header bg-warning text-white">
                    <i class="fas fa-exclamation-triangle me-2"></i>Low Stock Products
                </div>
                <ul class="list-group list-group-flush">
                    <c:forEach var="p" items="${lowStockProducts}">
                        <li class="list-group-item">
                                ${p.name} — <span class="fw-bold">${p.stock}</span> left
                        </li>
                    </c:forEach>
                    <c:if test="${empty lowStockProducts}">
                        <li class="list-group-item">No low-stock items</li>
                    </c:if>
                </ul>
            </div>
        </div>

        <!-- Thẻ Thống kê booking chờ xử lý -->
        <div class="col-md-6 mb-4">
            <div class="card border-info">
                <div class="card-header bg-info text-white">
                    <i class="fas fa-clock me-2"></i>Pending Bookings
                </div>
                <div class="card-body">
                    <h3>${pendingBookingsCount}</h3>
                    <p>booking(s) awaiting approval</p>
                </div>
            </div>
        </div>
    </div>
</div>
