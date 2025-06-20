package dao;

import model.Stadium;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class StadiumDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static final class StadiumRowMapper implements RowMapper<Stadium> {
        @Override
        public Stadium mapRow(ResultSet rs, int rowNum) throws SQLException {
            Stadium stadium = new Stadium();
            stadium.setId(rs.getLong("id"));
            stadium.setName(rs.getString("name"));
            stadium.setAddress(rs.getString("address"));
            stadium.setPricePerHour(rs.getDouble("price_per_hour"));
            stadium.setDescription(rs.getString("description"));
            stadium.setImageUrl(rs.getString("image_url"));
            stadium.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
            return stadium;
        }
    }

    public List<Stadium> findAll() {
        String sql = "SELECT * FROM Stadium ORDER BY created_at DESC";
        return jdbcTemplate.query(sql, new StadiumRowMapper());
    }

    public Stadium findById(Long id) {
        String sql = "SELECT * FROM Stadium WHERE id = ?";
        List<Stadium> stadiums = jdbcTemplate.query(sql, new StadiumRowMapper(), id);
        return stadiums.isEmpty() ? null : stadiums.get(0);
    }

    public void save(Stadium stadium) {
        if (stadium.getId() == null) {
            String sql = "INSERT INTO Stadium (name, address, price_per_hour, description, image_url, created_at) VALUES (?, ?, ?, ?, ?, ?)";
            jdbcTemplate.update(sql, stadium.getName(), stadium.getAddress(), stadium.getPricePerHour(), 
                              stadium.getDescription(), stadium.getImageUrl(), stadium.getCreatedAt());
        } else {
            String sql = "UPDATE Stadium SET name = ?, address = ?, price_per_hour = ?, description = ?, image_url = ? WHERE id = ?";
            jdbcTemplate.update(sql, stadium.getName(), stadium.getAddress(), stadium.getPricePerHour(), 
                              stadium.getDescription(), stadium.getImageUrl(), stadium.getId());
        }
    }

    public void deleteById(Long id) {
        String sql = "DELETE FROM Stadium WHERE id = ?";
        jdbcTemplate.update(sql, id);
    }
}
