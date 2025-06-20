 -- Policy for participants to view/update only their profile
CREATE POLICY "Users can view own profile" ON profiles
  FOR ALL
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Policy for admin to view all profiles and scan QR codes
CREATE POLICY "Admin can manage all profiles" ON profiles
  FOR ALL
  TO authenticated
  USING (EXISTS (
    SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
  ))
  WITH CHECK (EXISTS (
    SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
  ));
  