package ro.robertsicoie.appengine.daos;

import com.google.appengine.api.datastore.*;
import org.springframework.stereotype.Component;
import ro.robertsicoie.appengine.User;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Component("datastoreUserDao")
public class DatastoreUserDao implements UserDao {

    public static final String USER = "User";
    public static final String DATE = "date";
    public static final String AGENT = "agent";
    public static final String IP = "ip";

    private DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

    @Override
    public void add(User user) {
        Entity userEntity = new Entity(USER);
        userEntity.setProperty(IP, user.getIp());
        userEntity.setProperty(DATE, user.getDate());
        userEntity.setProperty(AGENT, user.getAgent());
        datastore.put(userEntity);
    }

    @Override
    public List<User> getUsers() {
        Query query = new Query(USER).addSort(DATE, Query.SortDirection.DESCENDING);
        QueryResultIterable<Entity> results = datastore.prepare(query).asQueryResultIterable();

        List<User> users = new ArrayList<>();
        results.forEach(userEntity -> users.add(toUser(userEntity)));

        return users;
    }

    private User toUser(Entity userEntity) {
        User user = new User();
        user.setIp((String) userEntity.getProperty(IP));
        user.setDate((Date) userEntity.getProperty(DATE));
        user.setAgent((String) userEntity.getProperty(AGENT));
        return user;
    }
}
