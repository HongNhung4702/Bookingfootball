package dao;

import model.PurchaseOrder;
import model.OrderAdminView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class AdminOrderDao {
    @Autowired private JdbcTemplate jdbcTemplate;

    public List<OrderAdminView> findAllOrders() {
        String sql =
                "SELECT o.id AS order_id, u.full_name AS userName, " +
                "  o.shipping_name, o.shipping_phone, o.shipping_address, " +
                "  o.total_amount, o.status, o.payment_status, o.created_at, " +
                "  od.product_id, p.name AS product_name, od.quantity, od.size " +
                "FROM purchaseorder o " +
                "JOIN user u ON o.user_id = u.id " +
                "JOIN orderdetail od ON o.id = od.purchase_order_id " +
                "JOIN product p ON od.product_id = p.id " +
                "ORDER BY o.created_at DESC";

        return jdbcTemplate.query(sql, new RowMapper<>() {
            @Override
            public OrderAdminView mapRow(ResultSet rs, int rowNum) throws SQLException {
                OrderAdminView v = new OrderAdminView();
                v.setOrderId(rs.getLong("order_id"));
                v.setUserName(rs.getString("userName"));
                v.setShippingName(rs.getString("shipping_name"));
                v.setShippingPhone(rs.getString("shipping_phone"));
                v.setShippingAddress(rs.getString("shipping_address"));
                v.setTotalAmount(rs.getBigDecimal("total_amount"));
                v.setStatus(rs.getString("status"));
                v.setPaymentStatus(rs.getString("payment_status"));
                v.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                v.setProductId(rs.getLong("product_id"));
                v.setProductName(rs.getString("product_name"));
                v.setQuantity(rs.getInt("quantity"));
                v.setSize(rs.getString("size"));
                return v;
            }
        });
    }
}
