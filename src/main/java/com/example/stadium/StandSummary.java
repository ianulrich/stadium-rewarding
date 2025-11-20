package com.example.stadium;

public record StandSummary(String stand, int availableSeats, long numberOfPreferredSeats, double discountPrice, double estimatedTotalEarnings) {}