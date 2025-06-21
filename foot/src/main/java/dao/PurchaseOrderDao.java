package dao;

import model.PurchaseOrder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.ConnectionCallback;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import model.UserOrderView;

@Repository
public class PurchaseOrderDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    /**
     * Tạo một PurchaseOrder và trả về ID (auto-generated).
     */
    public Long create(PurchaseOrder order) {
        String sql =
                "INSERT INTO purchaseorder " +
                        "(user_id, shipping_name, shipping_phone, shipping_address, total_amount, status, payment_status) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?)";

        // Chỉ định rõ T = Long để tránh ambiguity
        return jdbcTemplate.<Long>execute((ConnectionCallback<Long>) conn -> {
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setLong(1, order.getUserId());
            ps.setString(2, order.getShippingName());
            ps.setString(3, order.getShippingPhone());
            ps.setString(4, order.getShippingAddress());
            ps.setBigDecimal(5, order.getTotalAmount());
            ps.setString(6, order.getStatus());
            ps.setString(7, order.getPaymentStatus());
            ps.executeUpdate();

            var rs = ps.getGeneratedKeys();
            return rs.next() ? rs.getLong(1) : null;
        });
    }

    public List<PurchaseOrder> findByUserId(Long userId) {
        String sql = "SELECT * FROM purchaseorder WHERE user_id = ? ORDER BY created_at DESC";
        return jdbcTemplate.query(sql, new RowMapper<PurchaseOrder>() {
            @Override
            public PurchaseOrder mapRow(ResultSet rs, int rowNum) throws SQLException {
                PurchaseOrder order = new PurchaseOrder();
                order.setId(rs.getLong("id"));
                order.setUserId(rs.getLong("user_id"));
                order.setShippingName(rs.getString("shipping_name"));
                order.setShippingPhone(rs.getString("shipping_phone"));
                order.setShippingAddress(rs.getString("shipping_address"));
                order.setTotalAmount(rs.getBigDecimal("total_amount"));
                order.setStatus(rs.getString("status"));
                order.setPaymentStatus(rs.getString("payment_status"));
                order.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                return order;
            }
        }, userId);
    }

    public List<UserOrderView> findUserOrderViewsByUserId(Long userId) {
        String sql = "SELECT po.id as order_id, po.created_at as order_date, " +
                     "po.shipping_name, po.shipping_phone, po.shipping_address, " +
                     "p.name as product_name, od.quantity, od.unit_price " +
                     "FROM purchaseorder po " +
                     "JOIN orderdetail od ON po.id = od.purchase_order_id " +
                     "JOIN product p ON od.product_id = p.id " +
                     "WHERE po.user_id = ? ORDER BY po.created_at DESC";

        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            UserOrderView view = new UserOrderView();
            view.setOrderId(rs.getLong("order_id"));
            view.setOrderDate(rs.getTimestamp("order_date").toLocalDateTime());
            view.setShippingName(rs.getString("shipping_name"));
            view.setShippingPhone(rs.getString("shipping_phone"));
            view.setShippingAddress(rs.getString("shipping_address"));
            view.setProductName(rs.getString("product_name"));
            view.setQuantity(rs.getInt("quantity"));
            // Calculate total amount for the order detail line
            view.setTotalAmount(rs.getBigDecimal("unit_price").multiply(java.math.BigDecimal.valueOf(rs.getInt("quantity"))));
            return view;
        }, userId);
    }
}
