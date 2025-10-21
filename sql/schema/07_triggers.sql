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
