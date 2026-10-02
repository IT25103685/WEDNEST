package com.wedding.system.repository;

import com.wedding.system.exception.DatabaseException;

import java.util.List;

/**
 * OOP CONCEPT: Abstraction + Generics (Parametric Polymorphism)
 * <p>
 * Every repository class in this folder implements this same contract.
 * T  = the entity type (User, Booking, Guest, ...)
 * ID = the type of that entity's primary key (always Integer here)
 * <p>
 * The Service layer only ever talks to this interface - it never needs to
 * know which JDBC/SQL details live underneath.
 */
public interface Repository<T, ID> {

    void create(T entity) throws DatabaseException;

    T readById(ID id) throws DatabaseException;

    List<T> readAll() throws DatabaseException;

    void update(T entity) throws DatabaseException;

    void delete(ID id) throws DatabaseException;
}
