package com.example.stadium;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;

public interface StandRepository extends JpaRepository<Stand, Integer> {
    @Query(value = "SELECT s.name AS stand, s.available_seats, COALESCE(COUNT(p.stand_name), 0) AS number_of_preferred_seats, " +
                   "s.discount_price, LEAST(COALESCE(COUNT(p.stand_name), 0), s.available_seats) * s.discount_price AS estimated_total_earnings " +
                   "FROM stand s LEFT JOIN preference p ON s.name = p.stand_name " +
                   "GROUP BY s.name, s.available_seats, s.discount_price " +
                   "ORDER BY CASE s.name WHEN 'EAST' THEN 1 WHEN 'WEST' THEN 2 WHEN 'SOUTH' THEN 3 WHEN 'NORTH' THEN 4 END",
           nativeQuery = true)
    List<Object[]> getPreferenceSummary();
}