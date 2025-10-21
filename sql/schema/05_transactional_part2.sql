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
