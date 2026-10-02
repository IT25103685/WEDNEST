package com.wedding.system.exception;

/**
 * OOP CONCEPT: Inheritance
 * DatabaseException extends the built-in Exception class, inheriting all of
 * Java's standard exception behaviour (message, cause, stack trace) and
 * forwarding to it with super(...). Every repository method throws this
 * single, simple, checked exception instead of leaking raw SQLExceptions
 * into the service/controller layers.
 */
public class DatabaseException extends Exception {

    public DatabaseException(String message) {
        super(message);
    }

    public DatabaseException(String message, Throwable cause) {
        super(message, cause);
    }
}
