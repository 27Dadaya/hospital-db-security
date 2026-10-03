-- Role-based access control (RBAC) using least privilege
-- NOTE: passwords below are demo placeholders only. Never commit real passwords.

-- 1. Create roles (groups of permissions)
CREATE ROLE receptionist_role;
CREATE ROLE doctor_role;
CREATE ROLE auditor_role;

-- 2. Receptionist: manages patients and appointments, NO access to medical records
GRANT SELECT, INSERT, UPDATE ON patients, appointments TO receptionist_role;
GRANT SELECT ON doctors TO receptionist_role;
GRANT USAGE ON SEQUENCE patients_patient_id_seq,
                        appointments_appointment_id_seq TO receptionist_role;

-- 3. Doctor: reads patient data, reads and writes medical records
GRANT SELECT ON patients, doctors, appointments TO doctor_role;
GRANT SELECT, INSERT, UPDATE ON medical_records TO doctor_role;
GRANT USAGE ON SEQUENCE medical_records_record_id_seq TO doctor_role;

-- 4. Auditor: read-only on the audit log, cannot change any data
GRANT SELECT ON audit_log TO auditor_role;

-- 5. Nobody can edit or delete audit history directly
REVOKE ALL ON audit_log FROM PUBLIC;
GRANT SELECT ON audit_log TO auditor_role;

-- 6. Create login users and assign them to roles
CREATE USER alice_reception LOGIN PASSWORD 'DemoOnly#1' IN ROLE receptionist_role;
CREATE USER dr_karim        LOGIN PASSWORD 'DemoOnly#2' IN ROLE doctor_role;
CREATE USER sam_auditor     LOGIN PASSWORD 'DemoOnly#3' IN ROLE auditor_role;
