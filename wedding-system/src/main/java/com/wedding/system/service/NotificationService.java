package com.wedding.system.service;

import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.Notification;
import com.wedding.system.repository.NotificationRepository;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Notifications only ever appear inside the website, and only once the
 * relevant User/Guest actually logs in and opens their dashboard - reading
 * them also marks them as read, matching the "don't send them any other
 * external way" requirement.
 */
@Service
public class NotificationService {

    private final NotificationRepository notificationRepository;

    public NotificationService(NotificationRepository notificationRepository) {
        this.notificationRepository = notificationRepository;
    }

    public List<Notification> getForUser(int userId) throws DatabaseException {
        return notificationRepository.readAndMarkReadForUser(userId);
    }

    public List<Notification> getForGuest(int guestId) throws DatabaseException {
        return notificationRepository.readAndMarkReadForGuest(guestId);
    }

    public void send(Integer userId, Integer guestId, String message) throws DatabaseException {
        Notification n = new Notification();
        n.setUserId(userId);
        n.setGuestId(guestId);
        n.setMessage(message);
        notificationRepository.create(n);
    }
}
