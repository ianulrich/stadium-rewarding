package com.example.stadium;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class PreferenceController {

    @Autowired private StandService standService;

    @GetMapping("/preference")
    public String showPreferencePage(Model model) {
        model.addAttribute("stands", standService.getPreferenceSummary());
        return "preference";
    }

    @PostMapping("/preference/add")
    public String addPreference(@RequestParam String firstName,
                                @RequestParam String lastName,
                                @RequestParam String email,
                                @RequestParam String phone,
                                @RequestParam String occupationCode,
                                @RequestParam String standName,
                                @RequestParam String reservationTime,
                                RedirectAttributes ra) {
        String err = standService.addPreference(firstName, lastName, email,
                phone, occupationCode, standName, reservationTime);
        if (err != null) {
            ra.addFlashAttribute("error", err);
        } else {
            ra.addFlashAttribute("success", "Preference added successfully.");
        }
        return "redirect:/preference";
    }

    @PostMapping("/preference/import")
    public String importCsv(@RequestParam("file") MultipartFile file,
                            RedirectAttributes ra) {
        String msg = standService.importPreferences(file);
        ra.addFlashAttribute("success", msg);
        return "redirect:/preference";
    }

    /* ----------  IMPORT AND APPEND  ---------- */
    @PostMapping("/preference/import-append")
    public String importAndAppend(@RequestParam("file") MultipartFile file,
                                  RedirectAttributes ra) {
        String msg = standService.importAndAppend(file);
        // If message contains "Duplicates skipped", show as error; else success
        if (msg.contains("Duplicates skipped")) {
            ra.addFlashAttribute("error", msg);
        } else {
            ra.addFlashAttribute("success", msg);
        }
        return "redirect:/preference";
    }
}