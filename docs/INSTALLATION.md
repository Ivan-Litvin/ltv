# РРќРЎРўР РЈРљР¦РРЇ РџРћ Р РђР—Р’РЃР РўР«Р’РђРќРР®

## Р‘С‹СЃС‚СЂС‹Р№ СЃС‚Р°СЂС‚

### Р’Р°СЂРёР°РЅС‚ 1: РћРґРёРЅ С„Р°Р№Р» (СЂРµРєРѕРјРµРЅРґСѓРµС‚СЃСЏ)

`ash
# 1. РЎРѕР·РґР°С‚СЊ Р±Р°Р·Сѓ РґР°РЅРЅС‹С…
createdb sberoffice_db

# 2. Р’С‹РїРѕР»РЅРёС‚СЊ РїРѕР»РЅС‹Р№ СЃРєСЂРёРїС‚
psql -d sberoffice_db -f sberoffice_full_schema.sql
`

### Р’Р°СЂРёР°РЅС‚ 2: РџРѕСЌС‚Р°РїРЅРѕРµ СЂР°Р·РІС‘СЂС‚С‹РІР°РЅРёРµ

`ash
# 1. РЎРѕР·РґР°С‚СЊ Р±Р°Р·Сѓ РґР°РЅРЅС‹С…
createdb sberoffice_db

# 2. Р’С‹РїРѕР»РЅРёС‚СЊ СЃРєСЂРёРїС‚С‹ РїРѕ РїРѕСЂСЏРґРєСѓ
psql -d sberoffice_db -f 01_schema_init.sql
psql -d sberoffice_db -f 02_dictionaries.sql
psql -d sberoffice_db -f 03_master_data.sql
psql -d sberoffice_db -f 04_transactional_part1.sql
psql -d sberoffice_db -f 05_transactional_part2.sql
psql -d sberoffice_db -f 06_bookings.sql
psql -d sberoffice_db -f 07_triggers.sql
psql -d sberoffice_db -f 08_views.sql
psql -d sberoffice_db -f 09_functions_indexes.sql
`

## РџСЂРѕРІРµСЂРєР° СѓСЃС‚Р°РЅРѕРІРєРё

`sql
-- РџРѕРґРєР»СЋС‡РёС‚СЊСЃСЏ Рє Р±Р°Р·Рµ
\c sberoffice_db

-- РЈСЃС‚Р°РЅРѕРІРёС‚СЊ РїСѓС‚СЊ РїРѕРёСЃРєР°
SET search_path TO sberoffice, public;

-- РџСЂРѕРІРµСЂРёС‚СЊ РєРѕР»РёС‡РµСЃС‚РІРѕ С‚Р°Р±Р»РёС†
SELECT COUNT(*) FROM information_schema.tables 
WHERE table_schema = 'sberoffice' AND table_type = 'BASE TABLE';
-- РћР¶РёРґР°РµС‚СЃСЏ: 44

-- РџСЂРѕРІРµСЂРёС‚СЊ РїСЂРµРґСЃС‚Р°РІР»РµРЅРёСЏ
SELECT COUNT(*) FROM information_schema.views 
WHERE table_schema = 'sberoffice';
-- РћР¶РёРґР°РµС‚СЃСЏ: 4

-- РџСЂРѕРІРµСЂРёС‚СЊ С„СѓРЅРєС†РёРё
SELECT COUNT(*) FROM information_schema.routines 
WHERE routine_schema = 'sberoffice' AND routine_type = 'FUNCTION';
-- РћР¶РёРґР°РµС‚СЃСЏ: 3
`

## РџСЂРёРјРµСЂС‹ РёСЃРїРѕР»СЊР·РѕРІР°РЅРёСЏ

### 1. РџСЂРѕСЃРјРѕС‚СЂ Р·РѕРЅ Р±СЂРѕРЅРёСЂРѕРІР°РЅРёСЏ

`sql
SELECT * FROM sberoffice.v_zona_bronirovania_full
WHERE is_active = true
ORDER BY building_name, floor_number;
`

### 2. РџСЂРѕСЃРјРѕС‚СЂ СЂР°Р±РѕС‡РёС… РјРµСЃС‚

`sql
SELECT * FROM sberoffice.v_rabochee_mesto_full
WHERE is_bookable = true
ORDER BY building_name, floor_number;
`

### 3. РџСЂРѕРІРµСЂРєР° РґРѕСЃС‚СѓРїРЅРѕСЃС‚Рё Р·РѕРЅС‹

`sql
SELECT sberoffice.check_zona_availability(
    'uuid-Р·РѕРЅС‹'::UUID,
    '2025-10-21 10:00:00'::TIMESTAMP,
    '2025-10-21 12:00:00'::TIMESTAMP
) AS is_available;
`

### 4. РђРєС‚РёРІРЅС‹Рµ Р±СЂРѕРЅРёСЂРѕРІР°РЅРёСЏ

`sql
-- Р‘СЂРѕРЅРёСЂРѕРІР°РЅРёСЏ Р·РѕРЅ
SELECT * FROM sberoffice.v_bronirovanie_zony_active
ORDER BY booking_date_from;

-- Р‘СЂРѕРЅРёСЂРѕРІР°РЅРёСЏ Р Рњ
SELECT * FROM sberoffice.v_bronirovanie_rm_active
ORDER BY booking_date_from;
`

## РќР°РїРѕР»РЅРµРЅРёРµ СЃРїСЂР°РІРѕС‡РЅРёРєРѕРІ (РїСЂРёРјРµСЂ)

`sql
-- Р’РёРґС‹ Р Рњ
INSERT INTO sberoffice.dict_vid_rm (code, name, sort_order) VALUES
    ('RM_LINEAR', 'Р Рњ Р»РёРЅРµР№РЅРѕРіРѕ СЃРѕС‚СЂСѓРґРЅРёРєР°', 1),
    ('RM_HEAD_HIGH', 'Р Рњ СЂСѓРєРѕРІРѕРґРёС‚РµР»СЏ РІС‹СЃС€РµРіРѕ Р·РІРµРЅР°', 2),
    ('RM_HEAD_MID', 'Р Рњ СЂСѓРєРѕРІРѕРґРёС‚РµР»СЏ СЃСЂРµРґРЅРµРіРѕ Р·РІРµРЅР°', 3),
    ('RM_HEAD_LOW', 'Р Рњ СЂСѓРєРѕРІРѕРґРёС‚РµР»СЏ РјР»Р°РґС€РµРіРѕ Р·РІРµРЅР°', 4),
    ('RM_EXTERNAL', 'Р Рњ СЃРѕС‚СЂСѓРґРЅРёРєР° РІРЅРµС€РЅРµР№ РѕСЂРіР°РЅРёР·Р°С†РёРё', 5);

-- РљР°С‚РµРіРѕСЂРёРё Р Рњ
INSERT INTO sberoffice.dict_kategoria_rm (code, name, sort_order) VALUES
    ('MAIN', 'РћСЃРЅРѕРІРЅРѕРµ СЂР°Р±РѕС‡РµРµ РјРµСЃС‚Рѕ', 1),
    ('SHARED', 'Р Рњ СЃРѕРІРјРµСЃС‚РЅРѕРіРѕ РїРѕР»СЊР·РѕРІР°РЅРёСЏ', 2),
    ('HOURLY', 'Р Рњ РїРѕС‡Р°СЃРѕРІРѕРіРѕ Р±СЂРѕРЅРёСЂРѕРІР°РЅРёСЏ', 3),
    ('TECH', 'РўРµС…РЅРѕР»РѕРіРёС‡РµСЃРєРѕРµ СЂР°Р±РѕС‡РµРµ РјРµСЃС‚Рѕ', 4),
    ('RESERVE', 'Р РµР·РµСЂРІРЅРѕРµ СЂР°Р±РѕС‡РµРµ РјРµСЃС‚Рѕ', 5),
    ('RESERVE_EMERGENCY', 'Р РµР·РµСЂРІРЅРѕРµ СЂР°Р±РѕС‡РµРµ РјРµСЃС‚Рѕ РЅР° СЃР»СѓС‡Р°Р№ Р§РЎ', 6);

-- РўРёРїС‹ Р·РѕРЅ
INSERT INTO sberoffice.dict_tip_zon (code, name, sort_order) VALUES
    ('MEETING_ROOM', 'РџРµСЂРµРіРѕРІРѕСЂРЅР°СЏ РєРѕРјРЅР°С‚Р°', 1),
    ('CONFERENCE_HALL', 'РљРѕРЅС„РµСЂРµРЅС†-Р·Р°Р»', 2),
    ('COMPUTER_CLASS', 'РљРѕРјРїСЊСЋС‚РµСЂРЅС‹Р№ РєР»Р°СЃСЃ', 3),
    ('COWORKING', 'РљРѕРІРѕСЂРєРёРЅРі', 4),
    ('QUIET_ROOM', 'РўРёС…Р°СЏ РєРѕРјРЅР°С‚Р°', 5);
`

## РЈСЃС‚СЂР°РЅРµРЅРёРµ РЅРµРїРѕР»Р°РґРѕРє

### РћС€РёР±РєР°: СЂР°СЃС€РёСЂРµРЅРёРµ uuid-ossp РЅРµ РЅР°Р№РґРµРЅРѕ

`sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
`

### РћС€РёР±РєР°: СЃС…РµРјР° РЅРµ РЅР°Р№РґРµРЅР°

`sql
CREATE SCHEMA IF NOT EXISTS sberoffice;
SET search_path TO sberoffice, public;
`

### РџРµСЂРµСЃРѕР·РґР°РЅРёРµ Р±Р°Р·С‹

`ash
# РЈРґР°Р»РёС‚СЊ Р±Р°Р·Сѓ
dropdb sberoffice_db

# РЎРѕР·РґР°С‚СЊ Р·Р°РЅРѕРІРѕ
createdb sberoffice_db

# Р’С‹РїРѕР»РЅРёС‚СЊ СЃРєСЂРёРїС‚
psql -d sberoffice_db -f sberoffice_full_schema.sql
`

## РљРѕРЅС‚Р°РєС‚С‹

РџСЂРё РІРѕР·РЅРёРєРЅРѕРІРµРЅРёРё РІРѕРїСЂРѕСЃРѕРІ РѕР±СЂР°С‚РёС‚РµСЃСЊ Рє:
- README.md - РѕР±С‰Р°СЏ РёРЅС„РѕСЂРјР°С†РёСЏ
- FIZICHESKAYA_MODEL_DOKUMENTACIYA.md - РїРѕРґСЂРѕР±РЅР°СЏ РґРѕРєСѓРјРµРЅС‚Р°С†РёСЏ
- ER_DIAGRAM.md - СЃС‚СЂСѓРєС‚СѓСЂР° Р±Р°Р·С‹ РґР°РЅРЅС‹С…
