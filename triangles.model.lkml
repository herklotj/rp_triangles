connection: "echo_actian"

# include all the views
include: "*.view"

datagroup: claims_development_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1000 hour"
}

persist_with: claims_development_datagroup

explore: claims_development {}
explore: expoclm_quarters {}
explore: ice_claims_development {}
