<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="row justify-content-center">
    <div class="col-md-6">
        <div class="card">
            <div class="card-header">
                <h4 class="mb-0">
                    <c:choose>
                        <c:when test="${isEdit}">
                            <i class="fas fa-edit me-2"></i>Edit Category
                        </c:when>
                        <c:otherwise>
                            <i class="fas fa-plus me-2"></i>Add New Category
                        </c:otherwise>
                    </c:choose>
                </h4>
            </div>
            <div class="card-body">
                <form action="<c:url value='/admin/categories/save'/>" method="post">
                    <c:if test="${isEdit}">
                        <input type="hidden" name="id" value="${category.id}">
                    </c:if>
                    
                    <div class="mb-3">
                        <label for="name" class="form-label">Category Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="name" name="name" 
                               value="${category.name}" required maxlength="100"
                               placeholder="e.g., Football Shoes, Balls, Jerseys">
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control" id="description" name="description" 
                                  rows="3" maxlength="500"
                                  placeholder="Optional description for this category">${category.description}</textarea>
                        <div class="form-text">Optional category description (max 500 characters)</div>
                    </div>

                    <div class="d-flex justify-content-between">
                        <a href="<c:url value='/admin/categories'/>" class="btn btn-secondary">
                            <i class="fas fa-arrow-left me-2"></i>Back to Categories
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <c:choose>
                                <c:when test="${isEdit}">
                                    <i class="fas fa-save me-2"></i>Update Category
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-plus me-2"></i>Add Category
                                </c:otherwise>
                            </c:choose>
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Common Categories Suggestions (only for new categories) -->
        <c:if test="${not isEdit}">
            <div class="card mt-4">
                <div class="card-header">
                    <h6 class="mb-0">
                        <i class="fas fa-lightbulb me-2"></i>Common Football Equipment Categories
                    </h6>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <ul class="list-unstyled">
                                <li><a href="#" onclick="fillCategory('Football Shoes', 'Professional and amateur football footwear')">Football Shoes</a></li>
                                <li><a href="#" onclick="fillCategory('Footballs', 'Official and training footballs')">Footballs</a></li>
                                <li><a href="#" onclick="fillCategory('Jerseys', 'Team jerseys and training shirts')">Jerseys</a></li>
                                <li><a href="#" onclick="fillCategory('Shorts', 'Football shorts and training pants')">Shorts</a></li>
                            </ul>
                        </div>
                        <div class="col-md-6">
                            <ul class="list-unstyled">
                                <li><a href="#" onclick="fillCategory('Socks', 'Football socks and stockings')">Socks</a></li>
                                <li><a href="#" onclick="fillCategory('Shin Guards', 'Protective shin guards')">Shin Guards</a></li>
                                <li><a href="#" onclick="fillCategory('Gloves', 'Goalkeeper gloves')">Gloves</a></li>
                                <li><a href="#" onclick="fillCategory('Accessories', 'Training equipment and accessories')">Accessories</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
    </div>
</div>

<script>
function fillCategory(name, description) {
    document.getElementById('name').value = name;
    document.getElementById('description').value = description;
    event.preventDefault();
}

// Character counter for description
document.getElementById('description').addEventListener('input', function() {
    const maxLength = 500;
    const currentLength = this.value.length;
    const remaining = maxLength - currentLength;
    
    let counter = document.getElementById('descriptionCounter');
    if (!counter) {
        counter = document.createElement('div');
        counter.id = 'descriptionCounter';
        counter.className = 'form-text';
        this.parentNode.appendChild(counter);
    }
    
    counter.textContent = remaining + ' characters remaining';
    counter.className = remaining < 0 ? 'form-text text-danger' : 'form-text text-muted';
});
</script>
