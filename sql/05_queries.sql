-- =====================================================
-- PART 1: Database course queries (JOINs, GROUP BY)
-- =====================================================

-- 1. Appointments per doctor
SELECT d.first_name, d.last_name, d.specialty,
       COUNT(a.appointment_id) AS total_appointments
FROM doctors d
LEFT JOIN appointments a ON a.doctor_id = d.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name, d.specialty
ORDER BY total_appointments DESC;

-- 2. Each appointment with patient and doctor names
SELECT a.appt_time,
       p.first_name || ' ' || p.last_name AS patient,
       d.first_name || ' ' || d.last_name AS doctor,
       a.reason
FROM appointments a
JOIN patients p ON p.patient_id = a.patient_id
JOIN doctors  d ON d.doctor_id  = a.doctor_id
ORDER BY a.appt_time;

-- 3. Patients who have no medical record yet
SELECT p.patient_id, p.first_name, p.last_name
FROM patients p
LEFT JOIN medical_records m ON m.patient_id = p.patient_id
WHERE m.record_id IS NULL;

-- 4. Number of records per diagnosis
SELECT diagnosis, COUNT(*) AS cases
FROM medical_records
GROUP BY diagnosis
ORDER BY cases DESC;

-- =====================================================
-- PART 2: Security queries (audit log review)
-- =====================================================

-- Generate some activity so the audit log has entries
-- (the seed data was loaded before the trigger existed)
INSERT INTO medical_records (patient_id, doctor_id, diagnosis, notes)
VALUES (5, 1, 'Mild hypertension', 'Lifestyle changes advised.');

UPDATE medical_records
SET notes = 'Lifestyle changes advised. Follow-up in 6 weeks.'
WHERE diagnosis = 'Mild hypertension';

DELETE FROM medical_records
WHERE diagnosis = 'Mild hypertension';

-- 5. Full audit trail, newest first
SELECT log_id, changed_at, changed_by, action, table_name, record_id
FROM audit_log
ORDER BY changed_at DESC;

-- 6. Activity count per user (who is changing the most data?)
SELECT changed_by, action, COUNT(*) AS times
FROM audit_log
GROUP BY changed_by, action
ORDER BY times DESC;

-- 7. Red flag: every DELETE on medical records
SELECT changed_at, changed_by, record_id
FROM audit_log
WHERE action = 'DELETE'
ORDER BY changed_at DESC;

-- 8. Red flag: changes made outside working hours (before 07:00 or after 20:00)
SELECT changed_at, changed_by, action, record_id
FROM audit_log
WHERE EXTRACT(HOUR FROM changed_at) < 7
   OR EXTRACT(HOUR FROM changed_at) >= 20
ORDER BY changed_at DESC;
