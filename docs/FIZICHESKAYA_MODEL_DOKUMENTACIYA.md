# FIZICHESKAYA MODEL DANNYKH SBEROFFICE

## Obschaya informaciya

**Nazvanie sistemy:** SberOffice (Upravlenie portfelem nedvizhimosti)
**SUBD:** PostgreSQL 14+
**Skhema:** sberoffice
**Data sozdaniya:** 2025-10-21
**Versiya modeli:** v1.1

## Arkhitektura bazy dannykh

### Tipy tablic

Baza dannykh sostoit iz trekh osnovnykh tipov tablic:

1. **SPRAVOCHNIKI (Dictionary)** - 12 tablic
   - Klassifikatory i spravochnaya informaciya
   - Otnositelno statichnye dannye
   - Obnovlyayutsya administratorami sistemy

2. **MASTER-DANNYE (Master Data)** - 7 tablic
   - Osnovnye sushchnosti, importiruemye iz vneshnikh sistem
   - Sinkhroniziruyutsya s istochnikami (Puls, EASUP, Reestr 2.0)
   - Soderzhit external_id dlya svyazi s istochnikami

3. **TRANZAKCIONNYE DANNYE (Transactional)** - 25 tablic
   - Operacionnye dannye sistemy
   - Sozdayutsya i izmenyayutsya polzovatelyami
   - Soderzhat polnuyu istoriyu izmenenii

### Klyuchevye osobennosti

- **Pervichnye klyuchi:** UUID (uuid_generate_v4())
- **Vremennye metki:** created_at, updated_at
- **Myagkoe udalenie:** deleted_at (soft delete)
- **Audit:** created_by, updated_by
- **Avtomaticheskoe obnovlenie:** Triggery na updated_at
- **Indeksirovaniye:** Na vsekh FK i chasto ispolzuemykh polyakh
- **Validaciya:** CHECK constraints
- **Dokumentaciya:** COMMENT na tablicakh i polyakh

## SPRAVOCHNIKI (12 tablic)

### 1. dict_vid_rm
Vidy rabochikh mest (RM lineynogo sotrudnika, RM rukovoditelya i t.d.)

**Polya:**
- id UUID PRIMARY KEY
- code VARCHAR(100) UNIQUE - Kod vida RM
- name VARCHAR(500) - Naimenovanie
- description TEXT - Opisanie
- is_active BOOLEAN - Aktiven li
- sort_order INTEGER - Poryadok sortirovki

### 2. dict_kategoria_rm
Kategorii RM (Osnovnoe, Sovmestnogo polzovaniya, Pochasovogo bronirovaniya i t.d.)

### 3. dict_sostoyanie_rm
Sostoyaniya RM (Ispolzuetsya, Ne ispolzuetsya, Sdano v arendu, V remonte)

### 4. dict_status_rm
Statusy RM (V polzovanii, Vybyl)

### 5. dict_tip_zon
Tipy zon bronirovaniya (Peregovornaya, Konferenc-zal, Kompyuterny klass i t.d.)

### 6. dict_tip_oborudovania
Tipy oborudovaniya (PK, Klaviatura, Mysh, Monitor, Web-kamera i t.d.)

### 7. dict_rol_polzovatelya
Roli polzovateley sistemy

### 8. dict_status_zanyatia
Statusy zanyatiya RM (Rezerv za podrazdeleniem, Zanyato sotrudnikom i t.d.)

### 9. dict_svyaz_gosb
Svyaz kodov GOSB s polnomochiyami administratorov

### 10. dict_sostoyanie
Obschee sostoyanie objectov (Ispolzuetsya, Remont i t.d.)

### 11. dict_status_polzovania
Statusy polzovaniya (V polzovanii, Vybyl)

### 12. dict_prednaznachenie_pomeshenia
Prednaznacheniya pomescheniy (Open space, Kabinet, Peregovornaya, Servernaya i t.d.)

## MASTER-DANNYE (7 tablic)

### 1. master_osh
Organizacionno-shtatnaya struktura

**Istochnik:** Puls
**Polya:**
- id UUID PRIMARY KEY
- external_id VARCHAR(100) UNIQUE - ID vo vneshnei sisteme
- code VARCHAR(100) - Kod podrazdeleniya
- name VARCHAR(1000) - Naimenovanie
- parent_id UUID - Roditelskoe podrazdelenie
- level_num INTEGER - Uroven v ierarkhii
- path_to_root TEXT - Put k kornyu
- valid_from/valid_to DATE - Period deystviya
- source_system VARCHAR(100) - Istochnik dannykh

**Indeksy:**
- external_id, parent_id, code

### 2. master_podrazdelenie
Podrazdeleniya banka

**Istochnik:** Puls
**Struktura:** Analogichna master_osh

### 3. master_podrazdelenie_agile
Sbergile-struktura (Tribe, Chapter, Squad)

**Istochnik:** Puls
**Dopolnitelnye polya:**
- tribe VARCHAR(500)
- chapter VARCHAR(500)
- squad VARCHAR(500)

### 4. master_sotrudnik
Rabotniki gruppy Sber

**Istochnik:** EASUP/SAP HCM
**Polya:**
- id UUID PRIMARY KEY
- external_id VARCHAR(100) UNIQUE
- personnel_number VARCHAR(50) UNIQUE - Tabelny nomer
- last_name, first_name, middle_name VARCHAR(200)
- full_name VARCHAR(600)
- email VARCHAR(255)
- phone VARCHAR(50)
- position VARCHAR(500) - Dolzhnost
- hire_date DATE - Data priema
- termination_date DATE - Data uvolneniya

**Indeksy:**
- external_id, personnel_number, email

### 5. master_etazh
Etazhi zdaniy

**Istochnik:** Reestr 2.0
**Polya:**
- id UUID PRIMARY KEY
- external_id VARCHAR(100) UNIQUE
- building_id VARCHAR(100) - ID zdaniya
- building_name VARCHAR(500) - Nazvanie zdaniya
- floor_number INTEGER - Nomer etazha
- total_area, usable_area NUMERIC(12,2) - Ploschadi
- status_id UUID -> dict_status_polzovania
- sostoyanie_id UUID -> dict_sostoyanie

### 6. master_pomeshenie
Pomescheniya

**Istochnik:** Reestr 2.0
**Polya:**
- id UUID PRIMARY KEY
- etazh_id UUID -> master_etazh
- room_number VARCHAR(100) - Nomer pomescheniya
- room_name VARCHAR(500) - Nazvanie
- prednaznachenie_id UUID -> dict_prednaznachenie_pomeshenia
- total_area, usable_area NUMERIC(12,2)
- capacity INTEGER - Vmestimost
- status_id, sostoyanie_id UUID - Statusy

### 7. master_object_bronirovania_plan
Raspolozhenie objectov na planakh etazhey

**Polya:**
- id UUID PRIMARY KEY
- object_id UUID -> object_bronirovania
- etazh_id UUID -> master_etazh
- coordinates_x, coordinates_y NUMERIC(10,2)
- svg_path TEXT - SVG dlya otobrazheniya
- floor_plan_url VARCHAR(1000)

## TRANZAKCIONNYE DANNYE

### Objecty bronirovaniya (Nasledovanie)

#### object_bronirovania (Roditelskaya tablica)
Bazovaya tablica dlya vsekh objectov bronirovaniya

**Polya:**
- id UUID PRIMARY KEY
- pomeshenie_id UUID -> master_pomeshenie
- object_type VARCHAR(50) - 'ZONA' ili 'RM'
- name VARCHAR(500)
- description TEXT
- is_active BOOLEAN
- created_by, updated_by UUID

**Strategiya nasledovaniya:** Table per Type

#### zona_bronirovania
Zony bronirovaniya (peregovornye, konferenc-zaly)

**Nasleduet:** object_bronirovania
**Dopolnitelnye polya:**
- id UUID PRIMARY KEY -> object_bronirovania(id)
- tip_zon_id UUID -> dict_tip_zon
- capacity INTEGER - Vmestimost
- min_booking_hours INTEGER - Min chasy bronirovaniya
- max_booking_hours INTEGER - Max chasy bronirovaniya
- require_approval BOOLEAN - Trebuet soglasovaniya
- auto_approval BOOLEAN - Avtosoglasovanie

#### rabochee_mesto
Rabochie mesta

**Nasleduet:** object_bronirovania
**Dopolnitelnye polya:**
- id UUID PRIMARY KEY -> object_bronirovania(id)
- vid_rm_id UUID -> dict_vid_rm
- inventory_number VARCHAR(100) - Inventarny nomer
- workplace_number VARCHAR(100) - Nomer RM
- is_bookable BOOLEAN - Dostupno dlya bronirovaniya

### Polzovateli (Nasledovanie)

#### polzovatel_sberoffice (Roditelskaya)
Vse polzovateli sistemy

**Polya:**
- id UUID PRIMARY KEY
- sotrudnik_id UUID -> master_sotrudnik
- user_type VARCHAR(50) - 'PROFESSIONAL' ili 'NONPROFESSIONAL'
- login VARCHAR(255) UNIQUE
- is_active BOOLEAN
- last_login_at TIMESTAMP

#### professionalny_polzovatel
Professionalnye polzovateli (administratory zon)

**Nasleduet:** polzovatel_sberoffice
**Dopolnitelnye polya:**
- id UUID PRIMARY KEY -> polzovatel_sberoffice(id)
- svyaz_gosb_id UUID -> dict_svyaz_gosb
- administered_pomeshenie_id UUID -> master_pomeshenie
- permissions_level VARCHAR(50)

#### neprofessionalny_polzovatel
Obychnye polzovateli

**Nasleduet:** polzovatel_sberoffice
**Dopolnitelnye polya:**
- id UUID PRIMARY KEY -> polzovatel_sberoffice(id)
- department_code VARCHAR(100)

### Bronirovanie

#### bronirovanie_zony
Bronirovaniya zon

**Polya:**
- id UUID PRIMARY KEY
- zona_id UUID -> zona_bronirovania
- polzovatel_id UUID -> polzovatel_sberoffice
- booking_number VARCHAR(100) UNIQUE - Nomer broni
- booking_date_from/to TIMESTAMP - Period bronirovaniya
- purpose TEXT - Cel bronirovaniya
- participants_count INTEGER - Kolichestvo uchastnikov
- status VARCHAR(50) - PENDING/APPROVED/REJECTED/CANCELLED/COMPLETED
- approved_by UUID - Kto soglasoval
- is_recurring BOOLEAN - Povtoryayuscheesya
- parent_booking_id UUID - Dlya povtoryayuschikhsya

**Indeksy:**
- zona_id, polzovatel_id, dates, status, booking_number

#### bronirovanie_zony_uchastnik (Many-to-Many)
Uchastniki vstrechi

**Polya:**
- bronirovanie_id UUID -> bronirovanie_zony
- sotrudnik_id UUID -> master_sotrudnik
- is_organizer BOOLEAN
- attendance_status VARCHAR(50) - PENDING/ACCEPTED/DECLINED

#### bronirovanie_rm
Bronirovaniya rabochikh mest

**Polya:**
- id UUID PRIMARY KEY
- rabochee_mesto_id UUID -> rabochee_mesto
- polzovatel_id UUID -> polzovatel_sberoffice
- subekt_bronirovania_id UUID -> subekt_bronirovania
- osh_id UUID -> master_osh
- status_zanyatia_id UUID -> dict_status_zanyatia
- booking_number VARCHAR(100) UNIQUE
- booking_date_from/to TIMESTAMP
- is_permanent BOOLEAN - Postoyannoe zakreplenie
- status VARCHAR(50) - ACTIVE/CANCELLED/COMPLETED/EXPIRED

### Dopolnitelnye tablicy

#### osnashenie
Osnashchenie zon oborudovaniem

**Polya:**
- zona_id UUID -> zona_bronirovania
- tip_oborudovania_id UUID -> dict_tip_oborudovania
- quantity INTEGER
- inventory_number, serial_number VARCHAR(100)
- is_working BOOLEAN

#### soglasuyushy_zony
Soglasuyuschie zony bronirovaniya

**Polya:**
- zona_id UUID
- polzovatel_id UUID
- is_primary BOOLEAN
- approval_order INTEGER

#### vip_dostup / vip_dostup_rm
VIP-dostup k zonam i RM

**Polya:**
- zona_id ili rabochee_mesto_id UUID
- sotrudnik_id / podrazdelenie_id UUID
- access_level VARCHAR(100)
- valid_from/to TIMESTAMP

#### gruppa_rassylki
Gruppy rassylki dlya organizacii vstrech

**Svyazannaya tablica:** gruppa_rassylki_sotrudnik (M2M)

#### polnomochiya_object
Polnomochiya po vzaimodeystviyu s objectami

**Polya:**
- polzovatel_id UUID
- etazh_id / pomeshenie_id UUID
- can_view, can_book, can_manage, can_approve BOOLEAN

#### zakreplenie_podrazdelenie
Zakreplenie RM za podrazdeleniyami

**Polya:**
- rabochee_mesto_id UUID
- podrazdelenie_id UUID
- valid_from/to DATE

#### Istoricheskie tablicy RM
- kategoria_rabochego_mesta - Istoriya kategorii
- sostoyanie_rabochego_mesta - Istoriya sostoyaniy
- status_polzovania_rm - Istoriya statusov

**Obschaya struktura:**
- rabochee_mesto_id UUID
- [kategoria/sostoyanie/status]_id UUID
- valid_from/to TIMESTAMP
- is_current BOOLEAN

#### subekt_bronirovania
Subjekt, dlya kotorogo broniruyut

**Polya:**
- sotrudnik_id UUID - Dlya sotrudnikov
- external_person_name VARCHAR(500) - Dlya vneshnikh lic
- external_person_email, phone VARCHAR
- external_company VARCHAR(500)

## PREDSTAVLENIYA (VIEWS)

### 1. v_zona_bronirovania_full
Polnaya informaciya o zonakh s rasshifrovkoy vsekh spravochnikov

### 2. v_rabochee_mesto_full
Polnaya informaciya o rabochikh mestakh

### 3. v_bronirovanie_zony_active
Aktivnye bronirovaniya zon

### 4. v_bronirovanie_rm_active
Aktivnye bronirovaniya RM

## FUNKCII

### 1. update_updated_at_column()
Trigger-funkciya dlya avtomaticheskogo obnovleniya updated_at pri UPDATE

### 2. check_zona_availability(zona_id, date_from, date_to, exclude_booking_id)
Proverka dostupnosti zony dlya bronirovaniya
**Vozvraschaet:** BOOLEAN

### 3. check_rm_availability(rm_id, date_from, date_to, exclude_booking_id)
Proverka dostupnosti RM dlya bronirovaniya
**Vozvraschaet:** BOOLEAN

## INDEKSY

Sozdany indeksy na:
- Vse vneshnie klyuchi (FK)
- Polya poiska (code, name, number)
- Polya filtracii (is_active, status, deleted_at)
- Daty bronirovaniy
- Chastichnye indeksy (partial indexes) dlya aktivnykh zapisey

## CONSTRAINTS

### CHECK Constraints
- object_type IN ('ZONA', 'RM')
- user_type IN ('PROFESSIONAL', 'NONPROFESSIONAL')
- booking_date_from < booking_date_to
- status IN (spisok dopustimykh znacheniy)
- Khoty by odno pole dolzhno byt zapolneno (sotrudnik ili podrazdelenie)

### UNIQUE Constraints
- code v spravochnikakh
- booking_number v bronirovaniyakh
- external_id v master-dannykh
- personnel_number sotrudnikov
- login polzovateley

### FOREIGN KEY Constraints
- ON DELETE CASCADE dlya zavisimykh tablic nasledovaniya
- ON DELETE NO ACTION (default) dlya ssylochnykh svyazey

## PORYADOK USTANOVKI

1. Sozdat bazu dannykh:
`sql
CREATE DATABASE sberoffice_db ENCODING 'UTF8';
`

2. Podklyuchitsya k BD:
`ash
psql -d sberoffice_db
`

3. Vypolnit skripty v poryadke:
`ash
\i 01_schema_init.sql
\i 02_dictionaries.sql
\i 03_master_data.sql
\i 04_transactional_part1.sql
\i 05_transactional_part2.sql
\i 06_bookings.sql
\i 07_triggers.sql
\i 08_views.sql
\i 09_functions_indexes.sql
`

ILI vypolnit odin obedinyonny fayl:
`ash
\i sberoffice_full_schema.sql
`

## PRIMERY ISPOLZOVANIYA

### Proverka dostupnosti zony
`sql
SELECT check_zona_availability(
    'uuid-zony'::UUID,
    '2025-10-21 10:00:00'::TIMESTAMP,
    '2025-10-21 12:00:00'::TIMESTAMP
);
`

### Poisk dostupnykh RM
`sql
SELECT * FROM v_rabochee_mesto_full 
WHERE is_bookable = true 
  AND is_active = true
  AND floor_number = 5;
`

### Sozdanie bronirovaniya zony
`sql
INSERT INTO bronirovanie_zony (
    zona_id, polzovatel_id, booking_date_from, booking_date_to, purpose
) VALUES (
    'zona-uuid'::UUID,
    'user-uuid'::UUID,
    '2025-10-21 10:00:00',
    '2025-10-21 12:00:00',
    'Soveschanie po proektu'
);
`

## INTEGRACIA S VNESHNIMI SISTEMAMI

### Puls
- master_osh
- master_podrazdelenie
- master_podrazdelenie_agile

### EASUP/SAP HCM
- master_sotrudnik

### Reestr 2.0
- master_etazh
- master_pomeshenie
- dict_sostoyanie
- dict_status_polzovania
- dict_prednaznachenie_pomeshenia

## BEZOPASNOST

1. **Razgranichenie dostupa:** Cherez rol PostgreSQL
2. **Audit:** created_by, updated_by polya
3. **Myagkoe udalenie:** deleted_at vmesto realnogo udaleniya
4. **Validaciya:** CHECK constraints
5. **SSL soedinenie:** Rekomendovano dlya production

## PROIZVODITELNOST

1. **Indeksy:** Na vsekh FK i chasto ispolzuemykh polyakh
2. **Partitioning:** Rekomendovano dlya tablic bronirovaniy po datam
3. **Arkhivirovaniye:** Starye bronirovaniya mozhno arkhivirovat
4. **Vacuuming:** Nastroit autovacuum dlya bolshikh tablic

## VERSIYA I IZMENENIYA

**Versiya 1.1** - 2025-10-21
- Pervonachalnaya versiya fizicheskoy modeli
- 44 tablicy (12 spravochnikov, 7 master-dannykh, 25 tranzakcionnykh)
- 4 predstavleniya
- 3 funkcii
- Polnaya indeksaciya
