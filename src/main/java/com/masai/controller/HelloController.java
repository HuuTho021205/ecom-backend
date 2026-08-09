package com.masai.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    @GetMapping("api/public/test")
    public String TestCICD(){
        return "hello manual ci/cd ";
    }
}
