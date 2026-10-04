package com.wedding.system.service;

import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.User;
import com.wedding.system.model.Vendor;
import com.wedding.system.model.VendorRequest;
import com.wedding.system.repository.UserRepository;
import com.wedding.system.repository.VendorRepository;
import com.wedding.system.repository.VendorRequestRepository;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * "Admin Dashboard & Vendor Management" module (vendor side):
 * vendor self sign-up -> Vendor Relations Manager approves -> vendor becomes
 * bookable -> couple selects vendor at booking time -> vendor receives the
 * wedding description + date as a VendorRequest and waits for it to show up
 * once they log in.
 */
@Service
public class VendorService {

    private final VendorRepository vendorRepository;
    private final VendorRequestRepository requestRepository;
    private final UserRepository userRepository;

    public VendorService(VendorRepository vendorRepository, VendorRequestRepository requestRepository,
                          UserRepository userRepository) {
        this.vendorRepository = vendorRepository;
        this.requestRepository = requestRepository;
        this.userRepository = userRepository;
    }

    /** Vendor self-registers: creates both the login (User) and the Vendor profile (PENDING). */
    public void registerVendor(User account, Vendor vendor) throws DatabaseException {
        account.setRole("VENDOR");
        userRepository.create(account);
        vendor.setUserId(account.getId());
        vendor.setStatus("PENDING");
        vendorRepository.create(vendor);
    }

    public List<Vendor> getApproved() throws DatabaseException {
        return vendorRepository.readByStatus("APPROVED");
    }

    public List<Vendor> getPending() throws DatabaseException {
        return vendorRepository.readByStatus("PENDING");
    }

    public List<Vendor> getAll() throws DatabaseException {
        return vendorRepository.readAll();
    }

    public Vendor getByUserId(int userId) throws DatabaseException {
        return vendorRepository.readByUserId(userId);
    }

    public void approve(int vendorId) throws DatabaseException {
        Vendor v = vendorRepository.readById(vendorId);
        v.setStatus("APPROVED");
        vendorRepository.update(v);
    }

    public void rate(int vendorId, double rating) throws DatabaseException {
        Vendor v = vendorRepository.readById(vendorId);
        v.setRating(rating);
        vendorRepository.update(v);
    }

    public void removeVendor(int vendorId) throws DatabaseException {
        Vendor v = vendorRepository.readById(vendorId);
        if (v != null) {
            userRepository.delete(v.getUserId());
        }
    }

    /** Couple selects a vendor while booking -> vendor gets a request to review. */
    public void sendRequestToVendor(VendorRequest request) throws DatabaseException {
        request.setStatus("PENDING");
        requestRepository.create(request);
    }

    public List<VendorRequest> getRequestsForVendor(int vendorId) throws DatabaseException {
        return requestRepository.readByVendorId(vendorId);
    }

    public List<VendorRequest> getRequestsForBooking(int bookingId) throws DatabaseException {
        return requestRepository.readByBookingId(bookingId);
    }

    public void respondToRequest(int requestId, boolean accept) throws DatabaseException {
        VendorRequest r = requestRepository.readById(requestId);
        r.setStatus(accept ? "ACCEPTED" : "DECLINED");
        requestRepository.update(r);
    }
}
