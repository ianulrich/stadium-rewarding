package com.example.stadium;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface PreferenceRepository extends JpaRepository<Preference, Integer> {
    @Query("SELECT COUNT(*) FROM Preference p WHERE LOWER(p.firstName) = LOWER(:firstName) AND LOWER(p.lastName) = LOWER(:lastName)")
    long countByFirstNameAndLastNameIgnoreCase(String firstName, String lastName);
}