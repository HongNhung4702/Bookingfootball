package service;

import dao.AdminOrderDao;
import model.PurchaseOrder;
import model.OrderAdminView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AdminOrderService {

    @Autowired
    private AdminOrderDao orderDao;

    public List<OrderAdminView> listAllOrders() {
        return orderDao.findAllOrders();
    }
}
