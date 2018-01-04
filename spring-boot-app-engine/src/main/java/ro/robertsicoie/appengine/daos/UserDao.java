package ro.robertsicoie.appengine.daos;

import ro.robertsicoie.appengine.User;

import java.util.List;

public interface UserDao {
    void add(User user);

    List<User> getUsers();
}
