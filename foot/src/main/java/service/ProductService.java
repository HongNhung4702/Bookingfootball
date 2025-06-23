package service;

import dao.ProductDao;
import dao.CategoryDao;
import model.Product;
import model.Category;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductService {

    @Autowired
    private ProductDao productDao;

    @Autowired
    private CategoryDao categoryDao;

    public List<Product> getAllProducts() {
        return productDao.findAll();
    }

    public Product getProductById(Long id) {
        return productDao.findById(id);
    }

    public List<Product> getProductsByCategory(Long categoryId) {
        return productDao.findByCategoryId(categoryId);
    }    public void saveProduct(Product product) {
        // Validate that name is not null or empty
        if (product.getName() == null || product.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Product name cannot be null or empty");
        }
        
        productDao.save(product);
    }

    public void deleteProduct(Long id) {
        productDao.deleteById(id);
    }

    public void updateStock(Long id, Integer stock) {
        productDao.updateStock(id, stock);
    }

    public List<Product> getLowStockProducts(int threshold) {
        return productDao.findLowStockProducts(threshold);
    }

    public List<Category> getAllCategories() {
        return categoryDao.findAll();
    }

    public Category getCategoryById(Long id) {
        return categoryDao.findById(id);
    }

    public void saveCategory(Category category) {
        categoryDao.save(category);
    }

    public void deleteCategory(Long id) {
        if (!categoryDao.hasProducts(id)) {
            categoryDao.deleteById(id);
        } else {
            throw new RuntimeException("Cannot delete category that has products");
        }
    }

    public boolean isCategoryNameExists(String name, Long excludeId) {
        Category existing = categoryDao.findByName(name);
        if (existing == null) {
            return false;
        }
        return excludeId == null || !existing.getId().equals(excludeId);
    }

    public List<Product> searchProductsByName(String keyword) {
        return productDao.searchByName(keyword);
    }
}
