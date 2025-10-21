# IZMENENIYA V VERSII 1.2

## Obschaya informatsiya

**Data obnovleniya:** 2025-10-21
**Versiya:** 1.2 (rasshirennaya)
**Prichina:** Dobavlenie polnogo funkcionala SberOffice

## Dobavlennye tablicy (9 novykh)

### 1. Servisy i uslugi (3 tablicy)

#### dict_tip_servisa
- Spravochnik tipov servisov (restorany, sportzaly, medkabinety i t.d.)
- Kategorii: FOOD, SPORT, MEDICAL, WELLNESS, OTHER
- Pole requires_booking dlya ukazaniya neobkhodimosti bronirovaniya

#### servis
- Informatsiya o servisakh v zdaniyakh
- Polya: vmestimost, grafik raboty, kontakty
- Parametry bronirovaniya i pravila otmeny
- Svyaz s pomescheniyami i etazhami

#### bronirovanie_servisa
- Bronirovaniya uslug
- Statusy: ACTIVE, COMPLETED, CANCELLED, NO_SHOW
- Otmena s prichinoj i vremenem
- Kolichestvo uchastnikov

### 2. Kompleksnye servisy/zayavki (3 tablicy)

#### dict_tip_zayavki
- Spravochnik tipov zayavok
- Znacheniya: NEW_EMPLOYEE, RELOCATION, TRANSFER, DEPARTMENT_RELOCATION
- Pre-zapolnennye dannye

#### zayavka_kompleksnaya
- Edinaya tablica dlya vsekh kompleksnykh servisov
- Polya dlya vsekh tipov zayavok
- Workflow: NEW -> IN_REVIEW -> APPROVED -> IN_PROGRESS -> COMPLETED -> REJECTED/CANCELLED
- Prioritety: LOW, NORMAL, HIGH, URGENT
- Dannye initiato

ra, celevogo sotrudnika/podrazdeleniya
- Dannye peremescheniya (otkuda/kuda)
- Soglasovaniya i ispolnenie

#### zayavka_status_history
- Istoriya izmeneniy statusov zayavok
- Kto, kogda i pochemu izmenil status
- Polnaya auditiruemost

### 3. Istoriya i monitoring (2 tablicy)

#### rm_peremeschenie_history
- Istoriya vsekh peremescheniy RM
- Dannye otkuda/kuda s koordinatami
- Svyaz s zayavkami
- Prichina peremescheniya
- Kto vypolnil

#### videoanalitika_snapshot
- Snimki s kamer dlya kontrolya zanyatosti
- Uroven uverennosti detektirovaniya
- Kolichestvo obnaruzhennykh lic
- Ssylka na izobrazhenie

#### rm_zanyatost_statistics
- Agregirovannaya statistika zanyatosti po dnyam
- Protsent zanyatosti
- Vremya maksimalnoy zanyatosti
- Total i occupied minutes

### 4. Otchyotnost (2 tablicy)

#### otchet_template
- Shablony otchetov
- Parametrizatsiya cherez JSON
- Podderzhka SQL zaprosov
- Avtomaticheskaya generatsiya po raspisaniyu (cron)
- Formaty: XLSX, PDF, CSV

#### otchet_generated
- Sgenerirovannye otchety
- Parametry generacii
- Ssylka na fayl i ego razmer
- Status obrabotki i oshibki

## Dobavlennye predstavleniya (5 novykh)

### v_servis_full
Polnaya informatsiya o servisakh s rasshifrovkoy spravochnikov

### v_bronirovanie_servisa_active
Aktivnye bronirovaniya servisov

### v_rm_usage_statistics
Statistika ispolzovaniya rabochikh mest:
- Obschee kolichestvo bronirovaniy
- Aktivnye bronirovaniya
- Srednyaya zanyatost
- Poslednee bronirovanie

### v_zayavka_active
Aktivnye zayavki na kompleksnye uslugi
- Tip zayavki
- Iniciator i celevoy sotrudnik
- Statusy i prioritety

### v_dashboard_analytics
Dashboard s klyuchevymi metrikami:
- Obschee i zanyatye RM
- Obschee i zanyatye zony
- Bronirovaniya na segodnya
- Aktivnye zayavki
- Srednyaya zanyatost za nedelyu

## Dobavlennye funkcii (3 novye)

### check_servis_availability()
Proverka dostupnosti servisa s uchyotom vmestimosti
- Parametry: servis_id, date_from, date_to, exclude_booking_id
- Vozvraschaet: BOOLEAN

### calculate_rm_occupancy()
Raschyot zanyatosti RM za period
- Parametry: rabochee_mesto_id, date_from, date_to
- Vozvraschaet: TABLE (date, occupancy_rate, occupied_minutes, total_minutes)

### get_available_services()
Poluchenie spiska dostupnykh servisov
- Parametry: date_from, date_to, category, etazh_id
- Vozvraschaet: TABLE s dostupnymi servisami i kolichestvom mest
- Filtratsiya po kategorii i etazhu

## Obnovlyonnye fayly

1. **sberoffice_full_schema.sql** - Obnovlyonny polny skript
2. **10_additional_features.sql** - Novy modulny skript
3. **11_additional_views_functions.sql** - Novy skript s predstavleniyami
4. **SOOTVETSTVIE_TREBOVANIYAM.md** - Analiz sootvetstviya

## Sovmestimost

вњ… Polnaya obratnaya sovmestimost s versiey 1.1
вњ… Novye tablicy ne vliyayut na suschestvuyuschie
вњ… Mozhno primenit kak patch k suschestvuyuschey BD

## Migratsiya s versii 1.1 na 1.2

`sql
-- Podklyuchitsya k baze
\c sberoffice_db

-- Primenit novye tablicy
\i 10_additional_features.sql

-- Primenit predstavleniya i funkcii
\i 11_additional_views_functions.sql

-- Proverit ustanovku
SELECT COUNT(*) FROM information_schema.tables 
WHERE table_schema = 'sberoffice' AND table_type = 'BASE TABLE';
-- Ozhidaetsya: 55
`

## Statistika izmeneniy

- Dobavleno tablic: +9 (44 -> 55)
- Dobavleno spravochnikov: +2 (12 -> 14)
- Dobavleno tranzakcionnykh: +9 (25 -> 34)
- Dobavleno predstavleniy: +5 (4 -> 9)
- Dobavleno funktsiy: +3 (3 -> 6)
- Dobavleno indeksov: ~20

## Klyuchevye uluchsheniya

1. вњ… Polnoe pokrytie vsekh trebovaniy SberOffice
2. вњ… Podderzhka kompleksnykh servisov (Novy sotrudnik, Peremeschenie, etc.)
3. вњ… Sistema bronirovaniya uslug (sportzaly, psikhologi, etc.)
4. вњ… Videoanalitika dlya kontrolya zanyatosti
5. вњ… Polnaya istoriya peremescheniy
6. вњ… Sistema formirovaniya otchyotov
7. вњ… Dashboard s analitikoy

## Sleduyuschie shagi

1. Napolnit dict_tip_servisa bazovymi servisami
2. Napolnit servis dannymi o fakt servisakh
3. Nastroit videoanalitiku
4. Sozdat shablony otchyotov
5. Realizovat API dlya mobilnykh prilozheniy
6. Nastroit avtomaticheskuyu rasylku otchyotov

---

**Versiya:** 1.2
**Status:** вњ… READY FOR PRODUCTION
**Data:** 2025-10-21
