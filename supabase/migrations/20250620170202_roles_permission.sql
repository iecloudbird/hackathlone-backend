CREATE TABLE role_permissions (
  role TEXT PRIMARY KEY CHECK (role IN ('participant',  'mentors', 'sponsor', 'admin')),
  can_manage_profiles BOOLEAN DEFAULT FALSE,
  can_manage_qr_codes BOOLEAN DEFAULT FALSE,
  can_manage_all BOOLEAN DEFAULT FALSE
);

-- Insert default permissions
INSERT INTO role_permissions (role, can_manage_profiles, can_manage_qr_codes, can_manage_all)
VALUES
  ('participant', FALSE, FALSE, FALSE),
  ('mentors', FALSE, FALSE, FALSE),
  ('sponsor', FALSE, FALSE, FALSE),
  ('admin', TRUE, TRUE, TRUE);

-- Policy to check permissions dynamically
CREATE POLICY "Dynamic role-based access to profiles" ON profiles
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles p
      JOIN role_permissions rp ON p.role = rp.role
      WHERE p.id = auth.uid() AND (
        rp.can_manage_all OR
        rp.can_manage_profiles OR
        p.id = auth.uid()
      )
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles p
      JOIN role_permissions rp ON p.role = rp.role
      WHERE p.id = auth.uid() AND (
        rp.can_manage_all OR
        rp.can_manage_profiles
      )
    )
  );