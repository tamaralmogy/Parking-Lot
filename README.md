# Parking Lot Management System

## Overview

This project implements a cloud-based system to manage a parking lot. The system records the entry and exit times of cars, along with their license plates and parking lot IDs. It then calculates the parking charge based on the duration of the stay.

## Scenario

A camera recognizes the license plate of a car and pings the cloud service. The system performs the following actions:

- **Entry**: Records the time, license plate, and parking lot ID.
- **Exit**: Returns the license plate, total parked time, the parking lot ID, and the charge based on the time in the parking lot.

### Pricing

The charge for parking is $10 per hour, calculated in 15-minute increments.

## Endpoints

The system exposes two HTTP endpoints:

1. **POST /entry**
   Records the entry of a car into the parking lot.

   **Parameters**:
   - `plate` (string): License plate of the car.
   - `parkingLot` (string): ID of the parking lot.

   **Response**:
   - Returns a `ticketId`.

   **Example**:
   ```sh
   curl -X POST "http://<PUBLIC_IP>:8080/entry?plate=123-123-123&parkingLot=382"

2. **POST /exit**
   Records the exit of a car from the parking lot and calculates the parking charge.
   
   **Parameters**:
   
   - `ticketId` (string): ID of the ticket.
   
   **Response**:
   
   Returns a JSON object containing:
   - `licensePlate`: The license plate of the car.
   - `totalParkedTime`: The total parked time in minutes.
   - `parkingLotId`: The ID of the parking lot.
   - `charge`: The parking charge.
   
   **Example**:

   ```sh
   curl -X POST "http://<PUBLIC_IP>:8080/exit?ticketId=1234"

## Deployment

### Prerequisites

- AWS CLI configured with your credentials.
- Git installed on your local machine.

### Deployment Steps

1. **Clone the Repository**:

    ```sh
    git clone https://github.com/tamaralmogy/Parking-Lot
    cd <REPO_DIRECTORY>
    ```

2. **Run the Deployment Script**:

    Execute the `deploy.sh` script to deploy your application and run the tests:

    ```sh
    ./deploy.sh
    ```

## Deliverables

- The code that handles the `/entry` and `/exit` endpoints.
- A script (`deploy.sh`) that deploys the code to the cloud.
- A link to the GitHub repository containing the code and deployment scripts.

   
