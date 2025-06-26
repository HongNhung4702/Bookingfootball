<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Inventory Management</h2>
    <a href="<c:url value='/admin/products'/>" class="btn btn-primary">
        <i class="fas fa-box-open me-2"></i>Manage Products
    </a>
</div>

<!-- Low Stock Alert -->
<c:if test="${not empty lowStockProducts}">
    <div class="alert alert-warning">
        <h5><i class="fas fa-exclamation-triangle me-2"></i>Low Stock Alert</h5>
        <p>The following products have low stock (≤10 items):</p>
        <ul class="mb-0">
            <c:forEach var="product" items="${lowStockProducts}">
                <li><strong>${product.name}</strong> - Only ${product.stock} left</li>
            </c:forEach>
        </ul>
    </div>
</c:if>

<!-- Stock Update Form -->
<div class="card mb-4">
    <div class="card-header">
        <h5 class="mb-0"><i class="fas fa-plus-circle me-2"></i>Quick Stock Update</h5>
    </div>
    <div class="card-body">
        <form action="<c:url value='/admin/inventory/update-stock'/>" method="post" class="row g-3">
            <div class="col-md-6">
                <label for="productSelect" class="form-label">Select Product</label>
                <select class="form-select" id="productSelect" name="productId" required>
                    <option value="">Choose a product...</option>
                    <c:forEach var="product" items="${products}">
                        <option value="${product.id}" data-current-stock="${product.stock}">
                            ${product.name} (Current: ${product.stock})
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-4">
                <label for="newStock" class="form-label">New Stock Quantity</label>
                <input type="number" class="form-control" id="newStock" name="stock" min="0" required>
            </div>
            <div class="col-md-2">
                <label class="form-label">&nbsp;</label>
                <button type="submit" class="btn btn-success d-block w-100">
                    <i class="fas fa-save me-1"></i>Update
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Inventory Table -->
<div class="table-responsive">
    <table class="table table-striped table-hover">
        <thead class="table-dark">
            <tr>
                <th>Product ID</th>
                <th>Product Name</th>
                <th>Category</th>
                <th>Current Stock</th>
                <th>Stock Status</th>
                <th>Price</th>
                <th>Total Value</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:set var="totalValue" value="0"/>
            <c:forEach var="product" items="${products}">
                <c:set var="productValue" value="${product.price * product.stock}"/>
                <c:set var="totalValue" value="${totalValue + productValue}"/>
                <tr class="<c:if test='${product.stock <= 5}'>table-danger</c:if><c:if test='${product.stock > 5 && product.stock <= 20}'>table-warning</c:if>">
                    <td>${product.id}</td>
                    <td>
                        <strong>${product.name}</strong>
                        <c:if test="${not empty product.imageUrl}">
                            <br><img src="${pageContext.request.contextPath}${product.imageUrl}" alt="${product.name}" 
                                   class="img-thumbnail mt-1" style="width: 40px; height: 40px; object-fit: cover;">
                        </c:if>
                    </td>
                    <td>
                        <c:forEach var="category" items="${categories}">
                            <c:if test="${category.id == product.categoryId}">
                                <span class="badge bg-secondary">${category.name}</span>
                            </c:if>
                        </c:forEach>
                    </td>
                    <td>
                        <strong>${product.stock}</strong>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${product.stock == 0}">
                                <span class="badge bg-danger">Out of Stock</span>
                            </c:when>
                            <c:when test="${product.stock <= 5}">
                                <span class="badge bg-danger">Critical Low</span>
                            </c:when>
                            <c:when test="${product.stock <= 20}">
                                <span class="badge bg-warning">Low Stock</span>
                            </c:when>
                            <c:when test="${product.stock <= 50}">
                                <span class="badge bg-info">Moderate</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-success">In Stock</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="" minFractionDigits="0"/> VNĐ
                    </td>
                    <td>
                        <fmt:formatNumber value="${productValue}" type="currency" currencySymbol="" minFractionDigits="0"/> VNĐ
                    </td>
                    <td>
                        <button type="button" class="btn btn-sm btn-outline-primary" 
                                onclick="openStockModal('${product.id}', '${product.name}', '${product.stock}')">
                            <i class="fas fa-edit"></i>
                        </button>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
        <tfoot>
            <tr class="table-info">
                <th colspan="6" class="text-end">Total Inventory Value:</th>
                <th><fmt:formatNumber value="${totalValue}" type="currency" currencySymbol="" minFractionDigits="0"/> VNĐ</th>
                <th></th>
            </tr>
        </tfoot>
    </table>
</div>

<c:if test="${empty products}">
    <div class="text-center py-5">
        <i class="fas fa-warehouse fa-3x text-muted mb-3"></i>
        <h5 class="text-muted">No products in inventory</h5>
        <p class="text-muted">Add products to start managing inventory.</p>
        <a href="<c:url value='/admin/products/add'/>" class="btn btn-primary">
            <i class="fas fa-plus me-2"></i>Add Product
        </a>
    </div>
</c:if>

<!-- Stock Update Modal -->
<div class="modal fade" id="stockModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Update Stock</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<c:url value='/admin/inventory/update-stock'/>" method="post">
                <div class="modal-body">
                    <input type="hidden" id="modalProductId" name="productId">
                    <div class="mb-3">
                        <label class="form-label">Product</label>
                        <p class="form-control-plaintext" id="modalProductName"></p>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Current Stock</label>
                        <p class="form-control-plaintext" id="modalCurrentStock"></p>
                    </div>
                    <div class="mb-3">
                        <label for="modalNewStock" class="form-label">New Stock Quantity</label>
                        <input type="number" class="form-control" id="modalNewStock" name="stock" min="0" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Update Stock</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function openStockModal(productId, productName, currentStock) {
    document.getElementById('modalProductId').value = productId;
    document.getElementById('modalProductName').textContent = productName;
    document.getElementById('modalCurrentStock').textContent = currentStock;
    document.getElementById('modalNewStock').value = currentStock;
    
    new bootstrap.Modal(document.getElementById('stockModal')).show();
}

// Auto-fill stock input when product is selected in quick update
document.getElementById('productSelect').addEventListener('change', function() {
    const selectedOption = this.options[this.selectedIndex];
    if (selectedOption.value) {
        const currentStock = selectedOption.getAttribute('data-current-stock');
        document.getElementById('newStock').value = currentStock;
    } else {
        document.getElementById('newStock').value = '';
    }
});
</script>
