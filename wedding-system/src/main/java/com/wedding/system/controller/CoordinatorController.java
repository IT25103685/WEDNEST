package com.wedding.system.controller;

import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.TimelineEvent;
import com.wedding.system.model.WeddingTimeline;
import com.wedding.system.service.BookingService;
import com.wedding.system.service.TimelineService;
import com.wedding.system.service.VendorService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.sql.Timestamp;

/**
 * "Event Scheduling & Timeline Coordination" module - coordinator side.
 * Any logged-in coordinator sees every confirmed wedding booking and can
 * build/publish its timeline.
 */
@Controller
@RequestMapping("/coordinator")
public class CoordinatorController {

    private final BookingService bookingService;
    private final TimelineService timelineService;
    private final VendorService vendorService;

    public CoordinatorController(BookingService bookingService, TimelineService timelineService,
                                  VendorService vendorService) {
        this.bookingService = bookingService;
        this.timelineService = timelineService;
        this.vendorService = vendorService;
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) throws DatabaseException {
        if (session.getAttribute("userId") == null) return "redirect:/login";
        model.addAttribute("bookings", bookingService.getConfirmed());
        return "coordinator/dashboard";
    }

    @GetMapping("/timeline/{bookingId}")
    public String timelineBuilder(@PathVariable int bookingId, HttpSession session, Model model)
            throws DatabaseException {
        int coordinatorId = (Integer) session.getAttribute("userId");
        WeddingTimeline t = timelineService.getOrCreateForBooking(bookingId, coordinatorId);
        model.addAttribute("booking", bookingService.getById(bookingId));
        model.addAttribute("timeline", t);
        model.addAttribute("events", timelineService.getEvents(t.getId()));
        model.addAttribute("vendors", vendorService.getApproved());
        return "coordinator/timeline-builder";
    }

    @PostMapping("/timeline/{timelineId}/add-event")
    public String addEvent(@PathVariable int timelineId, @RequestParam int bookingId,
                            @RequestParam String eventName, @RequestParam String startTime,
                            @RequestParam String endTime, @RequestParam(required = false) Integer vendorId,
                            Model model) throws DatabaseException {
        TimelineEvent e = new TimelineEvent();
        e.setTimelineId(timelineId);
        e.setEventName(eventName);
        e.setStartTime(Timestamp.valueOf(startTime.replace("T", " ") + ":00"));
        e.setEndTime(Timestamp.valueOf(endTime.replace("T", " ") + ":00"));
        e.setVendorId(vendorId);
        boolean overlap = timelineService.addEvent(e);
        if (overlap) {
            model.addAttribute("conflictWarning", "Warning: this event overlaps another slot on the same timeline.");
        }
        return "redirect:/coordinator/timeline/" + bookingId;
    }

    @PostMapping("/timeline/{timelineId}/publish")
    public String publish(@PathVariable int timelineId, @RequestParam int bookingId) throws DatabaseException {
        timelineService.publish(timelineId);
        return "redirect:/coordinator/timeline/" + bookingId;
    }
}
