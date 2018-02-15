package ro.robertsicoie.kubernetes;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Date;

@SpringBootApplication
@RestController
public class DemoApplication {

	private static final Logger LOG = LoggerFactory.getLogger(DemoApplication.class);

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}

	@GetMapping
	public String root() throws UnknownHostException {
		StringBuilder response = new StringBuilder();
		response.append("Time: " + new Date().toString()).append("</br>");
		response.append("Node: " + InetAddress.getLocalHost()).append("</br>");
		LOG.info(response.toString());
		return response.toString();
	}
}
