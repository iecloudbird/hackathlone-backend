-- Function to handles new user creation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
 INSERT INTO public.profiles (id, email, full_name, role, qr_code)
  VALUES (
    NEW.id, 
    NEW.email,     
    COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email), -- Use full_name from auth metadata or fallback to email
    COALESCE(NEW.raw_user_meta_data->>'role', 'participant'), -- Default to participant if no role provided
    'QR-' || gen_random_uuid()::TEXT -- Generate unique QR code
    );
    -- Set custom claims for RBAC
    PERFORM auth.set_user_role(NEW.id, COALESCE(NEW.raw_user_meta_data->>'role', 'participant'));
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to set user role and update claims
CREATE OR REPLACE FUNCTION public.set_user_role(user_id UUID, user_role TEXT)
RETURNS VOID AS $$
BEGIN
  -- Validate role
  IF user_role NOT IN ('participant', 'mentors', 'sponsor', 'admin') THEN
    RAISE EXCEPTION 'Invalid role: %', user_role;
  END IF;

  -- Update role in profiles table
  UPDATE profiles
  SET role = user_role, updated_at = NOW()
  WHERE id = user_id;

  -- Placeholder for setting JWT claim (use Edge Function)
  RAISE NOTICE 'Role % set for user % (implement claim via Edge Function)', user_role, user_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to execute auth.users insertion
CREATE TRIGGER on_auth_user_created
AFTER INSERT ON auth.users
FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();