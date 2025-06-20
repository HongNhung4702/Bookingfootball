package dao;

import model.Product;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class ProductDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static final class ProductRowMapper implements RowMapper<Product> {
        @Override
        public Product mapRow(ResultSet rs, int rowNum) throws SQLException {
            Product product = new Product();
            product.setId(rs.getLong("id"));
            product.setName(rs.getString("name"));
            product.setDescription(rs.getString("description"));
            product.setPrice(rs.getDouble("price"));
            product.setStock(rs.getInt("stock"));
            product.setCategoryId(rs.getLong("category_id"));
            product.setImageUrl(rs.getString("image_url"));
            product.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
            return product;
        }
    }    public List<Product> findAll() {
        String sql = "SELECT * FROM Product ORDER BY created_at DESC";
        return jdbcTemplate.query(sql, new ProductRowMapper());
    }

    public Product findById(Long id) {
        String sql = "SELECT * FROM Product WHERE id = ?";
        List<Product> products = jdbcTemplate.query(sql, new ProductRowMapper(), id);
        return products.isEmpty() ? null : products.get(0);
    }

    public List<Product> findByCategoryId(Long categoryId) {
        String sql = "SELECT * FROM Product WHERE category_id = ? ORDER BY created_at DESC";
        return jdbcTemplate.query(sql, new ProductRowMapper(), categoryId);
    }    public void save(Product product) {
        if (product.getId() == null) {
            String sql = "INSERT INTO Product (name, description, price, stock, category_id, image_url, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)";
            jdbcTemplate.update(sql, product.getName(), product.getDescription(), product.getPrice(), 
                              product.getStock(), product.getCategoryId(), product.getImageUrl(), product.getCreatedAt());
        } else {
            String sql = "UPDATE Product SET name = ?, description = ?, price = ?, stock = ?, category_id = ?, image_url = ? WHERE id = ?";
            jdbcTemplate.update(sql, product.getName(), product.getDescription(), product.getPrice(), 
                              product.getStock(), product.getCategoryId(), product.getImageUrl(), product.getId());
        }
    }    public void deleteById(Long id) {
        String sql = "DELETE FROM Product WHERE id = ?";
        jdbcTemplate.update(sql, id);
    }

    public void updateStock(Long id, Integer stock) {
        String sql = "UPDATE Product SET stock = ? WHERE id = ?";
        jdbcTemplate.update(sql, stock, id);
    }

    public List<Product> findLowStockProducts(int threshold) {
        String sql = "SELECT * FROM Product WHERE stock <= ? ORDER BY stock ASC";
        return jdbcTemplate.query(sql, new ProductRowMapper(), threshold);
    }
}
