# Car Rental Database Design
---

## Project Overview

Designed and implemented a robust SQL schema for a car rental system, the project, titled "Analysis of Car Rental Database," offers a comprehensive platform for car owners to advertise their vehicles for rent and serves as a marketplace for individuals looking to rent a vehicle. The system efficiently handles over 50,000 records, effectively managing data with the automation of billing and rental updates through triggers and procedures. This automation has resulted in a 100% reduction in manual processing time.

## ER Diagram

![ER Diagram]
(https://github.com/dhvani-k/Car_Rental_Database_Design/blob/main/img/ER_Diagram.png)

---

## Repository Contents

1. **SQL Files**:
    - `create.sql`: Contains the SQL script for the creation of tables, procedures, functions, triggers, and indices.
    - `load.sql`: Includes SQL queries for loading data into all tables, excluding RENT and PAYMENT tables.
    - `load_update_rent.sql`: Houses a procedure call for rent instances and an update statement for the rent record post-completion of a vehicle rental trip. The update statement triggers a function updating the vehicle information, branch parking information, and payment details.

2. **Python Script**:
    - `script_for_data_generation.py`: Utilized for generating dummy data to populate the database.

3. **Demo Video**: 
    - A demonstration of the system can be viewed [here](https://github.com/dhvani-k/Car_Rental_Database_Design/blob/main/Webapp_Demo.mov).

---

## Detailed Description

The car rental system calculates charges on an hourly basis, allowing customers to read reviews of available cars and provide feedback on rented vehicles. The system also maintains payment details for each trip.

The main goal is to design a database system that employs car rental data for insightful analytics, aiding business owners in decision-making related to business inception or expansion. The database provides capabilities such as analyzing vehicle usage, pinpointing sold and unsold rental days, and identifying popular car models. It offers a wide range of business insights, enabling strategic enhancements and expansion.

---

## Setup Instructions

1. **Database Setup**:
    - Install and run PostgreSQL.
    - Execute the `create.sql` for database schema setup.
    - Utilize `load.sql` and `load_update_rent.sql` for database population.

2. **Data Generation**:
    - Execute `script_for_data_generation.py` to generate dummy data.

---

## Technologies Used

- **Database**: PostgreSQL
- **Data Generation**: Python with Fake Data Generator API
- **Demo**: Video demonstration

---
