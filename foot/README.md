# Football Booking System

Hệ thống đặt sân bóng đá được phát triển bằng Spring MVC và JDBC với Maven.

## Yêu cầu hệ thống

- Java 11 hoặc cao hơn
- Maven 3.6+ 
- MySQL 8.0+
- Apache Tomcat 10+ hoặc tương đương

## Cấu hình Database

1. Tạo database MySQL:
```sql
CREATE DATABASE bongdademo;
```

2. Cập nhật thông tin kết nối database trong file `src/main/resources/database.properties`:
```properties
db.url=jdbc:mysql://localhost:3306/bongdademo?useSSL=false&useUnicode=true&characterEncoding=UTF-8
db.username=root
db.password=your_password
```

## Cách chạy ứng dụng

### 1. Build project
```bash
mvn clean compile
```

### 2. Package thành file WAR
```bash
mvn clean package
```

### 3. Chạy với Jetty (development)
```bash
mvn jetty:run
```

### 4. Chạy với Tomcat (development)
```bash
mvn tomcat7:run
```

### 5. Deploy lên server
Copy file `target/foot.war` vào thư mục `webapps` của Tomcat server.

## Cấu trúc project

```
src/
├── main/
│   ├── java/
│   │   ├── config/          # Spring configuration
│   │   ├── controller/      # Spring MVC controllers
│   │   ├── dao/            # Data Access Objects
│   │   ├── model/          # Domain models
│   │   └── service/        # Business logic services
│   ├── resources/          # Configuration files
│   └── webapp/
│       ├── WEB-INF/
│       │   ├── views/      # JSP templates
│       │   └── web.xml     # Web configuration
│       └── images/         # Static resources
```

## Dependencies chính

- Spring Framework 6.1.15
- Spring MVC
- Spring JDBC
- MySQL Connector 8.3.0
- Jakarta Servlet API 6.1.0
- JSP & JSTL

## URLs

- Trang chủ: http://localhost:8080/foot/
- Đăng nhập: http://localhost:8080/foot/login
- Admin: http://localhost:8080/foot/admin
