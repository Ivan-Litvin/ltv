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
