package com.yupi.yuaiagent.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/health")
public class HealthController {

    /**
     * 存活探针（返回固定 ok）
     */
    @GetMapping
    public String healthCheck() {
        return "ok";
    }
}
