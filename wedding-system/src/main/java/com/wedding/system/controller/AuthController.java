package com.wedding.system.controller;

import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.User;
import com.wedding.system.service.AuthService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

/**
 * Handles login/logout/registration and routes every role to its own
 * separate dashboard after login.
 */
@Controller
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @GetMapping({"/", "/login"})
    public String loginPage() {
        return "common/login";
    }

    @PostMapping("/login")
    public String doLogin(@RequestParam String username, @RequestParam String password,
                           HttpSession session, Model model) {
        try {
            User u = authService.login(username, password);
            if (u == null) {
                model.addAttribute("error", "Invalid username or password.");
                return "common/login";
            }
            session.setAttribute("userId", u.getId());
            session.setAttribute("fullName", u.getFullName());
            session.setAttribute("role", u.getRole());
            return "redirect:" + dashboardFor(u.getRole());
        } catch (DatabaseException e) {
            model.addAttribute("error", e.getMessage());
            return "common/login";
        }
    }

    @GetMapping("/register")
    public String registerPage(Model model) {
        model.addAttribute("user", new User());
        return "common/register";
    }

    @PostMapping("/register")
    public String doRegister(@ModelAttribute User user, Model model) {
        try {
            user.setRole("COUPLE"); // public self-registration is only for couples
            authService.register(user);
            model.addAttribute("success", "Account created. Please log in.");
            return "common/login";
        } catch (DatabaseException e) {
            model.addAttribute("error", e.getMessage());
            return "common/register";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }

    public static String dashboardFor(String role) {
        switch (role) {
            case "COUPLE": return "/couple/dashboard";
            case "HOTEL_MANAGER": return "/hotel-manager/dashboard";
            case "COORDINATOR": return "/coordinator/dashboard";
            case "FINANCE_MANAGER": return "/finance/dashboard";
            case "VENDOR_RELATIONS": return "/vendor-relations/dashboard";
            case "VENDOR": return "/vendor/dashboard";
            case "ADMIN": return "/admin/dashboard";
            default: return "/login";
        }
    }
}
