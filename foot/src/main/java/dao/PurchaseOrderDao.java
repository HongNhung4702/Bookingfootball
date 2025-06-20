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
}
