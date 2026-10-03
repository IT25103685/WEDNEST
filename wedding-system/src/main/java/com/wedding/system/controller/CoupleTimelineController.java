package com.wedding.system.controller;

import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.WeddingTimeline;
import com.wedding.system.service.TimelineService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

/**
 * Major Function 5: Event Scheduling & Timeline Coordination (couple side).
 * The couple can view the coordinator's published timeline, accept it,
 * or send back a change-request message.
 */
@Controller
@RequestMapping("/couple")
public class CoupleTimelineController {

    private final TimelineService timelineService;

    public CoupleTimelineController(TimelineService timelineService) {
        this.timelineService = timelineService;
    }

    @GetMapping("/timeline/{bookingId}")
    public String timeline(@PathVariable int bookingId, Model model) throws DatabaseException {
        WeddingTimeline t = timelineService.getForBooking(bookingId);
        model.addAttribute("bookingId", bookingId);
        model.addAttribute("timeline", t);
        if (t != null) {
            model.addAttribute("events", timelineService.getEvents(t.getId()));
        }
        return "couple/timeline";
    }

    @PostMapping("/timeline/{timelineId}/accept")
    public String acceptTimeline(@PathVariable int timelineId, @RequestParam int bookingId) throws DatabaseException {
        timelineService.accept(timelineId);
        return "redirect:/couple/timeline/" + bookingId;
    }

    @PostMapping("/timeline/{timelineId}/request-change")
    public String requestChange(@PathVariable int timelineId, @RequestParam int bookingId,
                                 @RequestParam String message) throws DatabaseException {
        timelineService.requestChange(timelineId, message);
        return "redirect:/couple/timeline/" + bookingId;
    }
}
