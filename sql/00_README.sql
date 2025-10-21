-- =====================================================
-- SBEROFFICE DATABASE SCHEMA
-- Fizicheskaya model dannykh SberOffice
-- SUBD: PostgreSQL 14+
-- Skhema: sberoffice
-- Data sozdaniya: 2025-10-21
-- =====================================================

-- Dannyi fayl obyedinyaet vse chasti skhemy bazy dannykh
-- Dlya sozdaniya polnoy skhemy vypolnite vse fayly v sleduyuschem poryadke:
-- 1. 01_schema_init.sql        - Inicializaciya skhemy i rasshireniy
-- 2. 02_dictionaries.sql       - Spravochnye tablicy
-- 3. 03_master_data.sql        - Master-dannye
-- 4. 04_transactional_part1.sql - Tranzakcionnye dannye (chast 1)
-- 5. 05_transactional_part2.sql - Tranzakcionnye dannye (chast 2)
-- 6. 06_bookings.sql           - Tablicy bronirovaniy
-- 7. 07_triggers.sql           - Triggery
-- 8. 08_views.sql              - Predstavleniya
-- 9. 09_functions_indexes.sql  - Funkcii i indeksy

-- Alternativno, mozhno vypolnit etot master fayl cherez \i komandu v psql

-- =====================================================
-- SODERZHANIE BAZY DANNYKH
-- =====================================================

-- SPRAVOCHNIKI (12 tablic):
-- - dict_vid_rm
-- - dict_kategoria_rm
-- - dict_sostoyanie_rm
-- - dict_status_rm
-- - dict_tip_zon
-- - dict_tip_oborudovania
-- - dict_rol_polzovatelya
-- - dict_status_zanyatia
-- - dict_svyaz_gosb
-- - dict_sostoyanie
-- - dict_status_polzovania
-- - dict_prednaznachenie_pomeshenia

-- MASTER-DANNYE (7 tablic):
-- - master_osh
-- - master_podrazdelenie
-- - master_podrazdelenie_agile
-- - master_sotrudnik
-- - master_etazh
-- - master_pomeshenie
-- - master_object_bronirovania_plan

-- TRANZAKCIONNYE DANNYE (25 tablic):
-- - object_bronirovania (roditelskaya)
-- - zona_bronirovania
-- - rabochee_mesto
-- - polzovatel_sberoffice (roditelskaya)
-- - professionalny_polzovatel
-- - neprofessionalny_polzovatel
-- - osnashenie
-- - soglasuyushy_zony
-- - gruppa_rassylki
-- - gruppa_rassylki_sotrudnik
-- - vip_dostup
-- - vip_dostup_rm
-- - polnomochiya_object
-- - zakreplenie_podrazdelenie
-- - kategoria_rabochego_mesta
-- - sostoyanie_rabochego_mesta
-- - status_polzovania_rm
-- - subekt_bronirovania
-- - bronirovanie_zony
-- - bronirovanie_zony_uchastnik
-- - bronirovanie_rm
-- - rol_polzovatelya_polzovatel

-- PREDSTAVLENIYA (4 view):
-- - v_zona_bronirovania_full
-- - v_rabochee_mesto_full
-- - v_bronirovanie_zony_active
-- - v_bronirovanie_rm_active

-- FUNKCII (3):
-- - update_updated_at_column()
-- - check_zona_availability()
-- - check_rm_availability()

-- =====================================================
-- KLYUCHEVYE OSOBENNOSTI MODELI
-- =====================================================

-- 1. Pervichnye klyuchi: UUID dlya vsekh tablic
-- 2. Vremennye metki: created_at, updated_at dlya vsekh tablic
-- 3. Myagkoe udalenie: deleted_at dlya vsekh tablic
-- 4. Audit: created_by, updated_by dlya operacionnyh tablic
-- 5. Indeksy: na vneshnikh klyuchakh i chasto ispolzuemykh polyakh
-- 6. Ogranicheniya: CHECK constraints dlya validacii dannykh
-- 7. Kommentarii: na tablicakh i polyakh dlya dokumentirovaniya
-- 8. Nasledovanie: cherez strategy "Table per Type"

-- =====================================================
-- PRIMERY ISPOLZOVANIYA
-- =====================================================

-- Proverka dostupnosti zony:
-- SELECT check_zona_availability(
--     'zona_uuid'::UUID,
--     '2025-10-21 10:00:00'::TIMESTAMP,
--     '2025-10-21 12:00:00'::TIMESTAMP
-- );

-- Poluchenie aktivnykh bronirovaniy zon:
-- SELECT * FROM v_bronirovanie_zony_active;

-- Poisk dostupnykh rabochikh mest:
-- SELECT * FROM v_rabochee_mesto_full 
-- WHERE is_bookable = true AND is_active = true;

-- =====================================================
-- PORYADOK USTANOVKI
-- =====================================================

-- Dlya ustanovki v PostgreSQL:
-- 1. Sozdat bazu dannykh (esli ne suschestvuet):
--    CREATE DATABASE sberoffice_db;
-- 
-- 2. Podklyuchitsya k baze:
--    \c sberoffice_db
-- 
-- 3. Vypolnit vse skripty v poryadke:
--    \i 01_schema_init.sql
--    \i 02_dictionaries.sql
--    \i 03_master_data.sql
--    \i 04_transactional_part1.sql
--    \i 05_transactional_part2.sql
--    \i 06_bookings.sql
--    \i 07_triggers.sql
--    \i 08_views.sql
--    \i 09_functions_indexes.sql

-- =====================================================
-- KONEC FAYLA
-- =====================================================
