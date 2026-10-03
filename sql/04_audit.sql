-- Audit log: records every change to medical records
-- Supports accountability (who did what, and when)

CREATE TABLE audit_log (
  log_id     SERIAL PRIMARY KEY,
  table_name TEXT NOT NULL,
  action     TEXT NOT NULL,       -- INSERT, UPDATE or DELETE
  record_id  INT,
  changed_by TEXT NOT NULL,       -- database user who made the change
  changed_at TIMESTAMP NOT NULL DEFAULT now()
);

-- Function that writes a row into audit_log
CREATE OR REPLACE FUNCTION log_record_change() RETURNS trigger AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    INSERT INTO audit_log (table_name, action, record_id, changed_by)
    VALUES (TG_TABLE_NAME, TG_OP, OLD.record_id, current_user);
    RETURN OLD;
  ELSE
    INSERT INTO audit_log (table_name, action, record_id, changed_by)
    VALUES (TG_TABLE_NAME, TG_OP, NEW.record_id, current_user);
    RETURN NEW;
  END IF;
END;
$$ LANGUAGE plpgsql;

-- Trigger: runs the function after every change to medical_records
CREATE TRIGGER trg_audit_medical_records
AFTER INSERT OR UPDATE OR DELETE ON medical_records
FOR EACH ROW EXECUTE FUNCTION log_record_change();
