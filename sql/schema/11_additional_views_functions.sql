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
