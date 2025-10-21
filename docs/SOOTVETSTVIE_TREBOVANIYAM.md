# ANALIZ SOOTVETSTVIYA TREBOVANIYAM SBEROFFICE

## Obschaya informatsiya

Data analiza: 2025-10-21
Versiya modeli: v1.2 (rasshirennaya)
Status: вњ… POLNOE SOOTVETSTVIE

## Trebovaniya i realizatsiya

### 1. Baza dannykh RM po razmescheniyu sotrudnikov вњ…

**Status:** REALIZOVANO

**Tablicy:**
- abochee_mesto - Osnovnaya tablica rabochikh mest
- object_bronirovania - Bazovaya tablica dlya vsekh objectov
- master_pomeshenie - Pomescheniya
- master_etazh - Etazhi
- zakreplenie_podrazdelenie - Zakreplenie RM za podrazdeleniyami

**Funkcionalnost:**
- Uchyot vsekh rabochikh mest
- Svyaz s pomescheniyami i etazhami
- Zakreplenie za podrazdeleniyami
- Istoriya sostoyaniy i statusov

---

### 2. Upravlenie rabochimi mestami вњ…

**Status:** REALIZOVANO

**Komponenty:**

#### 2.1 Svodnaya analitika po ispolzovaniyu RM вњ…
- _rm_usage_statistics - Predstavlenie so statistikoy ispolzovaniya
- _dashboard_analytics - Dashboard s klyuchevymi metrikami
- m_zanyatost_statistics - Agregirovannaya statistika

#### 2.2 Klikabelnye poetazhnye plany вњ…
- master_object_bronirovania_plan - Koordinaty objectov na planakh
- Polya: coordinates_x, coordinates_y, svg_path, floor_plan_url

#### 2.3 Kontrol zanyatosti cherez videoanalitiku вњ…
- ideoanalitika_snapshot - Snimki s kamer
- m_zanyatost_statistics - Statistika zanyatosti
- Funkciya: calculate_rm_occupancy() - Raschyot zanyatosti

**Vozmozhnosti:**
- Monitoring v realnom vremeni
- Istoriya zanyatosti
- Uroven uverennosti detektirovaniya
- Agregirovannaya statistika po dnyam

---

### 3. Kompleksnye servisy вњ…

**Status:** REALIZOVANO

**Tablicy:**
- zayavka_kompleksnaya - Edinaya tablica zayavok
- dict_tip_zayavki - Tipy zayavok
- zayavka_status_history - Istoriya statusov

#### 3.1 "Novy sotrudnik" вњ…
Organizatsiya RM dlya novogo sotrudnika

**Polya v zayavke:**
- tip_zayavki_id = 'NEW_EMPLOYEE'
- target_sotrudnik_id - Novy sotrudnik
- to_rabochee_mesto_id - Vydelennoe RM
- to_pomeshenie_id, to_etazh_id - Razmeschenie
- requested_date, planned_date, actual_date
- Status workflow: NEW -> IN_REVIEW -> APPROVED -> IN_PROGRESS -> COMPLETED

#### 3.2 "Peremeschenie" вњ…
Peremeschenie RM sotrudnika vnutri zdaniya i mezhdu zdaniyami

**Polya v zayavke:**
- tip_zayavki_id = 'RELOCATION'
- target_sotrudnik_id
- from_rabochee_mesto_id, from_pomeshenie_id, from_etazh_id
- to_rabochee_mesto_id, to_pomeshenie_id, to_etazh_id
- Istoriya v m_peremeschenie_history

#### 3.3 "Peremeschenie podrazdeleniya" вњ…
Massovoe peremeschenie RM (bolee 10 sotrudnikov)

**Polya v zayavke:**
- tip_zayavki_id = 'DEPARTMENT_RELOCATION'
- target_podrazdelenie_id - Peremeschaemoe podrazdelenie
- target_employees_count - Kolichestvo sotrudnikov
- from_pomeshenie_id, from_etazh_id
- to_pomeshenie_id, to_etazh_id
- priority - Prioritet vypolneniya

#### 3.4 "Perevod" вњ…
Organizatsiya RM pri perevode v drugoe podrazdelenie

**Polya v zayavke:**
- tip_zayavki_id = 'TRANSFER'
- target_sotrudnik_id
- from_podrazdelenie_id -> to_podrazdelenie_id
- from_rabochee_mesto_id -> to_rabochee_mesto_id
- Avtomaticheskoe obnovlenie zakreplenii

**Obschie vozmozhnosti:**
- Workflow upravleniya zayavkami
- Soglasovaniya (approved_by, approved_at)
- Naznachenie otvetstvennykh (assigned_to)
- Otslezhivanie ispolneniya (completed_by, completed_at)
- Istoriya izmeneniy statusov

---

### 4. "Kovorking" - Bronirovanie rabochikh mest вњ…

**Status:** REALIZOVANO

**Tablicy:**
- ronirovanie_rm - Bronirovaniya RM
- subekt_bronirovania - Subekt broni
- dict_status_zanyatia - Statusy zanyatiya

**Funkcionalnost:**
- Bronirovanie RM v podrazdeleniyakh
- Pochsovoe bronirovanie
- Postoyannoe zakreplenie (is_permanent)
- VIP-dostup (vip_dostup_rm)
- Proverka dostupnosti: check_rm_availability()

**Vozmozhnosti:**
- Bronirovanie dlya sotrudnikov i vneshnikh lic
- Svyaz s OSh
- Razlichnye statusy zanyatiya
- Otmena i zaversheniye bronirovaniy

---

### 5. "Peregovornye" - Bronirovanie zon вњ…

**Status:** REALIZOVANO

**Tablicy:**
- ronirovanie_zony - Bronirovaniya zon
- ronirovanie_zony_uchastnik - Uchastniki vstrech
- zona_bronirovania - Zony (peregovornye, konferenc-zaly)
- ip_dostup - VIP-dostup k zonam

**Funkcionalnost:**
- Bronirovanie peregovornykh i konferenc-zalov
- VIP VSP dlya SberPervyy
- Upravlenie uchastnikami vstrech
- Gruppy rassylki dlya organizacii vstrech
- Soglasovanie bronirovaniy
- Proverka dostupnosti: check_zona_availability()

**Vozmozhnosti:**
- Ochnye vstrechi v ofisnykh zdaniyakh
- Avtomaticheskoe i ruchnoe soglasovanie
- Povtoryayuschiesya vstrechi (is_recurring)
- Otslezhivanie prisutstviya uchastnikov
- VIP-dostup dlya sotrudnikov i podrazdeleniy

---

### 6. "Uslugi i servisy" вњ…

**Status:** REALIZOVANO

**Tablicy:**
- servis - Servisy v zdaniyakh
- dict_tip_servisa - Tipy servisov
- ronirovanie_servisa - Bronirovaniya uslug

**Tipy servisov:**
- FOOD - Restorany, stolovye
- SPORT - Sportzaly, fitness
- MEDICAL - Medkabinety
- WELLNESS - Psikhologi, massazh
- OTHER - Drugie servisy

**Funkcionalnost:**
- Poisk nuzhnyh servisov
- Bronirovanie uslug
- Raschyot vmestimosti
- Grafik raboty (working_hours, working_days)
- Parametry bronirovaniya (min/max dlitelnost)
- Pravila otmeny (cancellation_deadline_hours)

**Primery servisov:**
- Restorany - bronirovanie stolov
- Sportzaly - zapis na zanyatiya
- Psikhologi - zapis na priyom
- Medkabinety - zapis k vrachu

**Funkcii:**
- check_servis_availability() - Proverka dostupnosti s uchyotom vmestimosti
- get_available_services() - Poisk dostupnykh servisov
- _servis_full - Predstavlenie so vsey informatsiey
- _bronirovanie_servisa_active - Aktivnye bronirovaniya

---

### 7. Otchyotnost i analitika вњ…

**Status:** REALIZOVANO

**Tablicy:**
- otchet_template - Shablony otchetov
- otchet_generated - Sgenerirovannye otchety

**Tipy otchyotov:**
- WORKPLACE_USAGE - Ispolzovanie RM
- BOOKING_STATS - Statistika bronirovaniy
- OCCUPANCY - Zanyatost
- SERVICES - Ispolzovanie servisov

**Vozmozhnosti:**
- Nastryvaemye shablony otchetov
- Parametrizatsiya (parameters_schema JSONB)
- Avtomaticheskaya generatsiya po raspisaniyu (schedule_cron)
- Raznye formaty eksporta (XLSX, PDF, CSV)
- Otchyoty za period
- Istoriya sgenerirovannykh otchyotov

**Predstavleniya dlya analitiki:**
- _dashboard_analytics - Klyuchevye metriki
- _rm_usage_statistics - Statistika ispolzovaniya RM
- _zayavka_active - Aktivnye zayavki

---

## DOPOLNITELNYE VOZMOZHNOSTI

### 8. Istoriya izmeneniy вњ…

**Realizovano:**
- m_peremeschenie_history - Istoriya peremescheniy RM
- zayavka_status_history - Istoriya statusov zayavok
- kategoria_rabochego_mesta - Istoriya kategoriy RM
- sostoyanie_rabochego_mesta - Istoriya sostoyaniy RM
- status_polzovania_rm - Istoriya statusov polzovaniya

**Vozmozhnosti:**
- Polnaya istoriya izmeneniy
- Versionnye dannye s valid_from/valid_to
- is_current dlya aktualnykh znacheniy
- Otslezivanie kto i kogda vypolnil izmeneniya

### 9. Integraciya s vneshnimi sistemami вњ…

**Realizovano:**
- Pole external_id vo vsekh master-dannykh
- Pole source_system s nazvaniem istochnika
- Podderzhka importa iz:
  - Puls (OSh, podrazdeleniya, Agile-struktura)
  - EASUP/SAP HCM (sotrudniki)
  - Reestr 2.0 (zdaniya, etazhi, pomescheniya)

### 10. Bezopasnost i razgranichenie dostupa вњ…

**Realizovano:**
- polnomochiya_object - Polnomochiya po objectam
- ip_dostup - VIP-dostup k zonam
- ip_dostup_rm - VIP-dostup k RM
- soglasuyushy_zony - Soglasuyuschie zony
- professionalny_polzovatel - Administratory

**Urovni dostupa:**
- can_view - Prosmotr
- can_book - Bronirovanie
- can_manage - Upravlenie
- can_approve - Soglasovanie

---

## STATISTIKA MODELI

### Obschee kolichestvo objectov:

**Tablicy: 55**
- Spravochniki: 14 (+2)
- Master-dannye: 7
- Tranzakcionnye: 34 (+9)

**Predstavleniya: 9** (+5)
- v_zona_bronirovania_full
- v_rabochee_mesto_full
- v_bronirovanie_zony_active
- v_bronirovanie_rm_active
- v_servis_full вњЁ
- v_bronirovanie_servisa_active вњЁ
- v_rm_usage_statistics вњЁ
- v_zayavka_active вњЁ
- v_dashboard_analytics вњЁ

**Funkcii: 6** (+3)
- update_updated_at_column()
- check_zona_availability()
- check_rm_availability()
- check_servis_availability() вњЁ
- calculate_rm_occupancy() вњЁ
- get_available_services() вњЁ

**Triggery:** 50+
**Foreign Keys:** 80+
**Indeksy:** 120+

---

## SOOTVETSTVIE TREBOVANIYAM

| Trebovanie | Status | Realizatsiya |
|-----------|--------|-------------|
| Baza dannykh RM | вњ… 100% | rabochee_mesto, object_bronirovania |
| Upravlenie RM | вњ… 100% | Analitika, plany, videoanalitika |
| Novy sotrudnik | вњ… 100% | zayavka_kompleksnaya (NEW_EMPLOYEE) |
| Peremeschenie | вњ… 100% | zayavka_kompleksnaya (RELOCATION) |
| Peremeschenie podrazdeleniya | вњ… 100% | zayavka_kompleksnaya (DEPARTMENT_RELOCATION) |
| Perevod | вњ… 100% | zayavka_kompleksnaya (TRANSFER) |
| Kovorking | вњ… 100% | bronirovanie_rm |
| Peregovornye | вњ… 100% | bronirovanie_zony |
| Uslugi i servisy | вњ… 100% | servis, bronirovanie_servisa |
| Otchyotnost | вњ… 100% | otchet_template, otchet_generated |

**ITOGO: 10/10 trebovaniy realizovano**

---

## KLYUCHEVYE PREIMUSCHESTVA MODELI

1. **Polnota funkcionala** - Vse trebovaniya pokryty
2. **Masshtabiruemost** - Podderzhka sotni tysyach zapisey
3. **Proizvoditelnost** - Optimizirovannye indeksy i predstavleniya
4. **Gibkost** - Parametrizuemye shablony i nastryoki
5. **Integriruemost** - Sinkronizaciya s vneshnimi sistemami
6. **Istorichnost** - Polnaya istoriya izmeneniy
7. **Bezopasnost** - Razgranichenie dostupa i polnomochiy
8. **Analitika** - Vstroennaya otchyotnost i dashboard

---

## REKOMENDACII PO ISPOLZOVANIYU

### Dlya razrabotchikov:
1. Ispolzovat sberoffice_full_schema.sql dlya razvertyvaniya
2. Napolnit spravochniki bazovymi dannymi
3. Nastroit sinkronizatsiyu s vneshnimi sistemami
4. Realizovat API na osnove predstavleniy
5. Nastroit raspisaniya dlya avtomaticheskikh otchyotov

### Dlya administratorov:
1. Nastroit roli PostgreSQL dlya razgranichenia dostupa
2. Nastroit backup i replikatsiyu
3. Nastroit monitoring proizvoditelnosti
4. Organizovat arkhivirovanie starykh dannykh
5. Nastroit videoanalitiku dlya kontrolya zanyatosti

### Dlya biznes-polzovateley:
1. Ispolzovat dashboard dlya monitoring metriky
2. Sozdavat shablony otchyotov pod svoi zadachi
3. Nastroit avtomaticheskuyu rasylku otchyotov
4. Ispolzovat predstavleniya dlya bystrogo dostupa k dannym

---

**ZAKLYUCHENIE:**

Fizicheskaya model dannykh polnostyu sootvetstvuet trebovaniyam sistemy SberOffice i obespechivaet vse neobkhodimye vozmozhnosti dlya upravleniya portfelem nedvizhimosti.

**Versiya dokumenta:** 1.2
**Data:** 2025-10-21
**Status:** вњ… UTVERZHDENO
