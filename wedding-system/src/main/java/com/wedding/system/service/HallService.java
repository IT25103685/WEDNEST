package com.wedding.system.service;

import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.WeddingHall;
import com.wedding.system.repository.WeddingHallRepository;
import org.springframework.stereotype.Service;

import java.sql.Date;
import java.util.List;

@Service
public class HallService {

    private final WeddingHallRepository hallRepository;

    public HallService(WeddingHallRepository hallRepository) {
        this.hallRepository = hallRepository;
    }

    public List<WeddingHall> searchAvailable(Date eventDate, int guestCount) throws DatabaseException {
        return hallRepository.searchAvailable(eventDate, guestCount);
    }

    public List<WeddingHall> getAll() throws DatabaseException {
        return hallRepository.readAll();
    }

    public WeddingHall getById(int id) throws DatabaseException {
        return hallRepository.readById(id);
    }

    public void create(WeddingHall hall) throws DatabaseException {
        hallRepository.create(hall);
    }

    public void update(WeddingHall hall) throws DatabaseException {
        hallRepository.update(hall);
    }

    /** Admin "delete" = deactivate, so historic bookings stay valid. */
    public void deactivate(int hallId) throws DatabaseException {
        hallRepository.delete(hallId);
    }
}
