view: tpi {
  derived_table: {
    sql:

  SELECT
  claim_number,
  count(claim_number) as no_claimants,
  sum(case when tpinterventionrequired = 'Yes' and contactsuccess IN ('Successful', 'Not Successful') then 1 else 0 end) as tpinterventionrequired,
  sum(CASE WHEN tpi_status = 'Successful Intervention' then 1 else 0 end) as no_sucessful_int,
  sum(CASE WHEN tpi_status = 'Unsuccessful Intervention' then 1 else 0 end) as no_unsuccessful_int,
  sum(CASE WHEN tpi_status = 'Unknown' then 1 else 0 end) as no_unknown,
  sum(CASE WHEN tpi_status = 'No TPI' then 1 else 0 end) as no_none_tpi,
  sum(CASE WHEN tpi_status = 'Non Contactable' then 1 else 0 end) as no_non_contactable,
  sum(CASE WHEN type_of_int = 'Both' then 1 else 0 end) as no_both,
  sum(CASE WHEN type_of_int = 'CHire' then 1 else 0 end) as no_chire,
  sum(CASE WHEN type_of_int = 'Repairs' then 1 else 0 end) as no_repairs,
  notification_date

  FROM

  (SELECT *,
  CASE WHEN tpinterventionrequired = 'Yes' AND contactsuccess = 'Successful' AND (hirevehiclerequired = 'Yes' OR repairsrequired = 'Yes') then 'Successful Intervention'
  WHEN tpinterventionrequired = 'Yes' AND contactsuccess = 'Successful' AND (hirevehiclerequired = 'No' OR hirevehiclerequired IS NULL) AND (repairsrequired = 'No' OR repairsrequired IS NULL) then 'Unsuccessful Intervention'
  WHEN tpinterventionrequired = 'No' then 'No TPI'
  WHEN tpinterventionrequired = 'Yes' AND contactsuccess = 'Not Successful' then 'Non Contactable'
  ELSE 'Unknown' END AS tpi_status,
  CASE WHEN hirevehiclerequired = 'Yes' AND repairsrequired = 'Yes' then 'Both' WHEN hirevehiclerequired = 'Yes' then 'CHire' WHEN repairsrequired = 'Yes' then 'Repairs' else 'Unknown' end as type_of_int
  FROM ice_aa_tp_intervention) a

  GROUP BY claim_number, notification_date

            ;;
  }


  dimension_group: notification_date {
    type: time
    timeframes: [
      month
    ]
    sql: ${TABLE}.notification_date ;;
  }


  measure: successful_tpi_rate {
    type: number
    sql: sum(case when no_sucessful_int >= 1 then 1 else 0 end) / sum(case when tpinterventionrequired >= 1 then 1 else 0.000000000000000000000001 end)   ;;
    value_format: "0.0%"

  }

  measure: unsuccessful_tpi_rate {
    type: number
    sql: sum(case when no_unsuccessful_int >= 1 and no_sucessful_int = 0 then 1 else 0 end) / sum(case when tpinterventionrequired >= 1 then 1 else 0.000000000000000000000001 end) ;;
    value_format: "0.0%"

  }

  measure: non_contactable_tpi_rate {
    type: number
    sql: sum(case when no_sucessful_int = 0 and no_unsuccessful_int = 0 and no_non_contactable >= 1 then 1 else 0 end) / sum(case when tpinterventionrequired >= 1 then 1 else 0.000000000000000000000001 end) ;;
    value_format: "0.0%"

  }

  measure: total_require_tpi {
    type: number
    sql: sum(case when tpinterventionrequired >= 1 then 1 else 0 end)   ;;

  }

  measure: total_sucessful_tpi {
    type: number
    sql: sum(case when no_sucessful_int >= 1 then 1 else 0 end)   ;;

  }

  measure: total_unsucessful_tpi {
    type: number
    sql: sum(case when no_unsuccessful_int >= 1 and no_sucessful_int = 0 then 1 else 0 end)   ;;

  }

  measure: total_noncontactable_tpi {
    type: number
    sql: sum(case when no_sucessful_int = 0 and no_unsuccessful_int = 0 and no_non_contactable >= 1 then 1 else 0 end)   ;;

  }

  measure: total_no_intervention_required {
    type: number
    sql: sum(case when no_sucessful_int = 0 and no_unsuccessful_int = 0 and no_non_contactable = 0 and no_none_tpi >= 1 then 1 else 0 end)   ;;

  }

  measure: total_unknown_tpi {
    type: number
    sql: sum(case when no_sucessful_int = 0 and no_unsuccessful_int = 0 and no_non_contactable = 0 and no_none_tpi = 0 then 1 else 0 end)   ;;

  }







}
