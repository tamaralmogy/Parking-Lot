package com.example.parkinglot;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.web.bind.annotation.*;

@RestController
public class ParkingLotController {

    private final Map<String, Ticket> tickets = new HashMap<>();

    @PostMapping("/entry")
    public String entry(@RequestParam String plate, @RequestParam String parkingLot) {
        String ticketId = UUID.randomUUID().toString();
        Ticket ticket = new Ticket(ticketId, plate, parkingLot, LocalDateTime.now());
        tickets.put(ticketId, ticket);
        return ticketId;
    }

    @PostMapping("/exit")
    public Map<String, Object> exit(@RequestParam String ticketId) {
        Ticket ticket = tickets.remove(ticketId);
        if (ticket == null) {
            throw new RuntimeException("Ticket not found");
        }

        LocalDateTime exitTime = LocalDateTime.now();
        Duration duration = Duration.between(ticket.getEntryTime(), exitTime);
        long minutes = duration.toMinutes();
        double charge = Math.ceil(minutes / 15.0) * 2.5;

        Map<String, Object> response = new HashMap<>();
        response.put("licensePlate", ticket.getLicensePlate());
        response.put("totalParkedTime", minutes);
        response.put("parkingLotId", ticket.getParkingLot());
        response.put("charge", charge);

        return response;
    }
}
