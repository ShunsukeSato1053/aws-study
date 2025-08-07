package com.example.demo;

import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.*;

@SpringBootApplication
@RestController
public class Helloworld {

	@GetMapping("/")
	public String hello() {
		return "Hello World";
	}
}
