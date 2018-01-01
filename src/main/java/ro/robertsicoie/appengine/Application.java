package ro.robertsicoie.appengine;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import ro.robertsicoie.appengine.daos.UserDao;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;

@SpringBootApplication
@RestController
public class Application {

	@Autowired()
	@Qualifier("datastoreUserDao")
	private UserDao userDao;

	public static void main(String[] args) {
		SpringApplication.run(Application.class, args);
	}

	@GetMapping("/")
	public String root(HttpServletRequest request) {

		User user = new User();
		user.setIp(request.getRemoteAddr());
		user.setDate(new Date(request.getSession().getCreationTime()));
		user.setAgent(request.getHeader("User-Agent"));
		userDao.add(user);

		StringBuilder response = new StringBuilder();
		userDao.getUsers().forEach(u -> response.append(u).append("<br/>"));
		return response.toString();
	}
}
