package com.example.demo;

import org.apache.poi.openxml4j.util.ZipSecureFile;
import org.apache.poi.util.IOUtils;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(scanBasePackages = "com.example.demo")
public class CreditcoreBackendApplication {

	static {
		// Allow Apache POI to process large/complex Excel files
		IOUtils.setByteArrayMaxOverride(Integer.MAX_VALUE);
		ZipSecureFile.setMinInflateRatio(0.0);
	}

	public static void main(String[] args) {
		IOUtils.setByteArrayMaxOverride(Integer.MAX_VALUE);
		ZipSecureFile.setMinInflateRatio(0.0);
		SpringApplication.run(CreditcoreBackendApplication.class, args);
		System.out.println("Hi SpringBoot...:");
	}

}
