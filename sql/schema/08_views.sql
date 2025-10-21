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
