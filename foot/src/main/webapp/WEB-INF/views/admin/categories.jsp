<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Category Management</h2>
    <a href="<c:url value='/admin/categories/add'/>" class="btn btn-primary">
        <i class="fas fa-plus me-2"></i>Add New Category
    </a>
</div>

<!-- Categories Table -->
<div class="table-responsive">
    <table class="table table-striped table-hover">
        <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Description</th>
                <th>Product Count</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="category" items="${categories}">
                <tr>
                    <td>${category.id}</td>
                    <td>
                        <strong>${category.name}</strong>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty category.description}">
                                ${category.description}
                            </c:when>
                            <c:otherwise>
                                <span class="text-muted">No description</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <span class="badge bg-info" id="productCount_${category.id}">
                            <!-- Product count will be populated by JavaScript -->
                            Loading...
                        </span>
                    </td>
                    <td>
                        <div class="btn-group" role="group">
                            <a href="<c:url value='/admin/categories/edit/${category.id}'/>" 
                               class="btn btn-sm btn-outline-primary" title="Edit">
                                <i class="fas fa-edit"></i>
                            </a>
                            <button type="button" class="btn btn-sm btn-outline-danger" 
                                    onclick="confirmDelete('${category.id}', '${category.name}')" 
                                    title="Delete" id="deleteBtn_${category.id}">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<c:if test="${empty categories}">
    <div class="text-center py-5">
        <i class="fas fa-tags fa-3x text-muted mb-3"></i>
        <h5 class="text-muted">No categories found</h5>
        <p class="text-muted">Start by adding your first category.</p>
        <a href="<c:url value='/admin/categories/add'/>" class="btn btn-primary">
            <i class="fas fa-plus me-2"></i>Add Category
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
                <p>Are you sure you want to delete category "<span id="categoryName"></span>"?</p>
                <div id="deleteWarning" class="alert alert-warning" style="display: none;">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    This category contains products. Please move or delete all products first.
                </div>
                <p class="text-danger">This action cannot be undone.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <form id="deleteForm" method="post" style="display: inline;">
                    <button type="submit" class="btn btn-danger" id="confirmDeleteBtn">Delete</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
function confirmDelete(categoryId, categoryName) {
    document.getElementById('categoryName').textContent = categoryName;
    document.getElementById('deleteForm').action = '<c:url value="/admin/categories/delete/"/>' + categoryId;
    new bootstrap.Modal(document.getElementById('deleteModal')).show();
}
</script>
