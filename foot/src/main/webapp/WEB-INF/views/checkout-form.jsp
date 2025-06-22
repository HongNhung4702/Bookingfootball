<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container mt-4">
    <h3>Thông tin giao hàng</h3>
    <form action="<c:url value='/checkout/confirm'/>" method="post">
        <!-- Giữ productId và quantity từ bước gọi GET /checkout -->
        <input type="hidden" name="productId" value="${product.id}" />
        <input type="hidden" name="quantity" value="${quantity}" />

        <div class="mb-3">
            <label for="shippingName" class="form-label">Họ &amp; Tên</label>
            <input type="text"
                   id="shippingName"
                   name="shippingName"
                   class="form-control"
                   placeholder="Nhập họ & tên người nhận"
                   required />
        </div>

        <div class="mb-3">
            <label for="shippingPhone" class="form-label">Số điện thoại</label>
            <input type="tel"
                   id="shippingPhone"
                   name="shippingPhone"
                   class="form-control"
                   placeholder="Nhập số điện thoại người nhận"
                   required />
        </div>

        <div class="mb-3">
            <label for="shippingAddress" class="form-label">Địa chỉ nhận hàng</label>
            <input type="text"
                   id="shippingAddress"
                   name="shippingAddress"
                   class="form-control"
                   placeholder="Nhập địa chỉ giao hàng"
                   required />
        </div>
        <div class="mb-3">
            <label for="size" class="form-label">Size (nếu có)</label>
            <input type="text"
                   id="size"
                   name="size"
                   class="form-control"
                   placeholder="Nhập size sản phẩm (ví dụ: S, M, L, XL, 39, 40...)" />
        </div>

        <button type="submit" class="btn btn-success">Xác nhận đặt hàng</button>
    </form>
</div>
