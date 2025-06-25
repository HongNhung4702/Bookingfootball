package dao;

import model.Category;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class CategoryDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static final class CategoryRowMapper implements RowMapper<Category> {
        @Override
        public Category mapRow(ResultSet rs, int rowNum) throws SQLException {
            Category category = new Category();
            category.setId(rs.getLong("id"));
            category.setName(rs.getString("name"));
            category.setDescription(rs.getString("description"));
            return category;
        }
    }   
    public List<Category> findAll() {
        String sql = "SELECT * FROM Category ORDER BY name";
        return jdbcTemplate.query(sql, new CategoryRowMapper());
    }

    public Category findById(Long id) {
        String sql = "SELECT * FROM Category WHERE id = ?";
        List<Category> categories = jdbcTemplate.query(sql, new CategoryRowMapper(), id);
        return categories.isEmpty() ? null : categories.get(0);
    }

    public Category findByName(String name) {
        String sql = "SELECT * FROM Category WHERE name = ?";
        List<Category> categories = jdbcTemplate.query(sql, new CategoryRowMapper(), name);
        return categories.isEmpty() ? null : categories.get(0);
    }
    public void save(Category category) {
        if (category.getId() == null) {
            String sql = "INSERT INTO Category (name, description) VALUES (?, ?)";
            jdbcTemplate.update(sql, category.getName(), category.getDescription());
        } else {
            String sql = "UPDATE Category SET name = ?, description = ? WHERE id = ?";
            jdbcTemplate.update(sql, category.getName(), category.getDescription(), category.getId());
        }
    }

    public void deleteById(Long id) {
        String sql = "DELETE FROM Category WHERE id = ?";
        jdbcTemplate.update(sql, id);
    }

    public boolean hasProducts(Long categoryId) {
        String sql = "SELECT COUNT(*) FROM Product WHERE category_id = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, categoryId);
        return count != null && count > 0;
    }
}
