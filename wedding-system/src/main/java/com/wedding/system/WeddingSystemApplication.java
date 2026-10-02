package com.wedding.system;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

/**
 * Entry point of the Wedding Hotel Reservation System.
 *
 * Run with:  mvn spring-boot:run
 * Then open: http://localhost:8080/login
 */
@SpringBootApplication
public class WeddingSystemApplication extends SpringBootServletInitializer {

    public static void main(String[] args) {
        SpringApplication.run(WeddingSystemApplication.class, args);
    }

    // Needed so the app can also be deployed as a .war on an external Tomcat.
    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
        return builder.sources(WeddingSystemApplication.class);
    }
}
