package com.wedding.system.util;

import java.security.SecureRandom;

/**
 * Generates a short, easy-to-type random code for each guest, e.g. "G7K2QX".
 * The guest uses this code (instead of a username/password) to open their
 * digital invitation and RSVP.
 */
public class GuestCodeGenerator {

    private static final String CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"; // no O/0/I/1 to avoid confusion
    private static final SecureRandom RANDOM = new SecureRandom();

    public static String generate() {
        StringBuilder sb = new StringBuilder("G");
        for (int i = 0; i < 6; i++) {
            sb.append(CHARS.charAt(RANDOM.nextInt(CHARS.length())));
        }
        return sb.toString();
    }
}
