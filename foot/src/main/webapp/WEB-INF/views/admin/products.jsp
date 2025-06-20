<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Product Management</h2>
    <a href="<c:url value='/admin/products/add'/>" class="btn btn-primary">
        <i class="fas fa-plus me-2"></i>Add New Product
    </a>
</div>

<!-- Filter by Category -->
<div class="row mb-3">
    <div class="col-md-4">
        <select class="form-select" id="categoryFilter" onchange="filterByCategory()">
            <option value="">All Categories</option>
            <c:forEach var="category" items="${categories}">
                <option value="${category.id}">${category.name}</option>
            </c:forEach>
        </select>
    </div>
</div>

<!-- Products Table -->
<div class="table-responsive">
    <table class="table table-striped table-hover">
        <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Image</th>
                <th>Name</th>
                <th>Category</th>
                <th>Price</th>
                <th>Stock</th>
                <th>Created Date</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody id="productTableBody">
            <c:forEach var="product" items="${products}">
                <tr data-category-id="${product.categoryId}">
                    <td>${product.id}</td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty product.imageUrl}">
                                <img src="${pageContext.request.contextPath}${product.imageUrl}" alt="${product.name}" 
                                     class="img-thumbnail" style="width: 50px; height: 50px; object-fit: cover;">
                            </c:when>
                            <c:otherwise>
                                <div class="bg-secondary text-white d-flex align-items-center justify-content-center" 
                                     style="width: 50px; height: 50px; font-size: 12px;">
                                    No Image
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <strong>${product.name}</strong>
                        <c:if test="${not empty product.description}">
                            <br><small class="text-muted">${product.description}</small>
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
                        <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="$"/>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${product.stock <= 5}">
                                <span class="badge bg-danger">${product.stock}</span>
                            </c:when>
                            <c:when test="${product.stock <= 20}">
                                <span class="badge bg-warning">${product.stock}</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-success">${product.stock}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>                    <td>
                        ${product.formattedCreatedAt}
                    </td>
                    <td>
                        <div class="btn-group" role="group">
                            <a href="<c:url value='/admin/products/edit/${product.id}'/>" 
                               class="btn btn-sm btn-outline-primary" title="Edit">
                                <i class="fas fa-edit"></i>
                            </a>                            <button type="button" class="btn btn-sm btn-outline-danger" 
                                    onclick="confirmDelete('${product.id}', '${product.name}')" title="Delete">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<c:if test="${empty products}">
    <div class="text-center py-5">
        <i class="fas fa-box-open fa-3x text-muted mb-3"></i>
        <h5 class="text-muted">No products found</h5>
        <p class="text-muted">Start by adding your first product.</p>
        <a href="<c:url value='/admin/products/add'/>" class="btn btn-primary">
            <i class="fas fa-plus me-2"></i>Add Product
        </a>
    </div>
</c:if>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Confirm Delete</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete product "<span id="productName"></span>"?</p>
                <p class="text-danger">This action cannot be undone.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <form id="deleteForm" method="post" style="display: inline;">
                    <button type="submit" class="btn btn-danger">Delete</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
function filterByCategory() {
    const categoryId = document.getElementById('categoryFilter').value;
    const rows = document.querySelectorAll('#productTableBody tr');
    
    rows.forEach(row => {
        if (!categoryId || row.dataset.categoryId === categoryId) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
}

function confirmDelete(productId, productName) {
    document.getElementById('productName').textContent = productName;
    document.getElementById('deleteForm').action = '<c:url value="/admin/products/delete/"/>' + productId;
    new bootstrap.Modal(document.getElementById('deleteModal')).show();
}
</script>
