package com.example.stadium;

import jakarta.annotation.PostConstruct;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeFormatterBuilder;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class StandService {

    @Autowired private StandRepository standRepository;
    @Autowired private PreferenceRepository preferenceRepository;

    private static final List<String> VALID_STANDS = List.of("EAST","WEST","SOUTH","NORTH");
    private static final List<String> VALID_OCCUPATIONS = List.of("STU","EDU","MLT","OTH");

    private static final DateTimeFormatter DATE_TIME_FORMATTER = new DateTimeFormatterBuilder()
            .appendPattern("yyyy-MM-dd[ ]")
            .appendPattern("HH:mm:ss")
            .optionalStart().appendPattern(".SSS").optionalEnd()
            .optionalStart().appendPattern(".SSSSSS").optionalEnd()
            .toFormatter();

    @PostConstruct public void init() { /* stands already in DB */ }

    /* ----------  SUMMARY  ---------- */
    public List<StandSummary> getPreferenceSummary() {
        return standRepository.getPreferenceSummary().stream()
                .map(row -> new StandSummary(
                        (String) row[0],
                        ((Number) row[1]).intValue(),
                        ((Number) row[2]).longValue(),
                        ((Number) row[3]).doubleValue(),
                        ((Number) row[4]).doubleValue()))
                .collect(Collectors.toList());
    }

    /* ----------  SINGLE ADD (used by Add, Import, Append) ---------- */
    public String addPreference(String firstName, String lastName, String email,
                                String phone, String occupationCode, String standName,
                                String reservationTime) {

        // ---- validation ----
        if (firstName == null || firstName.trim().isEmpty() ||
            lastName == null || lastName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            occupationCode == null || !VALID_OCCUPATIONS.contains(occupationCode) ||
            standName == null || !VALID_STANDS.contains(standName) ||
            reservationTime == null || reservationTime.trim().isEmpty()) {
            return "All fields are required and must be valid.";
        }

        // ---- duplicate name check (returns null if OK) ----
        if (preferenceRepository.countByFirstNameAndLastNameIgnoreCase(firstName, lastName) > 0) {
            return "Duplicate: " + firstName + " " + lastName;
        }

        // ---- parse time ----
        LocalDateTime parsedTime;
        try {
            parsedTime = LocalDateTime.parse(reservationTime, DATE_TIME_FORMATTER);
        } catch (Exception e) {
            return "Invalid reservation time format. Use yyyy-MM-dd HH:mm:ss.SSS or yyyy-MM-dd HH:mm:ss.";
        }

        // ---- save ----
        Preference p = new Preference();
        p.setFirstName(firstName);
        p.setLastName(lastName);
        p.setEmail(email);
        p.setPhone(phone);
        p.setOccupationCode(occupationCode);
        p.setStandName(standName);
        p.setReservationTime(parsedTime);
        preferenceRepository.save(p);
        return null; // success
    }

    /* ----------  REGULAR IMPORT (replaces everything) ---------- */
    public String importPreferences(MultipartFile file) {
        if (file == null || file.isEmpty()) return "Please upload a valid CSV file.";

        try (CSVParser parser = CSVParser.parse(
                file.getInputStream(), StandardCharsets.UTF_8,
                CSVFormat.DEFAULT.withHeader())) {

            preferenceRepository.deleteAll();               // <-- clears old data

            int added = 0;
            for (var rec : parser) {
                String err = addPreference(
                        rec.get("firstName"), rec.get("lastName"),
                        rec.get("email"), rec.get("phone"),
                        rec.get("occupationCode"), rec.get("standName"),
                        rec.get("reservationTime"));
                if (err == null) added++;
            }
            return "Imported " + added + " preference(s). Existing data cleared.";
        } catch (IOException e) {
            return "Failed to parse CSV: " + e.getMessage();
        }
    }

    /* ----------  IMPORT AND APPEND (adds only non-duplicates) ---------- */
    public String importAndAppend(MultipartFile file) {
        if (file == null || file.isEmpty()) return "Please select a CSV file.";

        List<String> duplicates = new ArrayList<>();
        int added = 0;

        try (CSVParser parser = CSVParser.parse(
                file.getInputStream(), StandardCharsets.UTF_8,
                CSVFormat.DEFAULT.withHeader())) {

            for (var rec : parser) {
                String err = addPreference(
                        rec.get("firstName"), rec.get("lastName"),
                        rec.get("email"), rec.get("phone"),
                        rec.get("occupationCode"), rec.get("standName"),
                        rec.get("reservationTime"));

                if (err == null) {
                    added++;
                } else if (err.startsWith("Duplicate:")) {
                    duplicates.add(err.substring(10).trim());   // "First Last"
                }
                // other validation errors are ignored for brevity
            }

            if (duplicates.isEmpty()) {
                return "Appended " + added + " new preference(s).";
            } else {
                String dupList = String.join(", ", duplicates);
                return "Appended " + added + " new preference(s). " +
                       "Duplicates skipped: " + dupList;
            }
        } catch (IOException e) {
            return "CSV error: " + e.getMessage();
        }
    }
}