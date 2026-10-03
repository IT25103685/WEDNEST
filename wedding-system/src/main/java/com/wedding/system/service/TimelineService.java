package com.wedding.system.service;

import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.TimelineEvent;
import com.wedding.system.model.WeddingTimeline;
import com.wedding.system.repository.TimelineEventRepository;
import com.wedding.system.repository.WeddingTimelineRepository;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * "Event Scheduling & Timeline Coordination" module.
 * The coordinator builds a timeline (ceremony/reception/vendor slots),
 * the system flags overlapping slots, then publishes it. The couple can
 * accept it, or send back a change-request message.
 */
@Service
public class TimelineService {

    private final WeddingTimelineRepository timelineRepository;
    private final TimelineEventRepository eventRepository;

    public TimelineService(WeddingTimelineRepository timelineRepository, TimelineEventRepository eventRepository) {
        this.timelineRepository = timelineRepository;
        this.eventRepository = eventRepository;
    }

    /** Returns the timeline for a booking, or null if the coordinator hasn't created one yet. */
    public WeddingTimeline getForBooking(int bookingId) throws DatabaseException {
        return timelineRepository.readByBookingId(bookingId);
    }

    public WeddingTimeline getOrCreateForBooking(int bookingId, int coordinatorId) throws DatabaseException {
        WeddingTimeline t = timelineRepository.readByBookingId(bookingId);
        if (t == null) {
            t = new WeddingTimeline();
            t.setBookingId(bookingId);
            t.setCoordinatorId(coordinatorId);
            t.setStatus("DRAFT");
            timelineRepository.create(t);
        }
        return t;
    }

    public List<TimelineEvent> getEvents(int timelineId) throws DatabaseException {
        return eventRepository.readByTimelineId(timelineId);
    }

    /** Returns true if the new event overlaps an existing one in the same timeline. */
    public boolean addEvent(TimelineEvent event) throws DatabaseException {
        boolean overlap = eventRepository.hasOverlap(event.getTimelineId(), event.getStartTime(), event.getEndTime(), null);
        eventRepository.create(event); // still saved - the coordinator sees the conflict flag and can fix it
        return overlap;
    }

    public void publish(int timelineId) throws DatabaseException {
        WeddingTimeline t = timelineRepository.readById(timelineId);
        t.setStatus("PUBLISHED");
        t.setChangeRequestMessage(null);
        timelineRepository.update(t);
    }

    public void requestChange(int timelineId, String message) throws DatabaseException {
        WeddingTimeline t = timelineRepository.readById(timelineId);
        t.setStatus("CHANGE_REQUESTED");
        t.setChangeRequestMessage(message);
        timelineRepository.update(t);
    }

    public void accept(int timelineId) throws DatabaseException {
        WeddingTimeline t = timelineRepository.readById(timelineId);
        t.setStatus("PUBLISHED");
        t.setChangeRequestMessage("ACCEPTED_BY_COUPLE");
        timelineRepository.update(t);
    }
}
