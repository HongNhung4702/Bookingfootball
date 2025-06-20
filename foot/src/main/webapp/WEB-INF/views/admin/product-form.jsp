<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="row justify-content-center">
    <div class="col-md-8">
        <div class="card">
            <div class="card-header">
                <h4 class="mb-0">
                    <c:choose>
                        <c:when test="${isEdit}">
                            <i class="fas fa-edit me-2"></i>Edit Product
                        </c:when>
                        <c:otherwise>
                            <i class="fas fa-plus me-2"></i>Add New Product
                        </c:otherwise>
                    </c:choose>
                </h4>
            </div>
            <div class="card-body">
                <form action="<c:url value='/admin/products/save'/>" method="post" enctype="multipart/form-data">
                    <c:if test="${isEdit}">
                        <input type="hidden" name="id" value="${product.id}">
                    </c:if>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="name" class="form-label">Product Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="name" name="name" 
                                       value="${product.name}" required maxlength="255">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="categoryId" class="form-label">Category <span class="text-danger">*</span></label>
                                <select class="form-select" id="categoryId" name="categoryId" required>
                                    <option value="">Select Category</option>
                                    <c:forEach var="category" items="${categories}">
                                        <option value="${category.id}" 
                                                <c:if test="${category.id == product.categoryId}">selected</c:if>>
                                            ${category.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="price" class="form-label">Price ($) <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" id="price" name="price" 
                                       value="${product.price}" min="0" step="0.01" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="stock" class="form-label">Stock Quantity <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" id="stock" name="stock" 
                                       value="${product.stock}" min="0" required>
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control" id="description" name="description" 
                                  rows="3" maxlength="1000">${product.description}</textarea>
                        <div class="form-text">Optional product description (max 1000 characters)</div>
                    </div>                    <div class="mb-3">
                        <label for="imageFile" class="form-label">Product Image</label>
                        <input type="file" class="form-control" id="imageFile" name="imageFile" 
                               accept="image/*" onchange="previewImage(this)">
                        <div class="form-text">Upload an image file (JPG, PNG, GIF). Maximum size: 5MB</div>
                        
                        <!-- Image Preview -->
                        <div id="imagePreviewContainer" class="mt-3" style="display: none;">
                            <label class="form-label">Preview</label>
                            <div>
                                <img id="imagePreview" src="" alt="Preview" 
                                     class="img-thumbnail" style="max-width: 200px; max-height: 200px;">
                                <button type="button" class="btn btn-sm btn-danger ms-2" 
                                        onclick="removeImagePreview()">
                                    <i class="fas fa-times"></i> Remove
                                </button>
                            </div>
                        </div>
                        
                        <!-- Hidden field to keep existing image URL for edit mode -->
                        <c:if test="${isEdit}">
                            <input type="hidden" name="existingImageUrl" value="${product.imageUrl}">
                        </c:if>
                    </div>

                    <c:if test="${isEdit and not empty product.imageUrl}">
                        <div class="mb-3">
                            <label class="form-label">Current Image</label>
                            <div>
                                <img src="${pageContext.request.contextPath}${product.imageUrl}" alt="${product.name}" 
                                     class="img-thumbnail" style="max-width: 200px; max-height: 200px;">
                            </div>
                        </div>
                    </c:if>

                    <div class="d-flex justify-content-between">
                        <a href="<c:url value='/admin/products'/>" class="btn btn-secondary">
                            <i class="fas fa-arrow-left me-2"></i>Back to Products
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <c:choose>
                                <c:when test="${isEdit}">
                                    <i class="fas fa-save me-2"></i>Update Product
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-plus me-2"></i>Add Product
                                </c:otherwise>
                            </c:choose>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
// Preview image when file is selected
function previewImage(input) {
    const file = input.files[0];
    const previewContainer = document.getElementById('imagePreviewContainer');
    const previewImg = document.getElementById('imagePreview');
    const urlInput = document.getElementById('imageUrl');
    
    if (file) {
        // Clear URL input when file is selected
        urlInput.value = '';
        
        // Check file size (5MB max)
        if (file.size > 5 * 1024 * 1024) {
            alert('File size must be less than 5MB');
            input.value = '';
            previewContainer.style.display = 'none';
            return;
        }
        
        // Check file type
        if (!file.type.startsWith('image/')) {
            alert('Please select an image file');
            input.value = '';
            previewContainer.style.display = 'none';
            return;
        }
        
        const reader = new FileReader();
        reader.onload = function(e) {
            previewImg.src = e.target.result;
            previewContainer.style.display = 'block';
        };
        reader.readAsDataURL(file);
    } else {
        previewContainer.style.display = 'none';
    }
}

// Preview image when URL is entered
function previewUrlImage(input) {
    const url = input.value.trim();
    const previewContainer = document.getElementById('imagePreviewContainer');
    const previewImg = document.getElementById('imagePreview');
    const fileInput = document.getElementById('imageFile');
    
    if (url) {
        // Clear file input when URL is entered
        fileInput.value = '';
        
        // Test if URL is valid image
        const img = new Image();
        img.onload = function() {
            previewImg.src = url;
            previewContainer.style.display = 'block';
        };
        img.onerror = function() {
            previewContainer.style.display = 'none';
        };
        img.src = url;
    } else {
        previewContainer.style.display = 'none';
    }
}

// Remove image preview
function removeImagePreview() {
    const previewContainer = document.getElementById('imagePreviewContainer');
    const fileInput = document.getElementById('imageFile');
    const urlInput = document.getElementById('imageUrl');
    
    previewContainer.style.display = 'none';
    fileInput.value = '';
    urlInput.value = '';
}

// Show existing image preview on page load for edit mode
document.addEventListener('DOMContentLoaded', function() {
    const urlInput = document.getElementById('imageUrl');
    if (urlInput.value.trim()) {
        previewUrlImage(urlInput);
    }
});

// Character counter for description
document.getElementById('description').addEventListener('input', function() {
    const maxLength = 1000;
    const currentLength = this.value.length;
    const remaining = maxLength - currentLength;
    
    let counter = document.getElementById('descriptionCounter');
    if (!counter) {
        counter = document.createElement('div');
        counter.id = 'descriptionCounter';
        counter.className = 'form-text';
        this.parentNode.appendChild(counter);
    }
    
    counter.textContent = `${remaining} characters remaining`;
    counter.className = remaining < 0 ? 'form-text text-danger' : 'form-text text-muted';
});

// Form validation before submit
document.querySelector('form').addEventListener('submit', function(e) {
    const fileInput = document.getElementById('imageFile');
    const urlInput = document.getElementById('imageUrl');
    
    // If both file and URL are provided, file takes precedence
    if (fileInput.files.length > 0 && urlInput.value.trim()) {
        urlInput.value = ''; // Clear URL if file is selected
    }
});
</script>
