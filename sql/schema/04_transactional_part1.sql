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
