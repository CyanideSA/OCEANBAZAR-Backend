-- V5: Ensure admin_users table exists.
-- admin_users is owned by the Prisma/BFF schema; this migration creates it as a
-- fallback so the Java API can start even when BFF migrations have not run yet.
-- All statements are idempotent — safe to run against an already-migrated DB.

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_type t
        JOIN pg_namespace n ON n.oid = t.typnamespace
        WHERE t.typname = 'AdminRole' AND n.nspname = 'public'
    ) THEN
        CREATE TYPE "AdminRole" AS ENUM ('super_admin', 'admin', 'staff');
    END IF;
END $$;

CREATE TABLE IF NOT EXISTS admin_users (
    id            SERIAL PRIMARY KEY,
    name          VARCHAR(255) NOT NULL,
    username      VARCHAR(100) NOT NULL UNIQUE,
    email         VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role          "AdminRole" NOT NULL DEFAULT 'staff',
    active        BOOLEAN NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
