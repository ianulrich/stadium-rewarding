package com.example.stadium;

import jakarta.persistence.*;

@Entity
@Table(name = "stand")
public class Stand {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer standId;

    @Column(unique = true, nullable = false)
    private String name;

    @Column(name = "available_seats", nullable = false)
    private Integer availableSeats;

    @Column(name = "discount_price", nullable = false)
    private Double discountPrice;

    @Column(name = "reserved_seats", nullable = false)
    private String[] reservedSeats;

    // Getters and Setters
    public Integer getStandId() {
        return standId;
    }

    public void setStandId(Integer standId) {
        this.standId = standId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getAvailableSeats() {
        return availableSeats;
    }

    public void setAvailableSeats(Integer availableSeats) {
        this.availableSeats = availableSeats;
    }

    public Double getDiscountPrice() {
        return discountPrice;
    }

    public void setDiscountPrice(Double discountPrice) {
        this.discountPrice = discountPrice;
    }

    public String[] getReservedSeats() {
        return reservedSeats;
    }

    public void setReservedSeats(String[] reservedSeats) {
        this.reservedSeats = reservedSeats;
    }
}
