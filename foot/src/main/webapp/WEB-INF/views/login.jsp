<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
    .input-eye-wrapper {
        position: relative;
    }
    .input-eye-wrapper input[type="password"],
    .input-eye-wrapper input[type="text"] {
        padding-right: 2.5rem;
    }
    .input-eye-btn {
        position: absolute;
        top: 50%;
        right: 0.75rem;
        transform: translateY(-50%);
        border: none;
        background: transparent;
        box-shadow: none;
        outline: none;
        padding: 0;
        display: flex;
        align-items: center;
        cursor: pointer;
    }
    .input-eye-btn:focus {
        box-shadow: none;
        outline: none;
    }
    .input-eye-btn .fa-eye, .input-eye-btn .fa-eye-slash {
        color: #888;
        font-size: 1.1rem;
        transition: color 0.2s;
    }
    .input-eye-btn:hover .fa-eye,
    .input-eye-btn:hover .fa-eye-slash {
        color: #333;
    }
    </style>
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="card shadow-sm mx-auto" style="max-width: 400px;">
            <div class="card-body">
                <h3 class="card-title text-center mb-4">Login</h3>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>
                <form action="<c:url value='/login'/>" method="post">
                    <div class="mb-3">
                        <label for="username" class="form-label">Username</label>
                        <input type="text" class="form-control" id="username" name="username" required>
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label">Password</label>
                        <div class="input-eye-wrapper">
                            <input type="password" class="form-control" id="password" name="password" required>
                            <button type="button" class="input-eye-btn" tabindex="-1" onclick="togglePassword('password', this)">
                                <span class="fa fa-eye"></span>
                            </button>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary w-100">Login</button>
                </form>
                <div class="mt-3 text-center">
                    <small>Don't have an account? <a href="<c:url value='/register'/>">Register here</a></small>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"></script>
    <script>
    function togglePassword(inputId, btn) {
        const input = document.getElementById(inputId);
        if (input.type === 'password') {
            input.type = 'text';
            btn.querySelector('span').classList.remove('fa-eye');
            btn.querySelector('span').classList.add('fa-eye-slash');
        } else {
            input.type = 'password';
            btn.querySelector('span').classList.remove('fa-eye-slash');
            btn.querySelector('span').classList.add('fa-eye');
        }
    }
    </script>
</body>
</html>
