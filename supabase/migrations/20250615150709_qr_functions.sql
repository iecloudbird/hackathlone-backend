CREATE OR REPLACE FUNCTION generate_event_qr(user_id UUID)
RETURNS TEXT AS $$
BEGIN
  INSERT INTO qr_codes (user_id, qr_code, type)
  VALUES (user_id, 'EVENT-' || gen_random_uuid()::text, 'event')
  RETURNING qr_code;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generate_meal_qr(user_id UUID)
RETURNS TEXT AS $$
BEGIN
  INSERT INTO qr_codes (user_id, qr_code, type)
  VALUES (user_id, 'MEAL-' || gen_random_uuid()::text, 'meal')
  RETURNING qr_code;
END;
$$ LANGUAGE plpgsql;