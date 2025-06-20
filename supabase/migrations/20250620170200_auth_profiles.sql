-- Profiles table
CREATE TABLE profiles(
  id uuid REFERENCES auth.users on delete cascade NOT NULL PRIMARY KEY,
  email TEXT not null unique, -- email is unique and not null
  phone TEXT  unique,
  role TEXT  not null default 'participant' CHECK (role IN ('participant', 'admin','mentors','sponsor')), -- user role, default is 'participant'
  full_name TEXT NOT NULL, -- Required for user profile
  bio TEXT , 
  dietary_preferences TEXT,
  tshirt_size TEXT,
  qr_code TEXT UNIQUE,
  avatar_url text,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS on profiles
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Create index for faster lookups
CREATE INDEX idx_profiles_email on profiles(email);
CREATE INDEX idx_profiles_qr_code ON profiles(qr_code);
