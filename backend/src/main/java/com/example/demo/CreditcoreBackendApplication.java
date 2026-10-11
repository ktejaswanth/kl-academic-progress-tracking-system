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
		loadDotenv();
	}

	private static void loadDotenv() {
		try {
			java.nio.file.Path[] candidates = {
				java.nio.file.Paths.get(".env"),
				java.nio.file.Paths.get("..", ".env"),
				java.nio.file.Paths.get("..", "..", ".env")
			};
			for (java.nio.file.Path p : candidates) {
				if (java.nio.file.Files.exists(p)) {
					for (String line : java.nio.file.Files.readAllLines(p)) {
						line = line.trim();
						if (!line.isEmpty() && !line.startsWith("#") && line.contains("=")) {
							int eq = line.indexOf('=');
							String k = line.substring(0, eq).trim();
							String v = line.substring(eq + 1).trim();
							if (v.startsWith("\"") && v.endsWith("\"") && v.length() >= 2) {
								v = v.substring(1, v.length() - 1);
							} else if (v.startsWith("'") && v.endsWith("'") && v.length() >= 2) {
								v = v.substring(1, v.length() - 1);
							}
							if (k.equals("DB_PASSWORD")) {
								v = v.replace("$$", "$");
							}
							if (System.getProperty(k) == null && System.getenv(k) == null) {
								System.setProperty(k, v);
							}
						}
					}
					break;
				}
			}
		} catch (Exception ignored) {
		}
	}

	public static void main(String[] args) {
		IOUtils.setByteArrayMaxOverride(Integer.MAX_VALUE);
		ZipSecureFile.setMinInflateRatio(0.0);
		loadDotenv();
		SpringApplication.run(CreditcoreBackendApplication.class, args);
		System.out.println("Hi SpringBoot...:");
	}

}

