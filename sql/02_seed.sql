-- All data below is fictional.

INSERT INTO patients (first_name, last_name, dob, phone) VALUES
('Anna',    'Rossi',      '1990-04-12', '555-0101'),
('Ahmed',   'Hassan',     '1985-09-30', '555-0102'),
('Fatima',  'Al-Khalil',  '2001-01-22', '555-0103'),
('Luca',    'Neri',       '1978-11-05', '555-0104'),
('Youssef', 'Mansour',    '1995-07-18', '555-0105'),
('Layla',   'Haddad',     '1988-03-09', '555-0106'),
('Omar',    'Saleh',      '1972-12-01', '555-0107');

INSERT INTO doctors (first_name, last_name, specialty) VALUES
('Elena',  'Ferrari',   'Cardiology'),
('Karim',  'Nasser',    'General Medicine'),
('Amira',  'Zayed',     'Dermatology');

INSERT INTO appointments (patient_id, doctor_id, appt_time, reason) VALUES
(1, 2, '2026-09-10 09:00', 'Annual check-up'),
(2, 1, '2026-09-11 10:30', 'Chest pain follow-up'),
(3, 3, '2026-09-12 14:00', 'Skin rash'),
(4, 2, '2026-09-15 11:15', 'Flu symptoms'),
(5, 1, '2026-09-16 16:00', 'Blood pressure review'),
(6, 3, '2026-09-18 13:30', 'Allergy consultation'),
(7, 2, '2026-09-19 09:45', 'Diabetes check'),
(1, 3, '2026-09-20 08:45', 'Mole check');

INSERT INTO medical_records (patient_id, doctor_id, diagnosis, notes) VALUES
(1, 2, 'Healthy',            'No issues found at annual check-up.'),
(2, 1, 'Hypertension',       'Started medication, review in 3 months.'),
(3, 3, 'Contact dermatitis', 'Prescribed topical cream.'),
(4, 2, 'Influenza',          'Rest and fluids advised.'),
(6, 3, 'Seasonal allergy',   'Antihistamine recommended.'),
(7, 2, 'Type 2 diabetes',    'Diet plan and blood sugar monitoring started.');
