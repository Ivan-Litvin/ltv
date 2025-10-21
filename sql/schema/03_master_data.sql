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
