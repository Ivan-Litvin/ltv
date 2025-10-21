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
