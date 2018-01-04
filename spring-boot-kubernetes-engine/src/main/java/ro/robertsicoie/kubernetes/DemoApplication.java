package ro.robertsicoie.kubernetes;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.http.HttpRequest;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Date;

@SpringBootApplication
@RestController
public class DemoApplication {

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}

	@GetMapping
	public String root() throws UnknownHostException {
		StringBuilder response = new StringBuilder();
		response.append("Time: " + new Date().toString()).append("</br>");
		response.append("Node: " + InetAddress.getLocalHost()).append("</br>");
		return response.toString();
	}
}
