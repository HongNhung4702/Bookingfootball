<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container mt-4">
    <!-- Header -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center">
                <h2 class="mb-0">
                    <i class="fas fa-receipt text-primary"></i> Lịch sử đặt hàng
                </h2>
            </div>
        </div>
    </div>

    <c:choose>
        <c:when test="${not empty orders}">
            <div class="card">
                <div class="card-header bg-light">
                    <h5 class="mb-0">
                        <i class="fas fa-list"></i> Danh Sách Đơn Hàng (${orders.size()} đơn)
                    </h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Mã đơn</th>
                                    <th>Ngày đặt</th>
                                    <th>Người nhận</th>
                                    <th>SĐT</th>
                                    <th>Địa chỉ</th>
                                    <th>Tổng tiền</th>
                                    <th>Trạng thái</th>
                                    <th>Thanh toán</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${orders}">
                                    <tr>
                                        <td><span class="badge bg-secondary">#${order.id}</span></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${order.createdAt != null}">
                                                    ${order.createdAt.toString().replace('T', ' ').substring(0, 16)}
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${order.shippingName}</td>
                                        <td>${order.shippingPhone}</td>
                                        <td>${order.shippingAddress}</td>
                                        <td><span class="badge bg-success"><fmt:formatNumber value="${order.totalAmount}" pattern="#.##"/> VNĐ</span></td>
                                        <td>
                                            <span class="badge bg-${order.status == 'PENDING' ? 'warning text-dark' : (order.status == 'APPROVED' ? 'success' : (order.status == 'REJECTED' ? 'danger' : 'secondary'))}">
                                                ${order.status}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge bg-${order.paymentStatus == 'PAID' ? 'success' : 'secondary'}">
                                                ${order.paymentStatus == 'PAID' ? 'Đã thanh toán' : 'Chưa thanh toán'}
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="text-center py-5">
                <i class="fas fa-receipt fa-5x text-muted mb-4"></i>
                <h4 class="text-muted mb-3">Chưa có lịch sử đặt hàng</h4>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-success btn-lg">
                    <i class="fas fa-shopping-cart"></i> Mua hàng ngay
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<style>
.card-header {
    border-radius: 12px 12px 0 0 !important;
    border-bottom: none;
}
.card {
    border-radius: 12px;
    overflow: hidden;
}
.table th, .table td {
    vertical-align: middle;
}
.badge {
    font-size: 1em;
    padding: 0.5em 0.8em;
    border-radius: 8px;
}
.fa-5x {
    font-size: 4rem !important;
}
.btn-success {
    background: linear-gradient(45deg, #28a745, #20c997);
    border: none;
    padding: 12px 24px;
    border-radius: 8px;
    font-weight: 500;
    transition: all 0.3s ease;
}
.btn-success:hover {
    background: linear-gradient(45deg, #218838, #1ea488);
    transform: translateY(-1px);
}
</style> 