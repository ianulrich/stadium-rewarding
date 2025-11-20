package com.example.stadium;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface RewardRepository extends JpaRepository<Reward, Long> {
    List<Reward> findAllByOrderByPreferredStandAsc();
}