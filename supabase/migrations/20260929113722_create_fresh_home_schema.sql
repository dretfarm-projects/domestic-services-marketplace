/*
# Fresh Home Marketplace Schema

1. Purpose
- Core tables for a verified on-demand domestic & cleaning services marketplace.
- Supports customers, workers, team leaders, services, bookings, and ratings.

2. New Tables
- `services` — catalogue of cleaning/hospitality services with base pricing
- `workers` — verified worker profiles with levels, ratings, badges
- `teams` — team leader groups with member rosters
- `team_members` — association table linking workers to teams
- `bookings` — customer booking requests (individual or team)
- `booking_assignments` — worker-to-booking assignments with check-in state
- `ratings` — two-way ratings between customers and workers
- `requirement_profiles` — saved special-requirement templates for hotels/offices

3. Security
- This is a demo/showcase app with no sign-in screen; all data is intentionally public/shared.
- RLS enabled on every table with anon+authenticated CRUD access.
- In production, these would be scoped to authenticated owners.
*/

-- Services catalogue
CREATE TABLE IF NOT EXISTS services (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  category text NOT NULL DEFAULT 'household',
  name text NOT NULL,
  description text,
  icon_name text NOT NULL DEFAULT 'sparkles',
  base_price integer NOT NULL DEFAULT 1500,
  price_unit text NOT NULL DEFAULT 'job',
  estimated_hours numeric DEFAULT 3,
  default_attire text DEFAULT 'practical',
  is_active boolean DEFAULT true,
  sort_order integer DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

-- Worker profiles
CREATE TABLE IF NOT EXISTS workers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  full_name text NOT NULL,
  phone text,
  photo_url text,
  area text DEFAULT 'Kasarani, Nairobi',
  latitude double precision DEFAULT -1.2186,
  longitude double precision DEFAULT 36.9089,
  languages text[] DEFAULT ARRAY['English','Swahili'],
  experience_years integer DEFAULT 1,
  bio text,
  level integer NOT NULL DEFAULT 1,
  level_name text NOT NULL DEFAULT 'Registered Worker',
  verification_status text NOT NULL DEFAULT 'pending',
  rating_avg numeric DEFAULT 0,
  jobs_completed integer DEFAULT 0,
  badges text[] DEFAULT ARRAY[]::text[],
  services text[] DEFAULT ARRAY[]::text[],
  expected_rate integer DEFAULT 200,
  is_online boolean DEFAULT false,
  is_available boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

-- Teams
CREATE TABLE IF NOT EXISTS teams (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  leader_id uuid REFERENCES workers(id) ON DELETE CASCADE,
  leader_name text,
  area text DEFAULT 'Kasarani, Nairobi',
  max_size integer DEFAULT 15,
  rating numeric DEFAULT 0,
  jobs_completed integer DEFAULT 0,
  status text DEFAULT 'active',
  created_at timestamptz DEFAULT now()
);

-- Team members
CREATE TABLE IF NOT EXISTS team_members (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  team_id uuid NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
  worker_id uuid NOT NULL REFERENCES workers(id) ON DELETE CASCADE,
  status text DEFAULT 'active',
  joined_at timestamptz DEFAULT now(),
  UNIQUE(team_id, worker_id)
);

-- Bookings
CREATE TABLE IF NOT EXISTS bookings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_name text NOT NULL DEFAULT 'Anthony',
  customer_type text DEFAULT 'household',
  service_id uuid REFERENCES services(id),
  service_name text NOT NULL,
  booking_type text NOT NULL DEFAULT 'individual',
  status text NOT NULL DEFAULT 'pending',
  address text,
  latitude double precision DEFAULT -1.2186,
  longitude double precision DEFAULT 36.9089,
  scheduled_date date,
  scheduled_time text,
  duration_hours numeric DEFAULT 3,
  workers_required integer DEFAULT 1,
  special_requirements jsonb,
  total_price integer DEFAULT 0,
  worker_id uuid REFERENCES workers(id),
  team_id uuid REFERENCES teams(id),
  progress integer DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

-- Booking assignments
CREATE TABLE IF NOT EXISTS booking_assignments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  booking_id uuid NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
  worker_id uuid NOT NULL REFERENCES workers(id) ON DELETE CASCADE,
  status text DEFAULT 'assigned',
  check_in_at timestamptz,
  check_out_at timestamptz,
  gps_lat double precision,
  gps_lng double precision,
  created_at timestamptz DEFAULT now()
);

-- Ratings
CREATE TABLE IF NOT EXISTS ratings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  booking_id uuid REFERENCES bookings(id) ON DELETE CASCADE,
  from_role text NOT NULL,
  to_worker_id uuid REFERENCES workers(id) ON DELETE CASCADE,
  score integer NOT NULL DEFAULT 5,
  comment text,
  tags text[] DEFAULT ARRAY[]::text[],
  created_at timestamptz DEFAULT now()
);

-- Requirement profiles (saved templates for hotels/offices)
CREATE TABLE IF NOT EXISTS requirement_profiles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  customer_type text DEFAULT 'hotel',
  attire text,
  arrival_minutes integer DEFAULT 30,
  equipment text,
  notes text,
  created_at timestamptz DEFAULT now()
);

-- Enable RLS on all tables
ALTER TABLE services ENABLE ROW LEVEL SECURITY;
ALTER TABLE workers ENABLE ROW LEVEL SECURITY;
ALTER TABLE teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE team_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE booking_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE ratings ENABLE ROW LEVEL SECURITY;
ALTER TABLE requirement_profiles ENABLE ROW LEVEL SECURITY;

-- Policies: demo app, intentionally public/shared data
-- Services
DROP POLICY IF EXISTS "anon_select_services" ON services;
CREATE POLICY "anon_select_services" ON services FOR SELECT TO anon, authenticated USING (true);
DROP POLICY IF EXISTS "anon_insert_services" ON services;
CREATE POLICY "anon_insert_services" ON services FOR INSERT TO anon, authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "anon_update_services" ON services;
CREATE POLICY "anon_update_services" ON services FOR UPDATE TO anon, authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "anon_delete_services" ON services;
CREATE POLICY "anon_delete_services" ON services FOR DELETE TO anon, authenticated USING (true);

-- Workers
DROP POLICY IF EXISTS "anon_select_workers" ON workers;
CREATE POLICY "anon_select_workers" ON workers FOR SELECT TO anon, authenticated USING (true);
DROP POLICY IF EXISTS "anon_insert_workers" ON workers;
CREATE POLICY "anon_insert_workers" ON workers FOR INSERT TO anon, authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "anon_update_workers" ON workers;
CREATE POLICY "anon_update_workers" ON workers FOR UPDATE TO anon, authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "anon_delete_workers" ON workers;
CREATE POLICY "anon_delete_workers" ON workers FOR DELETE TO anon, authenticated USING (true);

-- Teams
DROP POLICY IF EXISTS "anon_select_teams" ON teams;
CREATE POLICY "anon_select_teams" ON teams FOR SELECT TO anon, authenticated USING (true);
DROP POLICY IF EXISTS "anon_insert_teams" ON teams;
CREATE POLICY "anon_insert_teams" ON teams FOR INSERT TO anon, authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "anon_update_teams" ON teams;
CREATE POLICY "anon_update_teams" ON teams FOR UPDATE TO anon, authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "anon_delete_teams" ON teams;
CREATE POLICY "anon_delete_teams" ON teams FOR DELETE TO anon, authenticated USING (true);

-- Team members
DROP POLICY IF EXISTS "anon_select_team_members" ON team_members;
CREATE POLICY "anon_select_team_members" ON team_members FOR SELECT TO anon, authenticated USING (true);
DROP POLICY IF EXISTS "anon_insert_team_members" ON team_members;
CREATE POLICY "anon_insert_team_members" ON team_members FOR INSERT TO anon, authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "anon_update_team_members" ON team_members;
CREATE POLICY "anon_update_team_members" ON team_members FOR UPDATE TO anon, authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "anon_delete_team_members" ON team_members;
CREATE POLICY "anon_delete_team_members" ON team_members FOR DELETE TO anon, authenticated USING (true);

-- Bookings
DROP POLICY IF EXISTS "anon_select_bookings" ON bookings;
CREATE POLICY "anon_select_bookings" ON bookings FOR SELECT TO anon, authenticated USING (true);
DROP POLICY IF EXISTS "anon_insert_bookings" ON bookings;
CREATE POLICY "anon_insert_bookings" ON bookings FOR INSERT TO anon, authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "anon_update_bookings" ON bookings;
CREATE POLICY "anon_update_bookings" ON bookings FOR UPDATE TO anon, authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "anon_delete_bookings" ON bookings;
CREATE POLICY "anon_delete_bookings" ON bookings FOR DELETE TO anon, authenticated USING (true);

-- Booking assignments
DROP POLICY IF EXISTS "anon_select_booking_assignments" ON booking_assignments;
CREATE POLICY "anon_select_booking_assignments" ON booking_assignments FOR SELECT TO anon, authenticated USING (true);
DROP POLICY IF EXISTS "anon_insert_booking_assignments" ON booking_assignments;
CREATE POLICY "anon_insert_booking_assignments" ON booking_assignments FOR INSERT TO anon, authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "anon_update_booking_assignments" ON booking_assignments;
CREATE POLICY "anon_update_booking_assignments" ON booking_assignments FOR UPDATE TO anon, authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "anon_delete_booking_assignments" ON booking_assignments;
CREATE POLICY "anon_delete_booking_assignments" ON booking_assignments FOR DELETE TO anon, authenticated USING (true);

-- Ratings
DROP POLICY IF EXISTS "anon_select_ratings" ON ratings;
CREATE POLICY "anon_select_ratings" ON ratings FOR SELECT TO anon, authenticated USING (true);
DROP POLICY IF EXISTS "anon_insert_ratings" ON ratings;
CREATE POLICY "anon_insert_ratings" ON ratings FOR INSERT TO anon, authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "anon_update_ratings" ON ratings;
CREATE POLICY "anon_update_ratings" ON ratings FOR UPDATE TO anon, authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "anon_delete_ratings" ON ratings;
CREATE POLICY "anon_delete_ratings" ON ratings FOR DELETE TO anon, authenticated USING (true);

-- Requirement profiles
DROP POLICY IF EXISTS "anon_select_requirement_profiles" ON requirement_profiles;
CREATE POLICY "anon_select_requirement_profiles" ON requirement_profiles FOR SELECT TO anon, authenticated USING (true);
DROP POLICY IF EXISTS "anon_insert_requirement_profiles" ON requirement_profiles;
CREATE POLICY "anon_insert_requirement_profiles" ON requirement_profiles FOR INSERT TO anon, authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "anon_update_requirement_profiles" ON requirement_profiles;
CREATE POLICY "anon_update_requirement_profiles" ON requirement_profiles FOR UPDATE TO anon, authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "anon_delete_requirement_profiles" ON requirement_profiles;
CREATE POLICY "anon_delete_requirement_profiles" ON requirement_profiles FOR DELETE TO anon, authenticated USING (true);
