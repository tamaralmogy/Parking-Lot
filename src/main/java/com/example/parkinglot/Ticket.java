package com.example.parkinglot;

import java.time.LocalDateTime;

public class Ticket {
    private String ticketId;
    private String licensePlate;
    private String parkingLot;
    private LocalDateTime entryTime;

    public Ticket(String ticketId, String licensePlate, String parkingLot, LocalDateTime entryTime) {
        this.ticketId = ticketId;
        this.licensePlate = licensePlate;
        this.parkingLot = parkingLot;
        this.entryTime = entryTime;
    }

    public String getTicketId() {
        return ticketId;
    }

    public void setTicketId(String ticketId) {
        this.ticketId = ticketId;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public String getParkingLot() {
        return parkingLot;
    }
    public void setParkingLot(String parkingLot) {
        this.parkingLot = parkingLot;
    }

    public LocalDateTime getEntryTime() {
        return entryTime;
    }

    public void setEntryTime(LocalDateTime entryTime) {
        this.entryTime = entryTime;
    }
}
