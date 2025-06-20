package dao;

import model.OrderDetail;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class OrderDetailDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    /**
     * Tạo một OrderDetail.
     * @return số dòng bị ảnh hưởng (thường là 1).
     */
    public int create(OrderDetail detail) {
        String sql =
                "INSERT INTO OrderDetail " +
                        "(purchase_order_id, product_id, quantity, unit_price) " +
                        "VALUES (?, ?, ?, ?)";
        return jdbcTemplate.update(
                sql,
                detail.getPurchaseOrderId(),
                detail.getProductId(),
                detail.getQuantity(),
                detail.getUnitPrice()
        );
    }
}
