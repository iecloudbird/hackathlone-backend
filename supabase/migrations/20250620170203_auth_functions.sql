CREATE OR REPLACE FUNCTION generate_qr_code(user_id UUID)
RETURNS TEXT AS $$
DECLARE
  new_qr_code TEXT;
BEGIN
  -- Simple QR code generation (replace with actual logic or API call)
  UPDATE profiles
  SET qr_code = 'QR-' || gen_random_uuid()::text,
      updated_at = NOW()
  WHERE id = user_id
  RETURNING qr_code INTO new_qr_code;
  
  RETURN new_qr_code;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error generating QR code for user %: %', user_id, SQLERRM;
        RETURN NULL; -- In case of error return null
END;
$$ LANGUAGE plpgsql;

-- Function to verify QR code
CREATE OR REPLACE FUNCTION verify_qr_code(qr_code_text TEXT)
RETURNS JSON AS $$
BEGIN
  RETURN (SELECT COALESCE(
    json_build_object(
    'valid', EXISTS (SELECT 1 FROM profiles WHERE qr_code = qr_code_text),
    'user_id', id,
    'role', role
  ), json_build_object('valid', false, 'error', 'Invalid QR code') --  fallback if not found
  ) FROM profiles WHERE qr_code = qr_code_text LIMIT 1);
EXCEPTION
  WHEN OTHERS THEN
    RETURN json_build_object('valid', false, 'error', 'Invalid QR code or server error');
END;
$$ LANGUAGE plpgsql;