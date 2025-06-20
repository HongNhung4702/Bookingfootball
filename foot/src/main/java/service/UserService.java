package service;

import dao.UserDao;
import model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    private UserDao userDao;

    public boolean login(String username, String password) {
        User user = userDao.findByUsername(username);
        return user != null && user.getPassword().equals(password);
    }

    public boolean register(User user) {
        if (userDao.findByUsername(user.getUsername()) != null) {
            return false; // Username already exists
        }
        if (userDao.findByEmail(user.getEmail()) != null) {
            return false; // Email already exists
        }
        userDao.save(user);
        return true;
    }
}