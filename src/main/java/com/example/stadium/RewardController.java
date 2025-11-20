package com.example.stadium;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class RewardController {

    @Autowired private RewardService rewardService;
    @Autowired private RewardRepository rewardRepository;

    @GetMapping("/reward")
    public String triggerRewardAndShowPage(Model model) {
        rewardService.runRewardingProcess();
        model.addAttribute("rewards", rewardRepository.findAllByOrderByPreferredStandAsc());
        return "reward";
    }

    @GetMapping("/back-to-preference")
    public String backToPreference() {
        return "redirect:/preference";
    }
}