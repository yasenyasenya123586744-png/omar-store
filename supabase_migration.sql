-- ══════════════════════════════════════════════
-- OMAR STORE — Supabase Migration
-- Run this in Supabase SQL Editor
-- ══════════════════════════════════════════════

-- 1. Add discount columns to products (safe — won't fail if already exist)
ALTER TABLE products
  ADD COLUMN IF NOT EXISTS discount_type  TEXT    NOT NULL DEFAULT 'none',
  ADD COLUMN IF NOT EXISTS discount_value NUMERIC NOT NULL DEFAULT 0;

-- 2. Create categories table
CREATE TABLE IF NOT EXISTS categories (
  id         UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  name       TEXT        NOT NULL,
  slug       TEXT        NOT NULL UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 3. Seed default categories (skip if already present)
INSERT INTO categories (name, slug)
VALUES
  ('كرياتين',  'creatine'),
  ('بروتين',   'protein'),
  ('ماس جينر', 'mass')
ON CONFLICT (slug) DO NOTHING;

-- 4. Enable Row Level Security (optional but recommended)
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

-- Allow public read
CREATE POLICY IF NOT EXISTS "categories_select_public"
  ON categories FOR SELECT USING (true);

-- Allow all operations via service role (API uses service role key so this is fine)
-- If you want to lock it down further, restrict to authenticated role only.
