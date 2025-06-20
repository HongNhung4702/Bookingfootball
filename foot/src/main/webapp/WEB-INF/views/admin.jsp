<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="row">
    <div class="col-12">
        <h2 class="mb-4">Admin Dashboard</h2>
        <p class="lead">Welcome, <strong>${username}</strong>! You are logged in as an admin.</p>
    </div>
</div>

<!-- Quick Stats -->
<div class="row mb-4">
    <div class="col-md-3">
        <div class="card bg-warning text-white">
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <div>
                        <h5 class="card-title">Low Stock Alert</h5>
                        <h3>${lowStockCount}</h3>
                    </div>
                    <div class="align-self-center">
                        <i class="fas fa-exclamation-triangle fa-2x"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card bg-info text-white">
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <div>
                        <h5 class="card-title">Pending Bookings</h5>
                        <h3>${pendingBookingsCount}</h3>
                    </div>
                    <div class="align-self-center">
                        <i class="fas fa-clock fa-2x"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Quick Actions -->
<div class="row">
    <div class="col-12">
        <h4 class="mb-3">Quick Actions</h4>
    </div>
    <div class="col-md-4 mb-3">
        <div class="card h-100">
            <div class="card-body text-center">
                <i class="fas fa-box-open fa-3x text-primary mb-3"></i>
                <h5 class="card-title">Product Management</h5>
                <p class="card-text">Add, edit, and manage your products and inventory.</p>
                <a href="<c:url value='/admin/products'/>" class="btn btn-primary">Manage Products</a>
            </div>
        </div>
    </div>
    <div class="col-md-4 mb-3">
        <div class="card h-100">
            <div class="card-body text-center">
                <i class="fas fa-tags fa-3x text-success mb-3"></i>
                <h5 class="card-title">Category Management</h5>
                <p class="card-text">Organize products with categories like shoes, balls, etc.</p>
                <a href="<c:url value='/admin/categories'/>" class="btn btn-success">Manage Categories</a>
            </div>
        </div>
    </div>
    <div class="col-md-4 mb-3">
        <div class="card h-100">
            <div class="card-body text-center">
                <i class="fas fa-warehouse fa-3x text-warning mb-3"></i>
                <h5 class="card-title">Inventory Management</h5>
                <p class="card-text">Track stock levels and manage inventory.</p>
                <a href="<c:url value='/admin/inventory'/>" class="btn btn-warning">Manage Inventory</a>
            </div>
        </div>
    </div>
    <div class="col-md-4 mb-3">
        <div class="card h-100">
            <div class="card-body text-center">
                <i class="fas fa-calendar-check fa-3x text-info mb-3"></i>
                <h5 class="card-title">Booking Management</h5>
                <p class="card-text">Review and approve stadium booking requests.</p>
                <a href="<c:url value='/admin/bookings'/>" class="btn btn-info">Manage Bookings</a>
            </div>
        </div>
    </div>
</div>

<!-- Font Awesome for icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">