-- =====================================================
-- Fizicheskaya model dannykh SberOffice
-- SUBD: PostgreSQL 14+
-- Skhema: sberoffice
-- Data sozdaniya: 2025-10-21
-- =====================================================

CREATE SCHEMA IF NOT EXISTS sberoffice;
SET search_path TO sberoffice, public;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
-- =====================================================
-- SPRAVOCHNIKI (DICTIONARIES)
-- =====================================================

-- Spravochnik: Vid RM
CREATE TABLE dict_vid_rm (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(500) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    sort_order INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

COMMENT ON TABLE dict_vid_rm IS 'Spravochnik vidov rabochikh mest';

-- Spravochnik: Kategoriya RM
CREATE TABLE dict_kategoria_rm (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(500) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    sort_order INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

COMMENT ON TABLE dict_kategoria_rm IS 'Kategoriya RM';

-- Spravochnik: Sostoyanie RM
CREATE TABLE dict_sostoyanie_rm (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(500) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    sort_order INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

COMMENT ON TABLE dict_sostoyanie_rm IS 'Sostoyanie RM';

-- Spravochnik: Status RM
CREATE TABLE dict_status_rm (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(500) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    sort_order INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

COMMENT ON TABLE dict_status_rm IS 'Status RM';

-- Spravochnik: Tip zon
CREATE TABLE dict_tip_zon (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(500) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    sort_order INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

COMMENT ON TABLE dict_tip_zon IS 'Spravochnik tipov zon';

-- Spravochnik: Tip oborudovaniya
CREATE TABLE dict_tip_oborudovania (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(500) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    sort_order INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

COMMENT ON TABLE dict_tip_oborudovania IS 'Tipy oborudovaniya';

-- Spravochnik: Rol polzovatelya
CREATE TABLE dict_rol_polzovatelya (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(500) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    sort_order INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

COMMENT ON TABLE dict_rol_polzovatelya IS 'Roli polzovateley sistemy';

-- Spravochnik: Status zanyatiya
CREATE TABLE dict_status_zanyatia (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(500) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    sort_order INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

COMMENT ON TABLE dict_status_zanyatia IS 'Status zanyatiya';

-- Spravochnik: Svyaz GOSB
CREATE TABLE dict_svyaz_gosb (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(100) NOT NULL UNIQUE,
    gosb_code VARCHAR(100),
    name VARCHAR(500) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

COMMENT ON TABLE dict_svyaz_gosb IS 'Svyaz koda GOSB s polnomochiyami administratora';

-- Spravochnik: Sostoyanie
CREATE TABLE dict_sostoyanie (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(500) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    sort_order INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

COMMENT ON TABLE dict_sostoyanie IS 'Sostoyanie';

-- Spravochnik: Status polzovaniya
CREATE TABLE dict_status_polzovania (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(500) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    sort_order INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

COMMENT ON TABLE dict_status_polzovania IS 'Status polzovaniya';

-- Spravochnik: Prednaznachenie pomescheniya
CREATE TABLE dict_prednaznachenie_pomeshenia (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(500) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    sort_order INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

COMMENT ON TABLE dict_prednaznachenie_pomeshenia IS 'Prednaznachenie pomescheniya';
-- =====================================================
-- MASTER-DANNYE (MASTER DATA)
-- =====================================================

-- Master-dannye: OSh
CREATE TABLE master_osh (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    external_id VARCHAR(100) UNIQUE,
    code VARCHAR(100),
    name VARCHAR(1000) NOT NULL,
    full_name TEXT,
    parent_id UUID,
    level_num INTEGER,
    path_to_root TEXT,
    is_active BOOLEAN DEFAULT true,
    valid_from DATE,
    valid_to DATE,
    source_system VARCHAR(100) DEFAULT 'Puls',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES master_osh(id)
);

COMMENT ON TABLE master_osh IS 'Organizacionno-shtatnaya struktura (import iz Puls)';
CREATE INDEX idx_osh_external_id ON master_osh(external_id);
CREATE INDEX idx_osh_parent_id ON master_osh(parent_id);
CREATE INDEX idx_osh_code ON master_osh(code);

-- Master-dannye: Podrazdelenie
CREATE TABLE master_podrazdelenie (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    external_id VARCHAR(100) UNIQUE,
    code VARCHAR(100),
    name VARCHAR(1000) NOT NULL,
    full_name TEXT,
    parent_id UUID,
    level_num INTEGER,
    path_to_root TEXT,
    is_active BOOLEAN DEFAULT true,
    valid_from DATE,
    valid_to DATE,
    source_system VARCHAR(100) DEFAULT 'Puls',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES master_podrazdelenie(id)
);

COMMENT ON TABLE master_podrazdelenie IS 'Podrazdelenie banka (import iz Puls)';
CREATE INDEX idx_podrazdelenie_external_id ON master_podrazdelenie(external_id);
CREATE INDEX idx_podrazdelenie_parent_id ON master_podrazdelenie(parent_id);
CREATE INDEX idx_podrazdelenie_code ON master_podrazdelenie(code);

-- Master-dannye: Podrazdelenie Agile
CREATE TABLE master_podrazdelenie_agile (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    external_id VARCHAR(100) UNIQUE,
    code VARCHAR(100),
    name VARCHAR(1000) NOT NULL,
    full_name TEXT,
    parent_id UUID,
    level_num INTEGER,
    path_to_root TEXT,
    tribe VARCHAR(500),
    chapter VARCHAR(500),
    squad VARCHAR(500),
    is_active BOOLEAN DEFAULT true,
    valid_from DATE,
    valid_to DATE,
    source_system VARCHAR(100) DEFAULT 'Puls',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES master_podrazdelenie_agile(id)
);

COMMENT ON TABLE master_podrazdelenie_agile IS 'Sbergile-struktura (import iz Puls)';
CREATE INDEX idx_podrazdelenie_agile_external_id ON master_podrazdelenie_agile(external_id);
CREATE INDEX idx_podrazdelenie_agile_parent_id ON master_podrazdelenie_agile(parent_id);

-- Master-dannye: Sotrudnik
CREATE TABLE master_sotrudnik (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    external_id VARCHAR(100) UNIQUE,
    personnel_number VARCHAR(50) UNIQUE NOT NULL,
    last_name VARCHAR(200),
    first_name VARCHAR(200),
    middle_name VARCHAR(200),
    full_name VARCHAR(600),
    email VARCHAR(255),
    phone VARCHAR(50),
    position VARCHAR(500),
    is_active BOOLEAN DEFAULT true,
    hire_date DATE,
    termination_date DATE,
    source_system VARCHAR(100) DEFAULT 'EASUP/SAP HCM',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

COMMENT ON TABLE master_sotrudnik IS 'Rabotnik gruppy Sber (import iz EASUP/SAP HCM)';
CREATE INDEX idx_sotrudnik_external_id ON master_sotrudnik(external_id);
CREATE INDEX idx_sotrudnik_personnel_number ON master_sotrudnik(personnel_number);
CREATE INDEX idx_sotrudnik_email ON master_sotrudnik(email);

-- Master-dannye: Etazh
CREATE TABLE master_etazh (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    external_id VARCHAR(100) UNIQUE,
    building_id VARCHAR(100),
    building_name VARCHAR(500),
    floor_number INTEGER NOT NULL,
    floor_name VARCHAR(200),
    total_area NUMERIC(12,2),
    usable_area NUMERIC(12,2),
    address TEXT,
    status_id UUID,
    sostoyanie_id UUID,
    is_active BOOLEAN DEFAULT true,
    source_system VARCHAR(100) DEFAULT 'Reestr 2.0',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (status_id) REFERENCES dict_status_polzovania(id),
    FOREIGN KEY (sostoyanie_id) REFERENCES dict_sostoyanie(id)
);

COMMENT ON TABLE master_etazh IS 'Informaciya ob etazhe (import iz Reestr 2.0)';
CREATE INDEX idx_etazh_external_id ON master_etazh(external_id);
CREATE INDEX idx_etazh_building_id ON master_etazh(building_id);
CREATE INDEX idx_etazh_floor_number ON master_etazh(floor_number);

-- Master-dannye: Pomeschenie
CREATE TABLE master_pomeshenie (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    external_id VARCHAR(100) UNIQUE,
    etazh_id UUID NOT NULL,
    room_number VARCHAR(100),
    room_name VARCHAR(500),
    prednaznachenie_id UUID,
    total_area NUMERIC(12,2),
    usable_area NUMERIC(12,2),
    capacity INTEGER,
    status_id UUID,
    sostoyanie_id UUID,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    source_system VARCHAR(100) DEFAULT 'Reestr 2.0',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (etazh_id) REFERENCES master_etazh(id),
    FOREIGN KEY (prednaznachenie_id) REFERENCES dict_prednaznachenie_pomeshenia(id),
    FOREIGN KEY (status_id) REFERENCES dict_status_polzovania(id),
    FOREIGN KEY (sostoyanie_id) REFERENCES dict_sostoyanie(id)
);

COMMENT ON TABLE master_pomeshenie IS 'Polnaya informaciya o pomeschenii (import iz Reestr 2.0)';
CREATE INDEX idx_pomeshenie_external_id ON master_pomeshenie(external_id);
CREATE INDEX idx_pomeshenie_etazh_id ON master_pomeshenie(etazh_id);
CREATE INDEX idx_pomeshenie_room_number ON master_pomeshenie(room_number);

-- Master-dannye: Object bronirovaniya na plane etazha
CREATE TABLE master_object_bronirovania_plan (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    object_id UUID NOT NULL,
    etazh_id UUID NOT NULL,
    floor_plan_url VARCHAR(1000),
    coordinates_x NUMERIC(10,2),
    coordinates_y NUMERIC(10,2),
    svg_path TEXT,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (etazh_id) REFERENCES master_etazh(id)
);

COMMENT ON TABLE master_object_bronirovania_plan IS 'Raspolozhenie objecta bronirovaniya na plane etazha';
CREATE INDEX idx_object_plan_object_id ON master_object_bronirovania_plan(object_id);
CREATE INDEX idx_object_plan_etazh_id ON master_object_bronirovania_plan(etazh_id);
-- =====================================================
-- TRANZAKCIONNYE DANNYE (TRANSACTIONAL DATA) - Part 1
-- =====================================================

-- Object bronirovaniya (roditelskaya tablica)
CREATE TABLE object_bronirovania (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pomeshenie_id UUID NOT NULL,
    object_type VARCHAR(50) NOT NULL CHECK (object_type IN ('ZONA', 'RM')),
    name VARCHAR(500) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    deleted_at TIMESTAMP,
    FOREIGN KEY (pomeshenie_id) REFERENCES master_pomeshenie(id)
);

COMMENT ON TABLE object_bronirovania IS 'Informaciya ob objectakh bronirovaniya - zonakh i rabochikh mestakh';
CREATE INDEX idx_object_bronirovania_pomeshenie_id ON object_bronirovania(pomeshenie_id);
CREATE INDEX idx_object_bronirovania_type ON object_bronirovania(object_type);

-- Zona bronirovaniya
CREATE TABLE zona_bronirovania (
    id UUID PRIMARY KEY,
    tip_zon_id UUID NOT NULL,
    capacity INTEGER,
    min_booking_hours INTEGER,
    max_booking_hours INTEGER,
    require_approval BOOLEAN DEFAULT false,
    auto_approval BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (id) REFERENCES object_bronirovania(id) ON DELETE CASCADE,
    FOREIGN KEY (tip_zon_id) REFERENCES dict_tip_zon(id)
);

COMMENT ON TABLE zona_bronirovania IS 'Zony bronirovaniya (peregovornye, konferenc-zaly i t.d.)';
CREATE INDEX idx_zona_bronirovania_tip_zon_id ON zona_bronirovania(tip_zon_id);

-- Rabochee mesto
CREATE TABLE rabochee_mesto (
    id UUID PRIMARY KEY,
    vid_rm_id UUID NOT NULL,
    inventory_number VARCHAR(100),
    workplace_number VARCHAR(100),
    is_bookable BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (id) REFERENCES object_bronirovania(id) ON DELETE CASCADE,
    FOREIGN KEY (vid_rm_id) REFERENCES dict_vid_rm(id)
);

COMMENT ON TABLE rabochee_mesto IS 'Informaciya o rabochikh mestakh';
CREATE INDEX idx_rabochee_mesto_vid_rm_id ON rabochee_mesto(vid_rm_id);
CREATE INDEX idx_rabochee_mesto_inventory ON rabochee_mesto(inventory_number);

-- Polzovatel Sberoffice (roditelskaya)
CREATE TABLE polzovatel_sberoffice (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sotrudnik_id UUID NOT NULL,
    user_type VARCHAR(50) NOT NULL CHECK (user_type IN ('PROFESSIONAL', 'NONPROFESSIONAL')),
    login VARCHAR(255) UNIQUE,
    is_active BOOLEAN DEFAULT true,
    last_login_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (sotrudnik_id) REFERENCES master_sotrudnik(id)
);

COMMENT ON TABLE polzovatel_sberoffice IS 'Polzovateli sistemy Sberoffice';
CREATE INDEX idx_polzovatel_sotrudnik_id ON polzovatel_sberoffice(sotrudnik_id);
CREATE INDEX idx_polzovatel_login ON polzovatel_sberoffice(login);

-- Professionalny polzovatel
CREATE TABLE professionalny_polzovatel (
    id UUID PRIMARY KEY,
    svyaz_gosb_id UUID,
    administered_pomeshenie_id UUID,
    permissions_level VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (id) REFERENCES polzovatel_sberoffice(id) ON DELETE CASCADE,
    FOREIGN KEY (svyaz_gosb_id) REFERENCES dict_svyaz_gosb(id),
    FOREIGN KEY (administered_pomeshenie_id) REFERENCES master_pomeshenie(id)
);

COMMENT ON TABLE professionalny_polzovatel IS 'Professionalnye polzovateli (administratory zon)';
CREATE INDEX idx_prof_polzovatel_svyaz_gosb ON professionalny_polzovatel(svyaz_gosb_id);

-- Neprofessionalny polzovatel
CREATE TABLE neprofessionalny_polzovatel (
    id UUID PRIMARY KEY,
    department_code VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (id) REFERENCES polzovatel_sberoffice(id) ON DELETE CASCADE
);

COMMENT ON TABLE neprofessionalny_polzovatel IS 'Neprofessionalnye polzovateli (obychnye sotrudniki)';

-- Osnashenie
CREATE TABLE osnashenie (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    zona_id UUID NOT NULL,
    tip_oborudovania_id UUID NOT NULL,
    quantity INTEGER DEFAULT 1,
    inventory_number VARCHAR(100),
    serial_number VARCHAR(100),
    is_working BOOLEAN DEFAULT true,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (zona_id) REFERENCES zona_bronirovania(id),
    FOREIGN KEY (tip_oborudovania_id) REFERENCES dict_tip_oborudovania(id)
);

COMMENT ON TABLE osnashenie IS 'Osnashenie zony bronirovaniya';
CREATE INDEX idx_osnashenie_zona_id ON osnashenie(zona_id);
CREATE INDEX idx_osnashenie_tip_oborudovania_id ON osnashenie(tip_oborudovania_id);

-- Soglasuyushy zony
CREATE TABLE soglasuyushy_zony (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    zona_id UUID NOT NULL,
    polzovatel_id UUID NOT NULL,
    is_primary BOOLEAN DEFAULT false,
    approval_order INTEGER,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (zona_id) REFERENCES zona_bronirovania(id),
    FOREIGN KEY (polzovatel_id) REFERENCES polzovatel_sberoffice(id)
);

COMMENT ON TABLE soglasuyushy_zony IS 'Informaciya o soglasuyuschikh zon bronirovaniya';
CREATE INDEX idx_soglasuyushy_zona_id ON soglasuyushy_zony(zona_id);
CREATE INDEX idx_soglasuyushy_polzovatel_id ON soglasuyushy_zony(polzovatel_id);

-- Gruppa rassylki
CREATE TABLE gruppa_rassylki (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    creator_id UUID NOT NULL,
    name VARCHAR(500) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (creator_id) REFERENCES master_sotrudnik(id)
);

COMMENT ON TABLE gruppa_rassylki IS 'Gruppy rassylki dlya uchastnikov vstrech';
CREATE INDEX idx_gruppa_rassylki_creator_id ON gruppa_rassylki(creator_id);

-- Svyaz: Gruppa rassylki - Sotrudnik (many-to-many)
CREATE TABLE gruppa_rassylki_sotrudnik (
    gruppa_id UUID NOT NULL,
    sotrudnik_id UUID NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (gruppa_id, sotrudnik_id),
    FOREIGN KEY (gruppa_id) REFERENCES gruppa_rassylki(id) ON DELETE CASCADE,
    FOREIGN KEY (sotrudnik_id) REFERENCES master_sotrudnik(id)
);

COMMENT ON TABLE gruppa_rassylki_sotrudnik IS 'Uchastniki gruppy rassylki';
CREATE INDEX idx_gr_sotrudnik_gruppa ON gruppa_rassylki_sotrudnik(gruppa_id);
CREATE INDEX idx_gr_sotrudnik_sotrudnik ON gruppa_rassylki_sotrudnik(sotrudnik_id);
-- =====================================================
-- TRANZAKCIONNYE DANNYE (TRANSACTIONAL DATA) - Part 2
-- =====================================================

-- VIP-dostup
CREATE TABLE vip_dostup (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    zona_id UUID NOT NULL,
    sotrudnik_id UUID,
    podrazdelenie_id UUID,
    podrazdelenie_agile_id UUID,
    etazh_id UUID,
    access_level VARCHAR(100),
    valid_from TIMESTAMP,
    valid_to TIMESTAMP,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (zona_id) REFERENCES zona_bronirovania(id),
    FOREIGN KEY (sotrudnik_id) REFERENCES master_sotrudnik(id),
    FOREIGN KEY (podrazdelenie_id) REFERENCES master_podrazdelenie(id),
    FOREIGN KEY (podrazdelenie_agile_id) REFERENCES master_podrazdelenie_agile(id),
    FOREIGN KEY (etazh_id) REFERENCES master_etazh(id),
    CHECK (sotrudnik_id IS NOT NULL OR podrazdelenie_id IS NOT NULL OR podrazdelenie_agile_id IS NOT NULL)
);

COMMENT ON TABLE vip_dostup IS 'Informaciya o sotrudnikakh s VIP dostupom k zonam';
CREATE INDEX idx_vip_dostup_zona_id ON vip_dostup(zona_id);
CREATE INDEX idx_vip_dostup_sotrudnik_id ON vip_dostup(sotrudnik_id);
CREATE INDEX idx_vip_dostup_podrazdelenie_id ON vip_dostup(podrazdelenie_id);

-- VIP-dostup dlya RM
CREATE TABLE vip_dostup_rm (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    rabochee_mesto_id UUID NOT NULL,
    sotrudnik_id UUID NOT NULL,
    etazh_id UUID,
    access_level VARCHAR(100),
    valid_from TIMESTAMP,
    valid_to TIMESTAMP,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (rabochee_mesto_id) REFERENCES rabochee_mesto(id),
    FOREIGN KEY (sotrudnik_id) REFERENCES master_sotrudnik(id),
    FOREIGN KEY (etazh_id) REFERENCES master_etazh(id)
);

COMMENT ON TABLE vip_dostup_rm IS 'Informaciya o sotrudnikakh, obladayuschikh VIP dostupom k RM';
CREATE INDEX idx_vip_dostup_rm_rm_id ON vip_dostup_rm(rabochee_mesto_id);
CREATE INDEX idx_vip_dostup_rm_sotrudnik_id ON vip_dostup_rm(sotrudnik_id);

-- Polnomochiya po vzaimodeystviyu s objectami
CREATE TABLE polnomochiya_object (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    polzovatel_id UUID NOT NULL,
    etazh_id UUID,
    pomeshenie_id UUID,
    can_view BOOLEAN DEFAULT true,
    can_book BOOLEAN DEFAULT false,
    can_manage BOOLEAN DEFAULT false,
    can_approve BOOLEAN DEFAULT false,
    valid_from TIMESTAMP,
    valid_to TIMESTAMP,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (polzovatel_id) REFERENCES polzovatel_sberoffice(id),
    FOREIGN KEY (etazh_id) REFERENCES master_etazh(id),
    FOREIGN KEY (pomeshenie_id) REFERENCES master_pomeshenie(id)
);

COMMENT ON TABLE polnomochiya_object IS 'Spisok polnomochiy po vzaimodeystviyu s objectami bronirovaniya';
CREATE INDEX idx_polnomochiya_polzovatel_id ON polnomochiya_object(polzovatel_id);
CREATE INDEX idx_polnomochiya_etazh_id ON polnomochiya_object(etazh_id);

-- Zakreplenie za podrazdeleniem
CREATE TABLE zakreplenie_podrazdelenie (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    rabochee_mesto_id UUID NOT NULL,
    podrazdelenie_id UUID NOT NULL,
    valid_from DATE NOT NULL,
    valid_to DATE,
    is_active BOOLEAN DEFAULT true,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (rabochee_mesto_id) REFERENCES rabochee_mesto(id),
    FOREIGN KEY (podrazdelenie_id) REFERENCES master_podrazdelenie(id)
);

COMMENT ON TABLE zakreplenie_podrazdelenie IS 'Informaciya o tom, za kakim podrazdeleniem zakrepleno RM';
CREATE INDEX idx_zakreplenie_rm_id ON zakreplenie_podrazdelenie(rabochee_mesto_id);
CREATE INDEX idx_zakreplenie_podrazdelenie_id ON zakreplenie_podrazdelenie(podrazdelenie_id);
CREATE INDEX idx_zakreplenie_dates ON zakreplenie_podrazdelenie(valid_from, valid_to);

-- Kategoriya rabochego mesta
CREATE TABLE kategoria_rabochego_mesta (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    rabochee_mesto_id UUID NOT NULL,
    kategoria_rm_id UUID NOT NULL,
    valid_from TIMESTAMP NOT NULL,
    valid_to TIMESTAMP,
    is_current BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (rabochee_mesto_id) REFERENCES rabochee_mesto(id),
    FOREIGN KEY (kategoria_rm_id) REFERENCES dict_kategoria_rm(id)
);

COMMENT ON TABLE kategoria_rabochego_mesta IS 'Kategoriya i tip rabochego mesta, a takzhe istoriya tipov RM';
CREATE INDEX idx_kategoria_rm_rm_id ON kategoria_rabochego_mesta(rabochee_mesto_id);
CREATE INDEX idx_kategoria_rm_kategoria_id ON kategoria_rabochego_mesta(kategoria_rm_id);
CREATE INDEX idx_kategoria_rm_current ON kategoria_rabochego_mesta(is_current);

-- Sostoyanie rabochego mesta
CREATE TABLE sostoyanie_rabochego_mesta (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    rabochee_mesto_id UUID NOT NULL,
    sostoyanie_rm_id UUID NOT NULL,
    valid_from TIMESTAMP NOT NULL,
    valid_to TIMESTAMP,
    is_current BOOLEAN DEFAULT true,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (rabochee_mesto_id) REFERENCES rabochee_mesto(id),
    FOREIGN KEY (sostoyanie_rm_id) REFERENCES dict_sostoyanie_rm(id)
);

COMMENT ON TABLE sostoyanie_rabochego_mesta IS 'Istoriya sostoyaniy rabochego mesta';
CREATE INDEX idx_sostoyanie_rm_rm_id ON sostoyanie_rabochego_mesta(rabochee_mesto_id);
CREATE INDEX idx_sostoyanie_rm_sostoyanie_id ON sostoyanie_rabochego_mesta(sostoyanie_rm_id);
CREATE INDEX idx_sostoyanie_rm_current ON sostoyanie_rabochego_mesta(is_current);

-- Status polzovaniya RM
CREATE TABLE status_polzovania_rm (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    rabochee_mesto_id UUID NOT NULL,
    status_rm_id UUID NOT NULL,
    valid_from TIMESTAMP NOT NULL,
    valid_to TIMESTAMP,
    is_current BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (rabochee_mesto_id) REFERENCES rabochee_mesto(id),
    FOREIGN KEY (status_rm_id) REFERENCES dict_status_rm(id)
);

COMMENT ON TABLE status_polzovania_rm IS 'Istoriya statusov polzovaniya RM';
CREATE INDEX idx_status_polzovania_rm_id ON status_polzovania_rm(rabochee_mesto_id);
CREATE INDEX idx_status_polzovania_status_id ON status_polzovania_rm(status_rm_id);
CREATE INDEX idx_status_polzovania_current ON status_polzovania_rm(is_current);

-- Subekt bronirovaniya
CREATE TABLE subekt_bronirovania (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sotrudnik_id UUID,
    external_person_name VARCHAR(500),
    external_person_email VARCHAR(255),
    external_person_phone VARCHAR(50),
    external_company VARCHAR(500),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (sotrudnik_id) REFERENCES master_sotrudnik(id),
    CHECK (sotrudnik_id IS NOT NULL OR external_person_name IS NOT NULL)
);

COMMENT ON TABLE subekt_bronirovania IS 'Informaciya o tom, dlya kogo broniruyut RM';
CREATE INDEX idx_subekt_bronirovania_sotrudnik_id ON subekt_bronirovania(sotrudnik_id);
-- =====================================================
-- TABLICY BRONIROVANIY
-- =====================================================

-- Bronirovanie zony
CREATE TABLE bronirovanie_zony (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    zona_id UUID NOT NULL,
    polzovatel_id UUID NOT NULL,
    booking_number VARCHAR(100) UNIQUE,
    booking_date_from TIMESTAMP NOT NULL,
    booking_date_to TIMESTAMP NOT NULL,
    purpose TEXT,
    participants_count INTEGER,
    status VARCHAR(50) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'APPROVED', 'REJECTED', 'CANCELLED', 'COMPLETED')),
    approval_status VARCHAR(50),
    approved_by UUID,
    approved_at TIMESTAMP,
    rejection_reason TEXT,
    is_recurring BOOLEAN DEFAULT false,
    recurrence_pattern VARCHAR(100),
    parent_booking_id UUID,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    deleted_at TIMESTAMP,
    FOREIGN KEY (zona_id) REFERENCES zona_bronirovania(id),
    FOREIGN KEY (polzovatel_id) REFERENCES polzovatel_sberoffice(id),
    FOREIGN KEY (approved_by) REFERENCES polzovatel_sberoffice(id),
    FOREIGN KEY (parent_booking_id) REFERENCES bronirovanie_zony(id),
    CHECK (booking_date_from < booking_date_to)
);

COMMENT ON TABLE bronirovanie_zony IS 'Informaciya neobkhodimaya dlya bronirovaniya zony';
CREATE INDEX idx_bronirovanie_zony_zona_id ON bronirovanie_zony(zona_id);
CREATE INDEX idx_bronirovanie_zony_polzovatel_id ON bronirovanie_zony(polzovatel_id);
CREATE INDEX idx_bronirovanie_zony_dates ON bronirovanie_zony(booking_date_from, booking_date_to);
CREATE INDEX idx_bronirovanie_zony_status ON bronirovanie_zony(status);
CREATE INDEX idx_bronirovanie_zony_booking_number ON bronirovanie_zony(booking_number);

-- Svyaz: Bronirovanie zony - Uchastniki vstrechi (many-to-many)
CREATE TABLE bronirovanie_zony_uchastnik (
    bronirovanie_id UUID NOT NULL,
    sotrudnik_id UUID NOT NULL,
    is_organizer BOOLEAN DEFAULT false,
    attendance_status VARCHAR(50) DEFAULT 'PENDING' CHECK (attendance_status IN ('PENDING', 'ACCEPTED', 'DECLINED', 'TENTATIVE')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (bronirovanie_id, sotrudnik_id),
    FOREIGN KEY (bronirovanie_id) REFERENCES bronirovanie_zony(id) ON DELETE CASCADE,
    FOREIGN KEY (sotrudnik_id) REFERENCES master_sotrudnik(id)
);

COMMENT ON TABLE bronirovanie_zony_uchastnik IS 'Uchastniki vstrechi v ramkakh bronirovaniya zony';
CREATE INDEX idx_bronirovanie_uchastnik_bronirovanie ON bronirovanie_zony_uchastnik(bronirovanie_id);
CREATE INDEX idx_bronirovanie_uchastnik_sotrudnik ON bronirovanie_zony_uchastnik(sotrudnik_id);

-- Bronirovanie RM
CREATE TABLE bronirovanie_rm (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    rabochee_mesto_id UUID NOT NULL,
    polzovatel_id UUID NOT NULL,
    subekt_bronirovania_id UUID NOT NULL,
    osh_id UUID NOT NULL,
    status_zanyatia_id UUID NOT NULL,
    booking_number VARCHAR(100) UNIQUE,
    booking_date_from TIMESTAMP NOT NULL,
    booking_date_to TIMESTAMP NOT NULL,
    is_permanent BOOLEAN DEFAULT false,
    purpose TEXT,
    status VARCHAR(50) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'CANCELLED', 'COMPLETED', 'EXPIRED')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    deleted_at TIMESTAMP,
    FOREIGN KEY (rabochee_mesto_id) REFERENCES rabochee_mesto(id),
    FOREIGN KEY (polzovatel_id) REFERENCES polzovatel_sberoffice(id),
    FOREIGN KEY (subekt_bronirovania_id) REFERENCES subekt_bronirovania(id),
    FOREIGN KEY (osh_id) REFERENCES master_osh(id),
    FOREIGN KEY (status_zanyatia_id) REFERENCES dict_status_zanyatia(id),
    CHECK (booking_date_from < booking_date_to)
);

COMMENT ON TABLE bronirovanie_rm IS 'Informaciya, kotoraya neobkhodima dlya bronirovaniya RM';
CREATE INDEX idx_bronirovanie_rm_rm_id ON bronirovanie_rm(rabochee_mesto_id);
CREATE INDEX idx_bronirovanie_rm_polzovatel_id ON bronirovanie_rm(polzovatel_id);
CREATE INDEX idx_bronirovanie_rm_subekt_id ON bronirovanie_rm(subekt_bronirovania_id);
CREATE INDEX idx_bronirovanie_rm_dates ON bronirovanie_rm(booking_date_from, booking_date_to);
CREATE INDEX idx_bronirovanie_rm_status ON bronirovanie_rm(status);
CREATE INDEX idx_bronirovanie_rm_booking_number ON bronirovanie_rm(booking_number);

-- Svyaz: Rol polzovatelya - Polzovatel (many-to-many)
CREATE TABLE rol_polzovatelya_polzovatel (
    rol_id UUID NOT NULL,
    polzovatel_id UUID NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    assigned_by UUID,
    is_active BOOLEAN DEFAULT true,
    PRIMARY KEY (rol_id, polzovatel_id),
    FOREIGN KEY (rol_id) REFERENCES dict_rol_polzovatelya(id),
    FOREIGN KEY (polzovatel_id) REFERENCES polzovatel_sberoffice(id) ON DELETE CASCADE
);

COMMENT ON TABLE rol_polzovatelya_polzovatel IS 'Svyaz polzovateley s ikh rolyami';
CREATE INDEX idx_rol_polzovatel_rol ON rol_polzovatelya_polzovatel(rol_id);
CREATE INDEX idx_rol_polzovatel_polzovatel ON rol_polzovatelya_polzovatel(polzovatel_id);

-- =====================================================
-- DOPOLNITELNYE OGRANICHENIYA I FK
-- =====================================================

-- Dobavlenie FK dlya svyazi object_bronirovania_plan s object_bronirovania
ALTER TABLE master_object_bronirovania_plan 
ADD CONSTRAINT fk_object_plan_object 
FOREIGN KEY (object_id) REFERENCES object_bronirovania(id);
-- =====================================================
-- TRIGGERY DLYA AVTOMATICHESKOGO OBNOVLENIYA updated_at
-- =====================================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Primenenie triggerov k spravochnikam
CREATE TRIGGER update_dict_vid_rm_updated_at BEFORE UPDATE ON dict_vid_rm FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_dict_kategoria_rm_updated_at BEFORE UPDATE ON dict_kategoria_rm FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_dict_sostoyanie_rm_updated_at BEFORE UPDATE ON dict_sostoyanie_rm FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_dict_status_rm_updated_at BEFORE UPDATE ON dict_status_rm FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_dict_tip_zon_updated_at BEFORE UPDATE ON dict_tip_zon FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_dict_tip_oborudovania_updated_at BEFORE UPDATE ON dict_tip_oborudovania FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_dict_rol_polzovatelya_updated_at BEFORE UPDATE ON dict_rol_polzovatelya FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_dict_status_zanyatia_updated_at BEFORE UPDATE ON dict_status_zanyatia FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_dict_svyaz_gosb_updated_at BEFORE UPDATE ON dict_svyaz_gosb FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_dict_sostoyanie_updated_at BEFORE UPDATE ON dict_sostoyanie FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_dict_status_polzovania_updated_at BEFORE UPDATE ON dict_status_polzovania FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_dict_prednaznachenie_pomeshenia_updated_at BEFORE UPDATE ON dict_prednaznachenie_pomeshenia FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Primenenie triggerov k master-dannym
CREATE TRIGGER update_master_osh_updated_at BEFORE UPDATE ON master_osh FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_master_podrazdelenie_updated_at BEFORE UPDATE ON master_podrazdelenie FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_master_podrazdelenie_agile_updated_at BEFORE UPDATE ON master_podrazdelenie_agile FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_master_sotrudnik_updated_at BEFORE UPDATE ON master_sotrudnik FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_master_etazh_updated_at BEFORE UPDATE ON master_etazh FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_master_pomeshenie_updated_at BEFORE UPDATE ON master_pomeshenie FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_master_object_bronirovania_plan_updated_at BEFORE UPDATE ON master_object_bronirovania_plan FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Primenenie triggerov k tranzakcionnym tablicam
CREATE TRIGGER update_object_bronirovania_updated_at BEFORE UPDATE ON object_bronirovania FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_zona_bronirovania_updated_at BEFORE UPDATE ON zona_bronirovania FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_rabochee_mesto_updated_at BEFORE UPDATE ON rabochee_mesto FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_polzovatel_sberoffice_updated_at BEFORE UPDATE ON polzovatel_sberoffice FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_professionalny_polzovatel_updated_at BEFORE UPDATE ON professionalny_polzovatel FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_neprofessionalny_polzovatel_updated_at BEFORE UPDATE ON neprofessionalny_polzovatel FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_osnashenie_updated_at BEFORE UPDATE ON osnashenie FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_soglasuyushy_zony_updated_at BEFORE UPDATE ON soglasuyushy_zony FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_gruppa_rassylki_updated_at BEFORE UPDATE ON gruppa_rassylki FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_vip_dostup_updated_at BEFORE UPDATE ON vip_dostup FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_vip_dostup_rm_updated_at BEFORE UPDATE ON vip_dostup_rm FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_polnomochiya_object_updated_at BEFORE UPDATE ON polnomochiya_object FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_zakreplenie_podrazdelenie_updated_at BEFORE UPDATE ON zakreplenie_podrazdelenie FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_kategoria_rabochego_mesta_updated_at BEFORE UPDATE ON kategoria_rabochego_mesta FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_sostoyanie_rabochego_mesta_updated_at BEFORE UPDATE ON sostoyanie_rabochego_mesta FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_status_polzovania_rm_updated_at BEFORE UPDATE ON status_polzovania_rm FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_subekt_bronirovania_updated_at BEFORE UPDATE ON subekt_bronirovania FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_bronirovanie_zony_updated_at BEFORE UPDATE ON bronirovanie_zony FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_bronirovanie_rm_updated_at BEFORE UPDATE ON bronirovanie_rm FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
-- =====================================================
-- PREDSTAVLENIYA (VIEWS) DLYA UPROSCHENIYA ZAPROSOV
-- =====================================================

-- Predstavlenie: Polnaya informaciya o zonakh bronirovaniya
CREATE OR REPLACE VIEW v_zona_bronirovania_full AS
SELECT 
    ob.id,
    ob.name,
    ob.description,
    ob.is_active,
    p.room_name AS pomeshenie_name,
    p.room_number AS pomeshenie_number,
    e.floor_number,
    e.building_name,
    tz.name AS tip_zony,
    zb.capacity,
    zb.min_booking_hours,
    zb.max_booking_hours,
    zb.require_approval,
    ob.created_at,
    ob.updated_at
FROM object_bronirovania ob
JOIN zona_bronirovania zb ON ob.id = zb.id
JOIN master_pomeshenie p ON ob.pomeshenie_id = p.id
JOIN master_etazh e ON p.etazh_id = e.id
JOIN dict_tip_zon tz ON zb.tip_zon_id = tz.id
WHERE ob.deleted_at IS NULL;

COMMENT ON VIEW v_zona_bronirovania_full IS 'Polnaya informaciya o zonakh bronirovaniya s rasshifrovkoy spravochnikov';

-- Predstavlenie: Polnaya informaciya o rabochikh mestakh
CREATE OR REPLACE VIEW v_rabochee_mesto_full AS
SELECT 
    ob.id,
    ob.name,
    ob.description,
    ob.is_active,
    p.room_name AS pomeshenie_name,
    p.room_number AS pomeshenie_number,
    e.floor_number,
    e.building_name,
    vr.name AS vid_rm,
    rm.inventory_number,
    rm.workplace_number,
    rm.is_bookable,
    ob.created_at,
    ob.updated_at
FROM object_bronirovania ob
JOIN rabochee_mesto rm ON ob.id = rm.id
JOIN master_pomeshenie p ON ob.pomeshenie_id = p.id
JOIN master_etazh e ON p.etazh_id = e.id
JOIN dict_vid_rm vr ON rm.vid_rm_id = vr.id
WHERE ob.deleted_at IS NULL;

COMMENT ON VIEW v_rabochee_mesto_full IS 'Polnaya informaciya o rabochikh mestakh s rasshifrovkoy spravochnikov';

-- Predstavlenie: Aktivnye bronirovaniya zon
CREATE OR REPLACE VIEW v_bronirovanie_zony_active AS
SELECT 
    bz.id,
    bz.booking_number,
    bz.booking_date_from,
    bz.booking_date_to,
    bz.purpose,
    bz.participants_count,
    bz.status,
    vz.name AS zona_name,
    vz.pomeshenie_name,
    vz.floor_number,
    vz.building_name,
    s.full_name AS creator_name,
    s.email AS creator_email,
    bz.created_at
FROM bronirovanie_zony bz
JOIN v_zona_bronirovania_full vz ON bz.zona_id = vz.id
JOIN polzovatel_sberoffice ps ON bz.polzovatel_id = ps.id
JOIN master_sotrudnik s ON ps.sotrudnik_id = s.id
WHERE bz.deleted_at IS NULL
  AND bz.status IN ('PENDING', 'APPROVED')
  AND bz.booking_date_to >= CURRENT_TIMESTAMP;

COMMENT ON VIEW v_bronirovanie_zony_active IS 'Aktivnye bronirovaniya zon';

-- Predstavlenie: Aktivnye bronirovaniya RM
CREATE OR REPLACE VIEW v_bronirovanie_rm_active AS
SELECT 
    br.id,
    br.booking_number,
    br.booking_date_from,
    br.booking_date_to,
    br.is_permanent,
    br.purpose,
    br.status,
    vrm.name AS rm_name,
    vrm.pomeshenie_name,
    vrm.floor_number,
    vrm.building_name,
    s.full_name AS creator_name,
    s.email AS creator_email,
    sz.name AS status_zanyatia,
    br.created_at
FROM bronirovanie_rm br
JOIN v_rabochee_mesto_full vrm ON br.rabochee_mesto_id = vrm.id
JOIN polzovatel_sberoffice ps ON br.polzovatel_id = ps.id
JOIN master_sotrudnik s ON ps.sotrudnik_id = s.id
JOIN dict_status_zanyatia sz ON br.status_zanyatia_id = sz.id
WHERE br.deleted_at IS NULL
  AND br.status = 'ACTIVE'
  AND (br.is_permanent = true OR br.booking_date_to >= CURRENT_TIMESTAMP);

COMMENT ON VIEW v_bronirovanie_rm_active IS 'Aktivnye bronirovaniya rabochikh mest';
-- =====================================================
-- FUNKCII DLYA PROVERKI DOSTUPNOSTI
-- =====================================================

-- Funkciya proverki dostupnosti zony dlya bronirovaniya
CREATE OR REPLACE FUNCTION check_zona_availability(
    p_zona_id UUID,
    p_date_from TIMESTAMP,
    p_date_to TIMESTAMP,
    p_exclude_booking_id UUID DEFAULT NULL
)
RETURNS BOOLEAN AS $$
DECLARE
    v_conflict_count INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO v_conflict_count
    FROM bronirovanie_zony
    WHERE zona_id = p_zona_id
      AND status IN ('PENDING', 'APPROVED')
      AND deleted_at IS NULL
      AND (p_exclude_booking_id IS NULL OR id != p_exclude_booking_id)
      AND (
          (booking_date_from <= p_date_from AND booking_date_to > p_date_from)
          OR (booking_date_from < p_date_to AND booking_date_to >= p_date_to)
          OR (booking_date_from >= p_date_from AND booking_date_to <= p_date_to)
      );
    
    RETURN v_conflict_count = 0;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION check_zona_availability IS 'Proverka dostupnosti zony dlya bronirovaniya v ukazanny period';

-- Funkciya proverki dostupnosti RM dlya bronirovaniya
CREATE OR REPLACE FUNCTION check_rm_availability(
    p_rm_id UUID,
    p_date_from TIMESTAMP,
    p_date_to TIMESTAMP,
    p_exclude_booking_id UUID DEFAULT NULL
)
RETURNS BOOLEAN AS $$
DECLARE
    v_conflict_count INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO v_conflict_count
    FROM bronirovanie_rm
    WHERE rabochee_mesto_id = p_rm_id
      AND status = 'ACTIVE'
      AND deleted_at IS NULL
      AND (p_exclude_booking_id IS NULL OR id != p_exclude_booking_id)
      AND (
          is_permanent = true
          OR (
              (booking_date_from <= p_date_from AND booking_date_to > p_date_from)
              OR (booking_date_from < p_date_to AND booking_date_to >= p_date_to)
              OR (booking_date_from >= p_date_from AND booking_date_to <= p_date_to)
          )
      );
    
    RETURN v_conflict_count = 0;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION check_rm_availability IS 'Proverka dostupnosti rabochego mesta dlya bronirovaniya v ukazanny period';

-- =====================================================
-- INDEKSY DLYA OPTIMIZACII PROIZVODITELNOSTI
-- =====================================================

-- Dopolnitelnye indeksy dlya bystrogo poiska
CREATE INDEX idx_object_bronirovania_active ON object_bronirovania(is_active) WHERE deleted_at IS NULL;
CREATE INDEX idx_zona_bronirovania_bookable ON zona_bronirovania(id) WHERE deleted_at IS NULL;
CREATE INDEX idx_rabochee_mesto_bookable ON rabochee_mesto(is_bookable) WHERE is_bookable = true AND deleted_at IS NULL;
CREATE INDEX idx_polzovatel_active ON polzovatel_sberoffice(is_active) WHERE is_active = true AND deleted_at IS NULL;
CREATE INDEX idx_bronirovanie_zony_active_dates ON bronirovanie_zony(zona_id, booking_date_from, booking_date_to) WHERE status IN ('PENDING', 'APPROVED') AND deleted_at IS NULL;
CREATE INDEX idx_bronirovanie_rm_active_dates ON bronirovanie_rm(rabochee_mesto_id, booking_date_from, booking_date_to) WHERE status = 'ACTIVE' AND deleted_at IS NULL;
-- =====================================================
-- DOPOLNITELNYE TABLICY DLA POLNOGO FUNKCIONALA
-- SberOffice - Rasshirenie modeli
-- =====================================================

-- =====================================================
-- SERVISY I USLUGI
-- =====================================================

-- Spravochnik: Tipy servisov
CREATE TABLE dict_tip_servisa (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(500) NOT NULL,
    description TEXT,
    icon_url VARCHAR(1000),
    category VARCHAR(100), -- FOOD, SPORT, MEDICAL, WELLNESS, OTHER
    requires_booking BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    sort_order INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

COMMENT ON TABLE dict_tip_servisa IS 'Tipy servisov: Restoran, Sportzal, Medkabinet, Psikholog i t.d.';

-- Servisy v zdaniyakh
CREATE TABLE servis (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tip_servisa_id UUID NOT NULL,
    pomeshenie_id UUID,
    etazh_id UUID,
    name VARCHAR(500) NOT NULL,
    description TEXT,
    capacity INTEGER,
    working_hours_from TIME,
    working_hours_to TIME,
    working_days VARCHAR(50), -- MON-FRI, MON-SUN, etc
    contact_phone VARCHAR(50),
    contact_email VARCHAR(255),
    booking_duration_minutes INTEGER, -- Dlitelnost broni po umolchaniyu
    min_booking_minutes INTEGER,
    max_booking_minutes INTEGER,
    advance_booking_days INTEGER DEFAULT 30, -- Za skolko dney mozhno zabronirovat
    cancellation_deadline_hours INTEGER, -- Za skolko chasov mozhno otmenit
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (tip_servisa_id) REFERENCES dict_tip_servisa(id),
    FOREIGN KEY (pomeshenie_id) REFERENCES master_pomeshenie(id),
    FOREIGN KEY (etazh_id) REFERENCES master_etazh(id)
);

COMMENT ON TABLE servis IS 'Servisy i uslugi v zdaniyakh (restorany, sportzaly, medkabinety i t.d.)';
CREATE INDEX idx_servis_tip ON servis(tip_servisa_id);
CREATE INDEX idx_servis_pomeshenie ON servis(pomeshenie_id);
CREATE INDEX idx_servis_etazh ON servis(etazh_id);

-- Bronirovanie uslug
CREATE TABLE bronirovanie_servisa (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    servis_id UUID NOT NULL,
    polzovatel_id UUID NOT NULL,
    sotrudnik_id UUID NOT NULL,
    booking_number VARCHAR(100) UNIQUE,
    booking_date_from TIMESTAMP NOT NULL,
    booking_date_to TIMESTAMP NOT NULL,
    purpose TEXT,
    participants_count INTEGER DEFAULT 1,
    status VARCHAR(50) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'COMPLETED', 'CANCELLED', 'NO_SHOW')),
    cancellation_reason TEXT,
    cancelled_at TIMESTAMP,
    cancelled_by UUID,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    deleted_at TIMESTAMP,
    FOREIGN KEY (servis_id) REFERENCES servis(id),
    FOREIGN KEY (polzovatel_id) REFERENCES polzovatel_sberoffice(id),
    FOREIGN KEY (sotrudnik_id) REFERENCES master_sotrudnik(id),
    FOREIGN KEY (cancelled_by) REFERENCES polzovatel_sberoffice(id),
    CHECK (booking_date_from < booking_date_to)
);

COMMENT ON TABLE bronirovanie_servisa IS 'Bronirovaniya uslug (sportzal, psikholog, restoran i t.d.)';
CREATE INDEX idx_bronirovanie_servisa_servis ON bronirovanie_servisa(servis_id);
CREATE INDEX idx_bronirovanie_servisa_polzovatel ON bronirovanie_servisa(polzovatel_id);
CREATE INDEX idx_bronirovanie_servisa_dates ON bronirovanie_servisa(booking_date_from, booking_date_to);
CREATE INDEX idx_bronirovanie_servisa_status ON bronirovanie_servisa(status);

-- =====================================================
-- KOMPLEKSNYE SERVISY (ZAYAVKI)
-- =====================================================

-- Spravochnik: Tipy zayavok
CREATE TABLE dict_tip_zayavki (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(500) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    sort_order INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

COMMENT ON TABLE dict_tip_zayavki IS 'Tipy zayavok: Novy sotrudnik, Peremeschenie, Perevod, Peremeschenie podrazdeleniya';

INSERT INTO dict_tip_zayavki (code, name, sort_order) VALUES
    ('NEW_EMPLOYEE', 'Novy sotrudnik', 1),
    ('RELOCATION', 'Peremeschenie', 2),
    ('TRANSFER', 'Perevod', 3),
    ('DEPARTMENT_RELOCATION', 'Peremeschenie podrazdeleniya', 4);

-- Zayavki na kompleksnye uslugi
CREATE TABLE zayavka_kompleksnaya (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tip_zayavki_id UUID NOT NULL,
    request_number VARCHAR(100) UNIQUE,
    
    -- Initiator zayavki
    initiator_polzovatel_id UUID NOT NULL,
    initiator_sotrudnik_id UUID NOT NULL,
    
    -- Dlya kogo zayavka
    target_sotrudnik_id UUID, -- Dlya NEW_EMPLOYEE, RELOCATION, TRANSFER
    target_podrazdelenie_id UUID, -- Dlya DEPARTMENT_RELOCATION
    target_employees_count INTEGER, -- Dlya DEPARTMENT_RELOCATION
    
    -- Dannye peremescheniya
    from_rabochee_mesto_id UUID,
    from_pomeshenie_id UUID,
    from_etazh_id UUID,
    from_podrazdelenie_id UUID,
    
    to_rabochee_mesto_id UUID,
    to_pomeshenie_id UUID,
    to_etazh_id UUID,
    to_podrazdelenie_id UUID,
    
    -- Daty
    requested_date DATE, -- Zhelaemaya data ispolneniya
    planned_date DATE, -- Planiruemaya data ispolneniya
    actual_date DATE, -- Fakticheskaya data ispolneniya
    
    -- Status
    status VARCHAR(50) NOT NULL DEFAULT 'NEW' CHECK (status IN (
        'NEW', 'IN_REVIEW', 'APPROVED', 'IN_PROGRESS', 
        'COMPLETED', 'REJECTED', 'CANCELLED'
    )),
    priority VARCHAR(50) DEFAULT 'NORMAL' CHECK (priority IN ('LOW', 'NORMAL', 'HIGH', 'URGENT')),
    
    -- Soglasovaniya
    approved_by UUID,
    approved_at TIMESTAMP,
    rejection_reason TEXT,
    rejected_by UUID,
    rejected_at TIMESTAMP,
    
    -- Ispolnenie
    assigned_to UUID, -- Otvetstvenny za ispolnenie
    completed_by UUID,
    completed_at TIMESTAMP,
    
    -- Dopolnitelnaya informatsiya
    description TEXT,
    special_requirements TEXT,
    notes TEXT,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    deleted_at TIMESTAMP,
    
    FOREIGN KEY (tip_zayavki_id) REFERENCES dict_tip_zayavki(id),
    FOREIGN KEY (initiator_polzovatel_id) REFERENCES polzovatel_sberoffice(id),
    FOREIGN KEY (initiator_sotrudnik_id) REFERENCES master_sotrudnik(id),
    FOREIGN KEY (target_sotrudnik_id) REFERENCES master_sotrudnik(id),
    FOREIGN KEY (target_podrazdelenie_id) REFERENCES master_podrazdelenie(id),
    FOREIGN KEY (from_rabochee_mesto_id) REFERENCES rabochee_mesto(id),
    FOREIGN KEY (from_pomeshenie_id) REFERENCES master_pomeshenie(id),
    FOREIGN KEY (from_etazh_id) REFERENCES master_etazh(id),
    FOREIGN KEY (from_podrazdelenie_id) REFERENCES master_podrazdelenie(id),
    FOREIGN KEY (to_rabochee_mesto_id) REFERENCES rabochee_mesto(id),
    FOREIGN KEY (to_pomeshenie_id) REFERENCES master_pomeshenie(id),
    FOREIGN KEY (to_etazh_id) REFERENCES master_etazh(id),
    FOREIGN KEY (to_podrazdelenie_id) REFERENCES master_podrazdelenie(id),
    FOREIGN KEY (approved_by) REFERENCES polzovatel_sberoffice(id),
    FOREIGN KEY (rejected_by) REFERENCES polzovatel_sberoffice(id),
    FOREIGN KEY (assigned_to) REFERENCES polzovatel_sberoffice(id),
    FOREIGN KEY (completed_by) REFERENCES polzovatel_sberoffice(id)
);

COMMENT ON TABLE zayavka_kompleksnaya IS 'Zayavki na kompleksnye uslugi: Novy sotrudnik, Peremeschenie, Perevod, Peremeschenie podrazdeleniya';
CREATE INDEX idx_zayavka_tip ON zayavka_kompleksnaya(tip_zayavki_id);
CREATE INDEX idx_zayavka_initiator ON zayavka_kompleksnaya(initiator_polzovatel_id);
CREATE INDEX idx_zayavka_target_sotrudnik ON zayavka_kompleksnaya(target_sotrudnik_id);
CREATE INDEX idx_zayavka_status ON zayavka_kompleksnaya(status);
CREATE INDEX idx_zayavka_dates ON zayavka_kompleksnaya(requested_date, planned_date, actual_date);

-- Istoriya statusov zayavok
CREATE TABLE zayavka_status_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    zayavka_id UUID NOT NULL,
    old_status VARCHAR(50),
    new_status VARCHAR(50) NOT NULL,
    changed_by UUID NOT NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    comment TEXT,
    FOREIGN KEY (zayavka_id) REFERENCES zayavka_kompleksnaya(id) ON DELETE CASCADE,
    FOREIGN KEY (changed_by) REFERENCES polzovatel_sberoffice(id)
);

COMMENT ON TABLE zayavka_status_history IS 'Istoriya izmeneniy statusov zayavok';
CREATE INDEX idx_zayavka_history_zayavka ON zayavka_status_history(zayavka_id);

-- =====================================================
-- ISTORIYA PEREMESCHENIY RM
-- =====================================================

CREATE TABLE rm_peremeschenie_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    rabochee_mesto_id UUID NOT NULL,
    sotrudnik_id UUID,
    
    -- Otkuda
    from_pomeshenie_id UUID,
    from_etazh_id UUID,
    from_podrazdelenie_id UUID,
    from_coordinates_x NUMERIC(10,2),
    from_coordinates_y NUMERIC(10,2),
    
    -- Kuda
    to_pomeshenie_id UUID,
    to_etazh_id UUID,
    to_podrazdelenie_id UUID,
    to_coordinates_x NUMERIC(10,2),
    to_coordinates_y NUMERIC(10,2),
    
    -- Sviaz s zayavkoi
    zayavka_id UUID,
    
    -- Daty
    moved_at TIMESTAMP NOT NULL,
    
    -- Kto vypolnil
    performed_by UUID,
    
    -- Dopolnitelnaya informatsiya
    reason VARCHAR(100), -- NEW_EMPLOYEE, RELOCATION, TRANSFER, DEPARTMENT_MOVE
    notes TEXT,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (rabochee_mesto_id) REFERENCES rabochee_mesto(id),
    FOREIGN KEY (sotrudnik_id) REFERENCES master_sotrudnik(id),
    FOREIGN KEY (from_pomeshenie_id) REFERENCES master_pomeshenie(id),
    FOREIGN KEY (from_etazh_id) REFERENCES master_etazh(id),
    FOREIGN KEY (from_podrazdelenie_id) REFERENCES master_podrazdelenie(id),
    FOREIGN KEY (to_pomeshenie_id) REFERENCES master_pomeshenie(id),
    FOREIGN KEY (to_etazh_id) REFERENCES master_etazh(id),
    FOREIGN KEY (to_podrazdelenie_id) REFERENCES master_podrazdelenie(id),
    FOREIGN KEY (zayavka_id) REFERENCES zayavka_kompleksnaya(id),
    FOREIGN KEY (performed_by) REFERENCES polzovatel_sberoffice(id)
);

COMMENT ON TABLE rm_peremeschenie_history IS 'Istoriya peremescheniy rabochikh mest';
CREATE INDEX idx_rm_history_rm ON rm_peremeschenie_history(rabochee_mesto_id);
CREATE INDEX idx_rm_history_sotrudnik ON rm_peremeschenie_history(sotrudnik_id);
CREATE INDEX idx_rm_history_zayavka ON rm_peremeschenie_history(zayavka_id);
CREATE INDEX idx_rm_history_moved_at ON rm_peremeschenie_history(moved_at);

-- =====================================================
-- VIDEOANALITIKA (KONTROL ZANYATOSTI)
-- =====================================================

CREATE TABLE videoanalitika_snapshot (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    rabochee_mesto_id UUID NOT NULL,
    zona_id UUID,
    snapshot_time TIMESTAMP NOT NULL,
    is_occupied BOOLEAN NOT NULL,
    confidence_level NUMERIC(5,2), -- Uroven uverennosti 0-100%
    detected_persons_count INTEGER,
    camera_id VARCHAR(100),
    image_url VARCHAR(1000),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (rabochee_mesto_id) REFERENCES rabochee_mesto(id),
    FOREIGN KEY (zona_id) REFERENCES zona_bronirovania(id)
);

COMMENT ON TABLE videoanalitika_snapshot IS 'Snimki videoanalitiki dlya kontrolya zanyatosti RM i zon';
CREATE INDEX idx_video_rm ON videoanalitika_snapshot(rabochee_mesto_id);
CREATE INDEX idx_video_zona ON videoanalitika_snapshot(zona_id);
CREATE INDEX idx_video_time ON videoanalitika_snapshot(snapshot_time);

-- Agregirovannye dannye po zanyatosti
CREATE TABLE rm_zanyatost_statistics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    rabochee_mesto_id UUID NOT NULL,
    date DATE NOT NULL,
    total_minutes INTEGER, -- Obschee vremya nablyudeniya
    occupied_minutes INTEGER, -- Vremya zanyatosti
    occupancy_rate NUMERIC(5,2), -- Protsent zanyatosti
    peak_occupancy_time TIME, -- Vremya maksimalnoy zanyatosti
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (rabochee_mesto_id) REFERENCES rabochee_mesto(id),
    UNIQUE (rabochee_mesto_id, date)
);

COMMENT ON TABLE rm_zanyatost_statistics IS 'Agregirovannaya statistika zanyatosti RM po dnyam';
CREATE INDEX idx_rm_stat_rm ON rm_zanyatost_statistics(rabochee_mesto_id);
CREATE INDEX idx_rm_stat_date ON rm_zanyatost_statistics(date);

-- =====================================================
-- OTCHETNOST I ANALITIKA
-- =====================================================

-- Shablony otchetov
CREATE TABLE otchet_template (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(500) NOT NULL,
    description TEXT,
    report_type VARCHAR(100), -- WORKPLACE_USAGE, BOOKING_STATS, OCCUPANCY, SERVICES
    sql_query TEXT,
    parameters_schema JSONB, -- Parametry otcheta v JSON
    output_format VARCHAR(50) DEFAULT 'XLSX', -- XLSX, PDF, CSV
    is_scheduled BOOLEAN DEFAULT false,
    schedule_cron VARCHAR(100), -- Cron dlya raspisaniya
    is_active BOOLEAN DEFAULT true,
    created_by UUID,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES polzovatel_sberoffice(id)
);

COMMENT ON TABLE otchet_template IS 'Shablony otchetov dlya analitiki';

-- Sgenerirovannye otchety
CREATE TABLE otchet_generated (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    template_id UUID NOT NULL,
    report_number VARCHAR(100) UNIQUE,
    parameters JSONB, -- Parametry s kotorymi byl sgenerirovana otchet
    generated_by UUID NOT NULL,
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    period_from DATE,
    period_to DATE,
    file_url VARCHAR(1000),
    file_size_bytes BIGINT,
    status VARCHAR(50) DEFAULT 'PROCESSING' CHECK (status IN ('PROCESSING', 'COMPLETED', 'ERROR')),
    error_message TEXT,
    FOREIGN KEY (template_id) REFERENCES otchet_template(id),
    FOREIGN KEY (generated_by) REFERENCES polzovatel_sberoffice(id)
);

COMMENT ON TABLE otchet_generated IS 'Sgenerirovannye otchety';
CREATE INDEX idx_otchet_template ON otchet_generated(template_id);
CREATE INDEX idx_otchet_generated_by ON otchet_generated(generated_by);
CREATE INDEX idx_otchet_period ON otchet_generated(period_from, period_to);

-- =====================================================
-- TRIGGERY
-- =====================================================

CREATE TRIGGER update_dict_tip_servisa_updated_at BEFORE UPDATE ON dict_tip_servisa FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_servis_updated_at BEFORE UPDATE ON servis FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_bronirovanie_servisa_updated_at BEFORE UPDATE ON bronirovanie_servisa FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_dict_tip_zayavki_updated_at BEFORE UPDATE ON dict_tip_zayavki FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_zayavka_kompleksnaya_updated_at BEFORE UPDATE ON zayavka_kompleksnaya FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_otchet_template_updated_at BEFORE UPDATE ON otchet_template FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
-- =====================================================
-- DOPOLNITELNYE PREDSTAVLENIYA I FUNKCII
-- =====================================================

-- Predstavlenie: Polnaya informatsiya o servisakh
CREATE OR REPLACE VIEW v_servis_full AS
SELECT 
    s.id,
    s.name,
    s.description,
    ts.name AS tip_servisa,
    ts.category AS category,
    p.room_name AS pomeshenie_name,
    e.floor_number,
    e.building_name,
    s.capacity,
    s.working_hours_from,
    s.working_hours_to,
    s.working_days,
    s.contact_phone,
    s.contact_email,
    s.is_active,
    s.created_at
FROM servis s
JOIN dict_tip_servisa ts ON s.tip_servisa_id = ts.id
LEFT JOIN master_pomeshenie p ON s.pomeshenie_id = p.id
LEFT JOIN master_etazh e ON s.etazh_id = e.id
WHERE s.deleted_at IS NULL;

COMMENT ON VIEW v_servis_full IS 'Polnaya informatsiya o servisakh s rasshifrovkoy spravochnikov';

-- Predstavlenie: Aktivnye bronirovaniya servisov
CREATE OR REPLACE VIEW v_bronirovanie_servisa_active AS
SELECT 
    bs.id,
    bs.booking_number,
    bs.booking_date_from,
    bs.booking_date_to,
    bs.purpose,
    bs.status,
    vs.name AS servis_name,
    vs.tip_servisa,
    vs.building_name,
    vs.floor_number,
    s.full_name AS sotrudnik_name,
    s.email AS sotrudnik_email,
    bs.created_at
FROM bronirovanie_servisa bs
JOIN v_servis_full vs ON bs.servis_id = vs.id
JOIN master_sotrudnik s ON bs.sotrudnik_id = s.id
WHERE bs.deleted_at IS NULL
  AND bs.status = 'ACTIVE'
  AND bs.booking_date_to >= CURRENT_TIMESTAMP;

COMMENT ON VIEW v_bronirovanie_servisa_active IS 'Aktivnye bronirovaniya servisov';

-- Predstavlenie: Statistika ispolzovaniya RM
CREATE OR REPLACE VIEW v_rm_usage_statistics AS
SELECT 
    rm.id AS rabochee_mesto_id,
    ob.name AS rm_name,
    p.room_name AS pomeshenie_name,
    e.floor_number,
    e.building_name,
    COUNT(DISTINCT br.id) AS total_bookings,
    COUNT(DISTINCT CASE WHEN br.status = 'ACTIVE' AND br.booking_date_to >= CURRENT_TIMESTAMP THEN br.id END) AS active_bookings,
    AVG(rzs.occupancy_rate) AS avg_occupancy_rate,
    MAX(br.booking_date_to) AS last_booking_date
FROM rabochee_mesto rm
JOIN object_bronirovania ob ON rm.id = ob.id
JOIN master_pomeshenie p ON ob.pomeshenie_id = p.id
JOIN master_etazh e ON p.etazh_id = e.id
LEFT JOIN bronirovanie_rm br ON rm.id = br.rabochee_mesto_id AND br.deleted_at IS NULL
LEFT JOIN rm_zanyatost_statistics rzs ON rm.id = rzs.rabochee_mesto_id
WHERE ob.deleted_at IS NULL
GROUP BY rm.id, ob.name, p.room_name, e.floor_number, e.building_name;

COMMENT ON VIEW v_rm_usage_statistics IS 'Statistika ispolzovaniya rabochikh mest';

-- Predstavlenie: Aktivnye zayavki
CREATE OR REPLACE VIEW v_zayavka_active AS
SELECT 
    z.id,
    z.request_number,
    tz.name AS tip_zayavki,
    ist.full_name AS initiator_name,
    tst.full_name AS target_sotrudnik_name,
    tp.name AS target_podrazdelenie_name,
    z.requested_date,
    z.planned_date,
    z.status,
    z.priority,
    z.description,
    z.created_at
FROM zayavka_kompleksnaya z
JOIN dict_tip_zayavki tz ON z.tip_zayavki_id = tz.id
JOIN master_sotrudnik ist ON z.initiator_sotrudnik_id = ist.id
LEFT JOIN master_sotrudnik tst ON z.target_sotrudnik_id = tst.id
LEFT JOIN master_podrazdelenie tp ON z.target_podrazdelenie_id = tp.id
WHERE z.deleted_at IS NULL
  AND z.status IN ('NEW', 'IN_REVIEW', 'APPROVED', 'IN_PROGRESS');

COMMENT ON VIEW v_zayavka_active IS 'Aktivnye zayavki na kompleksnye uslugi';

-- Predstavlenie: Dashboard analitiki
CREATE OR REPLACE VIEW v_dashboard_analytics AS
SELECT 
    (SELECT COUNT(*) FROM rabochee_mesto rm 
     JOIN object_bronirovania ob ON rm.id = ob.id 
     WHERE ob.is_active = true AND ob.deleted_at IS NULL) AS total_workplaces,
    
    (SELECT COUNT(*) FROM bronirovanie_rm 
     WHERE status = 'ACTIVE' AND deleted_at IS NULL 
     AND (is_permanent = true OR booking_date_to >= CURRENT_TIMESTAMP)) AS occupied_workplaces,
    
    (SELECT COUNT(*) FROM zona_bronirovania zb 
     JOIN object_bronirovania ob ON zb.id = ob.id 
     WHERE ob.is_active = true AND ob.deleted_at IS NULL) AS total_zones,
    
    (SELECT COUNT(DISTINCT zona_id) FROM bronirovanie_zony 
     WHERE status IN ('PENDING', 'APPROVED') AND deleted_at IS NULL 
     AND booking_date_to >= CURRENT_TIMESTAMP) AS occupied_zones,
    
    (SELECT COUNT(*) FROM bronirovanie_zony 
     WHERE deleted_at IS NULL 
     AND booking_date_from >= CURRENT_DATE 
     AND booking_date_from < CURRENT_DATE + INTERVAL '1 day') AS today_zone_bookings,
    
    (SELECT COUNT(*) FROM bronirovanie_rm 
     WHERE deleted_at IS NULL 
     AND booking_date_from >= CURRENT_DATE 
     AND booking_date_from < CURRENT_DATE + INTERVAL '1 day') AS today_rm_bookings,
    
    (SELECT COUNT(*) FROM bronirovanie_servisa 
     WHERE status = 'ACTIVE' AND deleted_at IS NULL 
     AND booking_date_to >= CURRENT_TIMESTAMP) AS active_service_bookings,
    
    (SELECT COUNT(*) FROM zayavka_kompleksnaya 
     WHERE status IN ('NEW', 'IN_REVIEW', 'APPROVED', 'IN_PROGRESS') 
     AND deleted_at IS NULL) AS active_requests,
    
    (SELECT AVG(occupancy_rate) FROM rm_zanyatost_statistics 
     WHERE date >= CURRENT_DATE - INTERVAL '7 days') AS avg_occupancy_last_7days;

COMMENT ON VIEW v_dashboard_analytics IS 'Dashboard s klyuchevymi metrikami sistemy';

-- =====================================================
-- FUNKCII PROVERKI DOSTUPNOSTI SERVISOV
-- =====================================================

CREATE OR REPLACE FUNCTION check_servis_availability(
    p_servis_id UUID,
    p_date_from TIMESTAMP,
    p_date_to TIMESTAMP,
    p_exclude_booking_id UUID DEFAULT NULL
)
RETURNS BOOLEAN AS $$
DECLARE
    v_conflict_count INTEGER;
    v_capacity INTEGER;
    v_concurrent_bookings INTEGER;
BEGIN
    -- Poluchit vmestimost servisa
    SELECT capacity INTO v_capacity
    FROM servis
    WHERE id = p_servis_id AND deleted_at IS NULL;
    
    -- Esli net ogranicheniya po vmestimosti
    IF v_capacity IS NULL THEN
        RETURN TRUE;
    END IF;
    
    -- Proverit kolichestvo odnovremennykh bronirovaniy
    SELECT COUNT(*)
    INTO v_concurrent_bookings
    FROM bronirovanie_servisa
    WHERE servis_id = p_servis_id
      AND status = 'ACTIVE'
      AND deleted_at IS NULL
      AND (p_exclude_booking_id IS NULL OR id != p_exclude_booking_id)
      AND (
          (booking_date_from <= p_date_from AND booking_date_to > p_date_from)
          OR (booking_date_from < p_date_to AND booking_date_to >= p_date_to)
          OR (booking_date_from >= p_date_from AND booking_date_to <= p_date_to)
      );
    
    RETURN v_concurrent_bookings < v_capacity;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION check_servis_availability IS 'Proverka dostupnosti servisa s uchetom vmestimosti';

-- Funkciya rascheta zanyatosti RM za period
CREATE OR REPLACE FUNCTION calculate_rm_occupancy(
    p_rabochee_mesto_id UUID,
    p_date_from DATE,
    p_date_to DATE
)
RETURNS TABLE (
    date DATE,
    occupancy_rate NUMERIC,
    occupied_minutes INTEGER,
    total_minutes INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        rzs.date,
        rzs.occupancy_rate,
        rzs.occupied_minutes,
        rzs.total_minutes
    FROM rm_zanyatost_statistics rzs
    WHERE rzs.rabochee_mesto_id = p_rabochee_mesto_id
      AND rzs.date >= p_date_from
      AND rzs.date <= p_date_to
    ORDER BY rzs.date;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION calculate_rm_occupancy IS 'Raschyot zanyatosti RM za ukazanny period';

-- Funkciya polucheniya dostupnykh servisov
CREATE OR REPLACE FUNCTION get_available_services(
    p_date_from TIMESTAMP,
    p_date_to TIMESTAMP,
    p_category VARCHAR DEFAULT NULL,
    p_etazh_id UUID DEFAULT NULL
)
RETURNS TABLE (
    servis_id UUID,
    servis_name VARCHAR,
    tip_servisa VARCHAR,
    category VARCHAR,
    building_name VARCHAR,
    floor_number INTEGER,
    available_slots INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        s.id AS servis_id,
        s.name AS servis_name,
        ts.name AS tip_servisa,
        ts.category,
        e.building_name,
        e.floor_number,
        CASE 
            WHEN s.capacity IS NULL THEN 999
            ELSE s.capacity - COUNT(bs.id)
        END AS available_slots
    FROM servis s
    JOIN dict_tip_servisa ts ON s.tip_servisa_id = ts.id
    LEFT JOIN master_etazh e ON s.etazh_id = e.id
    LEFT JOIN bronirovanie_servisa bs ON s.id = bs.servis_id
        AND bs.status = 'ACTIVE'
        AND bs.deleted_at IS NULL
        AND (
            (bs.booking_date_from <= p_date_from AND bs.booking_date_to > p_date_from)
            OR (bs.booking_date_from < p_date_to AND bs.booking_date_to >= p_date_to)
            OR (bs.booking_date_from >= p_date_from AND bs.booking_date_to <= p_date_to)
        )
    WHERE s.is_active = true
      AND s.deleted_at IS NULL
      AND (p_category IS NULL OR ts.category = p_category)
      AND (p_etazh_id IS NULL OR s.etazh_id = p_etazh_id)
    GROUP BY s.id, s.name, s.capacity, ts.name, ts.category, e.building_name, e.floor_number
    HAVING (s.capacity IS NULL OR COUNT(bs.id) < s.capacity)
    ORDER BY s.name;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION get_available_services IS 'Poluchenie spiska dostupnykh servisov na ukazannoe vremya';

-- =====================================================
-- INDEKSY DLYA OPTIMIZACII
-- =====================================================

CREATE INDEX idx_bronirovanie_servisa_active_dates 
ON bronirovanie_servisa(servis_id, booking_date_from, booking_date_to) 
WHERE status = 'ACTIVE' AND deleted_at IS NULL;

CREATE INDEX idx_zayavka_active 
ON zayavka_kompleksnaya(status, created_at) 
WHERE status IN ('NEW', 'IN_REVIEW', 'APPROVED', 'IN_PROGRESS') AND deleted_at IS NULL;

CREATE INDEX idx_rm_history_recent 
ON rm_peremeschenie_history(moved_at DESC) 
WHERE moved_at >= CURRENT_DATE - INTERVAL '1 year';

CREATE INDEX idx_video_recent 
ON videoanalitika_snapshot(snapshot_time DESC, rabochee_mesto_id) 
WHERE snapshot_time >= CURRENT_TIMESTAMP - INTERVAL '30 days';

-- =====================================================
-- KONEC DOPOLNITELNOGO SKRIPTA
-- =====================================================
