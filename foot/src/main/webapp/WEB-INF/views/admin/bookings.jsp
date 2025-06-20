<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="row mb-4">
    <div class="col-12">
        <div class="d-flex justify-content-between align-items-center">
            <h2><i class="fas fa-calendar-check me-2"></i>Booking Management</h2>
            <div class="d-flex gap-2">
                <!-- Status Filter -->
                <div class="dropdown">
                    <button class="btn btn-outline-secondary dropdown-toggle" type="button" id="statusFilter" 
                            data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-filter me-2"></i>
                        <c:choose>
                            <c:when test="${selectedStatus == 'PENDING'}">Pending</c:when>
                            <c:when test="${selectedStatus == 'APPROVED'}">Approved</c:when>
                            <c:when test="${selectedStatus == 'REJECTED'}">Rejected</c:when>
                            <c:otherwise>All Bookings</c:otherwise>
                        </c:choose>
                    </button>
                    <ul class="dropdown-menu" aria-labelledby="statusFilter">
                        <li><a class="dropdown-item" href="<c:url value='/admin/bookings'/>">All Bookings</a></li>
                        <li><a class="dropdown-item" href="<c:url value='/admin/bookings?status=PENDING'/>">Pending</a></li>
                        <li><a class="dropdown-item" href="<c:url value='/admin/bookings?status=APPROVED'/>">Approved</a></li>
                        <li><a class="dropdown-item" href="<c:url value='/admin/bookings?status=REJECTED'/>">Rejected</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bookings Table -->
<div class="card">
    <div class="card-header">
        <h5 class="mb-0">
            <i class="fas fa-list me-2"></i>Bookings List
            <c:if test="${selectedStatus != null}">
                - <span class="text-capitalize">${selectedStatus.toLowerCase()}</span> Bookings
            </c:if>
        </h5>
    </div>
    <div class="card-body">
        <c:choose>
            <c:when test="${empty bookings}">
                <div class="text-center py-4">
                    <i class="fas fa-calendar-times fa-3x text-muted mb-3"></i>
                    <h5 class="text-muted">No bookings found</h5>
                    <p class="text-muted">
                        <c:choose>
                            <c:when test="${selectedStatus != null}">
                                No ${selectedStatus.toLowerCase()} bookings available.
                            </c:when>
                            <c:otherwise>
                                No bookings have been made yet.
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Customer</th>
                                <th>Stadium</th>
                                <th>Date</th>
                                <th>Time</th>
                                <th>Status</th>
                                <th>Created</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="booking" items="${bookings}">
                                <tr>
                                    <td><strong>#${booking[0]}</strong></td>
                                    <td>
                                        <div>
                                            <strong>${booking[6]}</strong>
                                            <br><small class="text-muted">${booking[7]}</small>
                                        </div>
                                    </td>
                                    <td>
                                        <div>
                                            <strong>${booking[8]}</strong>
                                            <br><small class="text-muted">${booking[9]}</small>
                                        </div>
                                    </td>                                    <td>
                                        ${booking[1]}
                                    </td>
                                    <td>
                                        ${booking[2]} - ${booking[3]}
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${booking[4] == 'PENDING'}">
                                                <span class="badge bg-warning text-dark">
                                                    <i class="fas fa-clock me-1"></i>Pending
                                                </span>
                                            </c:when>
                                            <c:when test="${booking[4] == 'CANCELLED'}">
                                                <span class="badge bg-danger">
                                                    <i class="fas fa-times me-1"></i>Cancelled
                                                </span>
                                            </c:when>
                                            <c:when test="${booking[4] == 'APPROVED'}">
                                                <span class="badge bg-success">
                                                    <i class="fas fa-check me-1"></i>Approved
                                                </span>
                                            </c:when>
                                            <c:when test="${booking[4] == 'REJECTED'}">
                                                <span class="badge bg-danger">
                                                    <i class="fas fa-times me-1"></i>Rejected
                                                </span>
                                            </c:when>
                                        </c:choose>
                                    </td>                                    <td>
                                        <c:set var="dateTime" value="${booking[5].toString()}" />
                                        <c:choose>
                                            <c:when test="${dateTime.length() >= 19}">
                                                <c:set var="date" value="${dateTime.substring(0, 10)}" />
                                                <c:set var="time" value="${dateTime.substring(11, 19)}" />
                                                ${date.replace('-', '/')} ${time}
                                            </c:when>
                                            <c:when test="${dateTime.length() >= 16}">
                                                <c:set var="date" value="${dateTime.substring(0, 10)}" />
                                                <c:set var="time" value="${dateTime.substring(11)}" />
                                                ${date.replace('-', '/')} ${time}:00
                                            </c:when>
                                            <c:otherwise>
                                                ${dateTime}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:if test="${booking[4] == 'PENDING'}">
                                            <div class="btn-group" role="group">
                                                <form action="<c:url value='/admin/bookings/approve/${booking[0]}'/>" 
                                                      method="post" style="display: inline; margin-right: 10px;">
                                                    <button type="submit" class="btn btn-sm btn-success" 
                                                            title="Approve Booking">
                                                        <i class="fas fa-check"></i>
                                                    </button>
                                                </form>
                                                <form action="<c:url value='/admin/bookings/reject/${booking[0]}'/>" 
                                                      method="post" style="display: inline;">
                                                    <button type="submit" class="btn btn-sm btn-danger" 
                                                            title="Reject Booking"
                                                            onclick="return confirm('Are you sure you want to reject this booking?')">
                                                        <i class="fas fa-times"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </c:if>
                                        <c:if test="${booking[4] != 'PENDING'}">
                                            <span class="text-muted">No actions</span>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

