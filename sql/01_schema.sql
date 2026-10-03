CREATE TABLE patients (
  patient_id SERIAL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name  VARCHAR(50) NOT NULL,
  dob        DATE NOT NULL,
  phone      VARCHAR(20)
);

CREATE TABLE doctors (
  doctor_id  SERIAL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name  VARCHAR(50) NOT NULL,
  specialty  VARCHAR(80)
);

CREATE TABLE appointments (
  appointment_id SERIAL PRIMARY KEY,
  patient_id INT NOT NULL REFERENCES patients(patient_id),
  doctor_id  INT NOT NULL REFERENCES doctors(doctor_id),
  appt_time  TIMESTAMP NOT NULL,
  reason     VARCHAR(200)
);

CREATE TABLE medical_records (
  record_id  SERIAL PRIMARY KEY,
  patient_id INT NOT NULL REFERENCES patients(patient_id),
  doctor_id  INT NOT NULL REFERENCES doctors(doctor_id),
  diagnosis  VARCHAR(200) NOT NULL,
  notes      TEXT,
  created_at TIMESTAMP DEFAULT now()
);
