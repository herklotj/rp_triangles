connection: "av2"

# include all the views
include: "*.view"

datagroup: claims_development_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1000 hour"
}

persist_with: claims_development_datagroup

explore: claims_development {}
explore: expoclm_quarters {}
explore: ice_claims_development {persist_for: "744 hours"} # 31 days
explore: ice_claims_dev_excl_luton {}
explore: ad_hod_tri {}
explore: reserving {}
explore: reserving_uwyr_allocation {}
explore: tpi {}
explore: expoclm_quarters_cdl {}
explore: expoclm_quarters_smart {}
