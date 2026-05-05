package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(scanBasePackages = "com.example.demo")
public class CreditcoreBackendApplication {

	public static void main(String[] args) {
		SpringApplication.run(CreditcoreBackendApplication.class, args);
		System.out.println("Hi SpringBoot...:");
	}

}
