package com.exemple;

import java.time.LocalDateTime;

public class App {
    public static void main(String[] args) {
        System.out.println("=== Application lancée avec succès via Jenkins ===");
        System.out.println("Date actuelle : " + LocalDateTime.now());
        System.out.println("Hello, Java World!");
    }
}