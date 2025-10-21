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
