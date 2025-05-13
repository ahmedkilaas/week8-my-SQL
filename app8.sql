-- Clinic Booking System Database Schema

-- Create Clinics Table
CREATE TABLE clinics (
    clinic_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20) UNIQUE NOT NULL
);

-- Create Patients Table
CREATE TABLE patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20)
);

-- Create Doctors Table with Clinic Relationship
CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialization VARCHAR(100),
    license_number VARCHAR(50) UNIQUE NOT NULL,
    clinic_id INT NOT NULL,
    FOREIGN KEY (clinic_id) REFERENCES clinics(clinic_id)
);

-- Create Medical Services Table
CREATE TABLE services (
    service_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    duration INT NOT NULL COMMENT 'Duration in minutes',
    cost DECIMAL(10, 2) NOT NULL
);

-- Create Doctor-Service Many-to-Many Relationship Table
CREATE TABLE doctor_services (
    doctor_id INT NOT NULL,
    service_id INT NOT NULL,
    PRIMARY KEY (doctor_id, service_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
    FOREIGN KEY (service_id) REFERENCES services(service_id)
);

-- Create Appointments Table with Constraints
CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    service_id INT NOT NULL,
    appointment_date_time DATETIME NOT NULL,
    status ENUM('Scheduled', 'Completed', 'Cancelled') NOT NULL DEFAULT 'Scheduled',
    notes TEXT,
    -- Foreign key to enforce valid doctor-service combinations
    FOREIGN KEY (doctor_id, service_id) REFERENCES doctor_services(doctor_id, service_id),
    -- Prevent double-booking constraints
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    UNIQUE KEY unique_doctor_timeslot (doctor_id, appointment_date_time),
    UNIQUE KEY unique_patient_timeslot (patient_id, appointment_date_time)
);