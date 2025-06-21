<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="row justify-content-center">
    <div class="col-md-8">
        <h2>${isEdit ? 'Edit Stadium' : 'Add Stadium'}</h2>
        <form action="<c:url value='/admin/stadiums/save'/>" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id" value="${stadium.id}"/>
            <div class="mb-3">
                <label for="name" class="form-label">Stadium Name</label>
                <input type="text" class="form-control" id="name" name="name" value="${stadium.name}" required>
            </div>
            <div class="mb-3">
                <label for="address" class="form-label">Address</label>
                <input type="text" class="form-control" id="address" name="address" value="${stadium.address}" required>
            </div>
            <div class="mb-3">
                <label for="pricePerHour" class="form-label">Price per Hour (VND)</label>
                <input type="number" class="form-control" id="pricePerHour" name="pricePerHour" value="${stadium.pricePerHour}" min="0" step="1000" required>
            </div>
            <div class="mb-3">
                <label for="fieldType" class="form-label">Field Type</label>
                <select class="form-select" id="fieldType" name="fieldType" required>
                    <option value="" disabled ${stadium.fieldType == null ? 'selected' : ''}>-- Select Field Type --</option>
                    <c:forEach var="type" items="${fieldTypes}">
                        <option value="${type.name()}" ${stadium.fieldType == type ? 'selected' : ''}>${type}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="mb-3">
                <label for="description" class="form-label">Description</label>
                <textarea class="form-control" id="description" name="description" rows="3">${stadium.description}</textarea>
            </div>
            <div class="mb-3">
                <label for="imageFile" class="form-label">Image</label>
                <input type="file" class="form-control" id="imageFile" name="imageFile" accept="image/*">
                <c:if test="${isEdit && not empty stadium.imageUrl}">
                    <div class="mt-2">
                        <img src="${pageContext.request.contextPath}${stadium.imageUrl}" alt="Current Image" style="max-width: 200px; max-height: 150px;">
                        <input type="hidden" name="existingImageUrl" value="${stadium.imageUrl}"/>
                    </div>
                </c:if>
            </div>
            <div class="d-flex justify-content-between">
                <a href="<c:url value='/admin/stadiums'/>" class="btn btn-secondary">Cancel</a>
                <button type="submit" class="btn btn-success">${isEdit ? 'Update' : 'Add'} Stadium</button>
            </div>
        </form>
    </div>
</div> 