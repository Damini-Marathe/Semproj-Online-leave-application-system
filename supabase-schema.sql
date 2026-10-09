-- ==========================================================
-- Online Leave Application System - Supabase Database Schema
-- Run this script in your Supabase SQL Editor:
-- (Supabase Dashboard -> Project -> SQL Editor -> New Query -> Run)
-- ==========================================================

-- 1. Create table for Leave Applications
CREATE TABLE IF NOT EXISTS public.leave_applications (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_name TEXT NOT NULL,
    prn TEXT NOT NULL,
    department TEXT NOT NULL,
    year TEXT NOT NULL,
    leave_type TEXT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    reason TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'Pending',
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- 2. Create table for Registered Students
CREATE TABLE IF NOT EXISTS public.students (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    prn TEXT UNIQUE NOT NULL,
    student_name TEXT NOT NULL,
    department TEXT DEFAULT 'Computer Engineering',
    year TEXT DEFAULT 'Third Year',
    password TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- 3. Create table for Admins
CREATE TABLE IF NOT EXISTS public.admins (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    full_name TEXT NOT NULL DEFAULT 'Admin',
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- 4. Insert Default Admin Credentials
INSERT INTO public.admins (username, password, full_name)
VALUES ('rcpit', 'Admin@123', 'RCPIT Administrator')
ON CONFLICT (username) DO NOTHING;

-- 5. Insert Sample Student Credentials
INSERT INTO public.students (prn, student_name, department, year, password)
VALUES ('PRN12345', 'John Doe', 'Computer Engineering', 'Third Year', 'Student@123')
ON CONFLICT (prn) DO NOTHING;

-- 6. Insert Sample Leave Application
INSERT INTO public.leave_applications (student_name, prn, department, year, leave_type, from_date, to_date, reason, status)
VALUES ('John Doe', 'PRN12345', 'Computer Engineering', 'Third Year', 'Medical Leave', CURRENT_DATE, CURRENT_DATE + INTERVAL '2 days', 'Viral fever and doctor consultation', 'Pending')
ON CONFLICT DO NOTHING;

-- 7. Enable Row Level Security (RLS) on all tables
ALTER TABLE public.leave_applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.students ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admins ENABLE ROW LEVEL SECURITY;

-- 8. Drop existing policies if re-running to avoid duplicate policy errors
DROP POLICY IF EXISTS "Public select leave_applications" ON public.leave_applications;
DROP POLICY IF EXISTS "Public insert leave_applications" ON public.leave_applications;
DROP POLICY IF EXISTS "Public update leave_applications" ON public.leave_applications;
DROP POLICY IF EXISTS "Public delete leave_applications" ON public.leave_applications;

DROP POLICY IF EXISTS "Public select students" ON public.students;
DROP POLICY IF EXISTS "Public insert students" ON public.students;

DROP POLICY IF EXISTS "Public select admins" ON public.admins;

-- 9. Create RLS Policies for Leave Applications (Allow Read, Create, and Update)
CREATE POLICY "Public select leave_applications"
ON public.leave_applications FOR SELECT TO anon, authenticated
USING (true);

CREATE POLICY "Public insert leave_applications"
ON public.leave_applications FOR INSERT TO anon, authenticated
WITH CHECK (true);

CREATE POLICY "Public update leave_applications"
ON public.leave_applications FOR UPDATE TO anon, authenticated
USING (true)
WITH CHECK (true);

CREATE POLICY "Public delete leave_applications"
ON public.leave_applications FOR DELETE TO anon, authenticated
USING (true);

-- 10. Create RLS Policies for Students (Allow student login check & registration)
CREATE POLICY "Public select students"
ON public.students FOR SELECT TO anon, authenticated
USING (true);

CREATE POLICY "Public insert students"
ON public.students FOR INSERT TO anon, authenticated
WITH CHECK (true);

-- 11. Create RLS Policies for Admins (Allow admin authentication check)
CREATE POLICY "Public select admins"
ON public.admins FOR SELECT TO anon, authenticated
USING (true);
