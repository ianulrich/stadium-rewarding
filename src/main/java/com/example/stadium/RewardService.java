package com.example.stadium;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class RewardService {

    @Autowired private PreferenceRepository preferenceRepository;
    @Autowired private RewardRepository rewardRepository;

    private final Random random = new Random();

    // Seat counters for each stand
    private int seatEast = 1, seatWest = 1, seatSouth = 1, seatNorth = 1;

    /**
     * Main entry point: clears old results and runs full rewarding process
     */
    public void runRewardingProcess() {
        // 1. Clear previous results
        rewardRepository.deleteAll();

        // Reset seat counters
        seatEast = seatWest = seatSouth = seatNorth = 1;

        // 2. Load all preferences
        List<Preference> allPrefs = preferenceRepository.findAll();
        if (allPrefs.isEmpty()) {
            return; // nothing to do
        }

        // 3. Group by stand
        Map<String, List<Preference>> byStand = allPrefs.stream()
                .collect(Collectors.groupingBy(Preference::getStandName));

        // 4. Process each stand
        processEast(byStand.getOrDefault("EAST", List.of()));
        processWest(byStand.getOrDefault("WEST", List.of()));
        processSouth(byStand.getOrDefault("SOUTH", List.of()));
        processNorth(byStand.getOrDefault("NORTH", List.of()));
    }

    // EAST: First 3 by earliest reservation time
    private void processEast(List<Preference> fans) {
        fans.stream()
            .sorted(Comparator.comparing(Preference::getReservationTime))
            .limit(3)
            .forEach(p -> saveReward(p, "EAST", seatEast++));
    }

    // WEST: First 3 by earliest reservation time
    private void processWest(List<Preference> fans) {
        fans.stream()
            .sorted(Comparator.comparing(Preference::getReservationTime))
            .limit(3)
            .forEach(p -> saveReward(p, "WEST", seatWest++));
    }

    // SOUTH: Random 5
    private void processSouth(List<Preference> fans) {
        if (fans.isEmpty()) return;
        Collections.shuffle(fans, random);
        fans.stream().limit(5)
            .forEach(p -> saveReward(p, "SOUTH", seatSouth++));
    }

    // NORTH: Weighted random (MLT = 0.8, Others = 0.2)
    private void processNorth(List<Preference> fans) {
        if (fans.isEmpty()) return;

        List<Preference> weighted = new ArrayList<>();
        for (Preference p : fans) {
            if ("MLT".equals(p.getOccupationCode())) {
                // 4 entries → 80% chance
                weighted.add(p); weighted.add(p); weighted.add(p); weighted.add(p);
            } else {
                // 1 entry → 20% chance
                weighted.add(p);
            }
        }

        Collections.shuffle(weighted, random);
        weighted.stream()
                .distinct()  // prevent same person getting multiple seats
                .limit(3)
                .forEach(p -> saveReward(p, "NORTH", seatNorth++));
    }

    // ENHANCED: Safe save with error logging
    private void saveReward(Preference p, String stand, int seat) {
        if (p == null) {
            System.err.println("saveReward: Preference is null for stand " + stand);
            return;
        }

        Reward r = new Reward();
        r.setFirstName(p.getFirstName());
        r.setLastName(p.getLastName());
        r.setEmail(p.getEmail());
        r.setPhone(p.getPhone());
        r.setPreferredStand(stand);
        r.setSeat(seat);

        try {
            rewardRepository.save(r);
        } catch (Exception e) {
            System.err.println("Failed to save reward for " + p.getFirstName() + " " + p.getLastName() +
                               " (Stand: " + stand + ", Seat: " + seat + "): " + e.getMessage());
            e.printStackTrace();
        }
    }
}