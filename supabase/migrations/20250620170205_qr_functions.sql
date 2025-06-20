-- Generate QR code for user profile (called during sign-up)
CREATE OR REPLACE FUNCTION generate_profile_qr_code(user_id UUID)
RETURNS TEXT AS $$
DECLARE
  new_qr_code TEXT;
BEGIN
  new_qr_code := 'QR-' || gen_random_uuid()::TEXT;
  UPDATE profiles
  SET qr_code = new_qr_code, updated_at = NOW()
  WHERE id = user_id;
  
  RETURN new_qr_code;
EXCEPTION
  WHEN OTHERS THEN
    RAISE NOTICE 'Error generating QR code for user %: %', user_id, SQLERRM;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Generate event or meal QR code
CREATE OR REPLACE FUNCTION generate_typed_qr_code(user_id UUID, qr_type TEXT)
RETURNS TEXT AS $$
DECLARE
  new_qr_code TEXT;
BEGIN
  IF qr_type NOT IN ('event', 'meal') THEN
    RAISE EXCEPTION 'Invalid QR code type: %', qr_type;
  END IF;

  new_qr_code := qr_type || '-' || gen_random_uuid()::TEXT;
  INSERT INTO qr_codes (user_id, qr_code, type)
  VALUES (user_id, new_qr_code, qr_type);

  RETURN new_qr_code;
EXCEPTION
  WHEN OTHERS THEN
    RAISE NOTICE 'Error generating % QR code for user %: %', qr_type, user_id, SQLERRM;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Verify QR code (profile or typed)
CREATE OR REPLACE FUNCTION verify_qr_code(qr_code_text TEXT)
RETURNS JSON AS $$
BEGIN
  -- Check profiles table first
  IF EXISTS (SELECT 1 FROM profiles WHERE qr_code = qr_code_text) THEN
    RETURN (
      SELECT json_build_object(
        'valid', TRUE,
        'user_id', id,
        'role', role,
        'type', 'profile'
      )
      FROM profiles
      WHERE qr_code = qr_code_text
      LIMIT 1
    );
  END IF;

  -- Check qr_codes table
  IF EXISTS (SELECT 1 FROM qr_codes WHERE qr_code = qr_code_text) THEN
    RETURN (
      SELECT json_build_object(
        'valid', TRUE,
        'user_id', user_id,
        'type', type,
        'used', used
      )
      FROM qr_codes
      WHERE qr_code = qr_code_text
      LIMIT 1
    );
  END IF;

  -- Fallback if QR code not found
  RETURN json_build_object('valid', FALSE, 'error', 'Invalid QR code');
EXCEPTION
  WHEN OTHERS THEN
    RETURN json_build_object('valid', FALSE, 'error', 'Server error: ' || SQLERRM);
END;
$$ LANGUAGE plpgsql;