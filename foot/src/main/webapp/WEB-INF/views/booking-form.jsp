<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <!-- Stadium Info -->
            <div class="card mb-4 shadow-sm">
                <div class="card-header bg-success text-white">
                    <h4 class="mb-0">
                        <i class="fas fa-futbol"></i> Thông Tin Sân Bóng
                    </h4>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-4">
                            <c:choose>
                                <c:when test="${not empty stadium.imageUrl && stadium.imageUrl.startsWith('/')}" >
                                    <img src="${pageContext.request.contextPath}${stadium.imageUrl}" class="img-fluid rounded stadium-detail-img" alt="${stadium.name}">
                                </c:when>
                                <c:when test="${not empty stadium.imageUrl}">
                                    <img src="${stadium.imageUrl}" class="img-fluid rounded stadium-detail-img" alt="${stadium.name}">
                                </c:when>
                                <c:otherwise>
                                    <div class="stadium-placeholder d-flex align-items-center justify-content-center bg-light rounded">
                                        <i class="fas fa-futbol fa-3x text-muted"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="col-md-8">
                            <h5 class="text-success mb-3">${stadium.name}</h5>
                            <p class="mb-2">
                                <i class="fas fa-map-marker-alt text-danger"></i>
                                <strong>Địa chỉ:</strong> ${stadium.address}
                            </p>
                            <p class="mb-2">
                                <i class="fas fa-money-bill-wave text-warning"></i>
                                <strong>Giá:</strong> <span class="text-success fw-bold"><fmt:formatNumber value="${stadium.pricePerHour}" pattern="#,###"/> VNĐ/giờ</span>
                            </p>
                            <p class="mb-0">
                                <i class="fas fa-info-circle text-info"></i>
                                <strong>Mô tả:</strong> ${stadium.description}
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Booking Form -->
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0">
                        <i class="fas fa-calendar-plus"></i> Đặt Sân Bóng
                    </h4>
                </div>
                <div class="card-body">                    <form:form action="${pageContext.request.contextPath}/stadiums/${stadium.id}/book" 
                               method="post" modelAttribute="booking" class="needs-validation" novalidate="true">
                        
                        <!-- Ensure ID is null for new booking -->
                        <form:hidden path="id" value=""/>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="bookingDate" class="form-label">
                                    <i class="fas fa-calendar-alt"></i> Ngày đặt sân <span class="text-danger">*</span>
                                </label>
                                <input type="date" class="form-control" id="bookingDate" name="bookingDate" 
                                       min="${minDate}" required>
                                <div class="invalid-feedback">
                                    Vui lòng chọn ngày đặt sân.
                                </div>
                            </div>
                            
                            <div class="col-md-3 mb-3">
                                <label for="startTime" class="form-label">
                                    <i class="fas fa-clock"></i> Giờ bắt đầu <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="startTime" name="startTime" required>
                                    <option value="">Chọn giờ</option>
                                    <option value="06:00">06:00</option>
                                    <option value="07:00">07:00</option>
                                    <option value="08:00">08:00</option>
                                    <option value="09:00">09:00</option>
                                    <option value="10:00">10:00</option>
                                    <option value="11:00">11:00</option>
                                    <option value="12:00">12:00</option>
                                    <option value="13:00">13:00</option>
                                    <option value="14:00">14:00</option>
                                    <option value="15:00">15:00</option>
                                    <option value="16:00">16:00</option>
                                    <option value="17:00">17:00</option>
                                    <option value="18:00">18:00</option>
                                    <option value="19:00">19:00</option>
                                    <option value="20:00">20:00</option>
                                    <option value="21:00">21:00</option>
                                    <option value="22:00">22:00</option>
                                </select>
                                <div class="invalid-feedback">
                                    Vui lòng chọn giờ bắt đầu.
                                </div>
                            </div>
                            
                            <div class="col-md-3 mb-3">
                                <label for="endTime" class="form-label">
                                    <i class="fas fa-clock"></i> Giờ kết thúc <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="endTime" name="endTime" required>
                                    <option value="">Chọn giờ</option>
                                    <option value="07:00">07:00</option>
                                    <option value="08:00">08:00</option>
                                    <option value="09:00">09:00</option>
                                    <option value="10:00">10:00</option>
                                    <option value="11:00">11:00</option>
                                    <option value="12:00">12:00</option>
                                    <option value="13:00">13:00</option>
                                    <option value="14:00">14:00</option>
                                    <option value="15:00">15:00</option>
                                    <option value="16:00">16:00</option>
                                    <option value="17:00">17:00</option>
                                    <option value="18:00">18:00</option>
                                    <option value="19:00">19:00</option>
                                    <option value="20:00">20:00</option>
                                    <option value="21:00">21:00</option>
                                    <option value="22:00">22:00</option>
                                    <option value="23:00">23:00</option>
                                </select>
                                <div class="invalid-feedback">
                                    Vui lòng chọn giờ kết thúc.
                                </div>
                            </div>
                        </div>

                        <div class="alert alert-info">
                            <i class="fas fa-info-circle"></i>
                            <strong>Lưu ý:</strong> Đơn đặt sân sẽ được gửi đến quản trị viên để xét duyệt. 
                            Bạn sẽ nhận được thông báo khi đơn được xử lý.
                        </div>

                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                            <a href="${pageContext.request.contextPath}/stadiums" class="btn btn-secondary me-md-2">
                                <i class="fas fa-arrow-left"></i> Quay lại
                            </a>
                            <button type="submit" class="btn btn-success">
                                <i class="fas fa-paper-plane"></i> Gửi Đơn Đặt Sân
                            </button>
                        </div>
                    </form:form>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
.stadium-detail-img {
    width: 100%;
    height: 150px;
    object-fit: cover;
}

.stadium-placeholder {
    width: 100%;
    height: 150px;
}

.form-label {
    font-weight: 600;
    color: #495057;
}

.btn-success {
    background: linear-gradient(45deg, #28a745, #20c997);
    border: none;
    padding: 10px 20px;
    border-radius: 8px;
    font-weight: 500;
    transition: all 0.3s ease;
}

.btn-success:hover {
    background: linear-gradient(45deg, #218838, #1ea488);
    transform: translateY(-1px);
}

.btn-secondary {
    padding: 10px 20px;
    border-radius: 8px;
    font-weight: 500;
}

.card {
    border: none;
    border-radius: 12px;
}

.card-header {
    border-radius: 12px 12px 0 0 !important;
}

.fw-bold {
    font-weight: 700 !important;
}
</style>

<script>
// Set minimum date to today
document.addEventListener('DOMContentLoaded', function() {
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('bookingDate').setAttribute('min', today);
    
    // Form validation
    const forms = document.querySelectorAll('.needs-validation');
    Array.prototype.slice.call(forms).forEach(function (form) {
        form.addEventListener('submit', function (event) {
            const startTime = document.getElementById('startTime').value;
            const endTime = document.getElementById('endTime').value;
            
            if (startTime && endTime && endTime <= startTime) {
                event.preventDefault();
                event.stopPropagation();
                alert('Giờ kết thúc phải sau giờ bắt đầu!');
                return false;
            }
            
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        }, false);
    });
});
</script>
