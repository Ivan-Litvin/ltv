-- =====================================================
-- Fizicheskaya model dannykh SberOffice
-- SUBD: PostgreSQL 14+
-- Skhema: sberoffice
-- Data sozdaniya: 2025-10-21
-- =====================================================

CREATE SCHEMA IF NOT EXISTS sberoffice;
SET search_path TO sberoffice, public;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
