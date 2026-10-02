package com.wedding.system.service;

import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.User;
import com.wedding.system.repository.UserRepository;
import org.springframework.stereotype.Service;

/**
 * OOP CONCEPT: Composition ("has-a" relationship).
 * Every Service class holds a Repository as a private field instead of
 * extending it - loose coupling, clean separation between "business rules"
 * (Service) and "how data is stored" (Repository).
 */
@Service
public class AuthService {

    private final UserRepository userRepository;

    public AuthService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    /** Returns the User if username/password match, otherwise null. */
    public User login(String username, String password) throws DatabaseException {
        User u = userRepository.findByUsername(username);
        if (u != null && u.getPassword().equals(password)) {
            return u;
        }
        return null;
    }

    public void register(User user) throws DatabaseException {
        if (userRepository.findByUsername(user.getUsername()) != null) {
            throw new DatabaseException("Username already taken.");
        }
        userRepository.create(user);
    }
}
