package ro.robertsicoie.appengine.daos;

import org.springframework.stereotype.Component;
import ro.robertsicoie.appengine.User;

import java.util.ArrayList;
import java.util.List;

@Component(value = "simpleUserDao")
public class SimpleUserDao implements UserDao {
    private List<User> users = new ArrayList<>();

    public void add(User user) {
        users.add(user);
    }

    public List<User> getUsers() {
        return users;
    }
}
