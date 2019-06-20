view: expoclm_quarters {
  derived_table: {
    sql:
    select
  a.polnum,
  a.scheme_number,
  a.evy,
  a.exposure_asat,
  a.exposure_start,
  a.exposure_end,
  a.net_premium,
  a.eprem,
  a.policy_type,
  a.ncdp,
  a.quote_id,
  a.tp_paid,
  a.tp_incurred,
  a.tp_incurred_cap_50k,
  a.tp_count,
  a.ad_paid,
  a.ad_incurred,
  a.ad_incurred_cap_50k,
  a.ad_count,
  a.pi_paid,
  a.pi_incurred,
  a.pi_incurred_cap_50k,
  a.pi_count,
  a.ws_paid,
  a.ws_incurred,
  a.ws_incurred_cap_50k,
  a.ws_count,
  a.ot_paid,
  a.ot_incurred,
  a.ot_incurred_cap_50k,
  a.ot_count,
  a.total_paid,
  a.total_incurred,
  a.total_incurred_cap_50k,
  a.total_count,
  a.total_count_exc_ws,
  (case when a.ncdp = 'N' then b.predicted_ad_freq_an else b.predicted_ad_freq_ap end)*evy*1.0 as predicted_ad_freq_aug18,
  (case when a.ncdp = 'N' then b.predicted_ad_sev_an else b.predicted_ad_sev_ap end)*evy*1.12 as predicted_ad_sev_aug18,
  (case when a.ncdp = 'N' then b.predicted_pi_freq_an else b.predicted_pi_freq_ap end)*evy*1.0 as predicted_pi_freq_aug18,
  (case when a.ncdp = 'N' then b.predicted_pi_sev_an else b.predicted_pi_sev_ap end)*evy*0.85 as predicted_pi_sev_aug18,
  (case when a.ncdp = 'N' then b.predicted_tpd_freq_an else b.predicted_tpd_freq_ap end)*evy*0.88 as predicted_tp_freq_aug18,
  (case when a.ncdp = 'N' then b.predicted_tpd_sev_an else b.predicted_tpd_sev_ap end)*evy*1.11 as predicted_tp_sev_aug18,
  (case when a.ncdp = 'N' then b.predicted_ot_freq_an else b.predicted_ot_freq_ap end)*evy*1.05 as predicted_ot_freq_aug18,
  (case when a.ncdp = 'N' then b.predicted_ot_sev_an else b.predicted_ot_sev_ap end)*evy*1.7 as predicted_ot_sev_aug18,
  (case when a.ncdp = 'N' then b.predicted_ws_freq_an else b.predicted_ws_freq_ap end)*evy*1.0 as predicted_ws_freq_aug18,
  (case when a.ncdp = 'N' then b.predicted_ws_sev_an else b.predicted_ws_sev_ap end)*evy*1.2 as predicted_ws_sev_aug18,
  b.dup as match_flag,
  date_trunc('quarter',a.exposure_start) as quarter
from expoclm_quarters a
left join (select
             *,
             row_number() over(partition by quote_id) as dup
           from uncalibrated_scores_aug18) b
  on a.quote_id = b.quote_id and b.dup = 1
    where date_trunc('quarter',a.exposure_start) <= date_trunc('quarter',to_date(sysdate))
         ;;
  }

  dimension: Accident_Quarter {
    type: date_quarter
    sql: ${TABLE}.quarter ;;
  }

  dimension: Scheme {
    type:  string
    sql: ${TABLE}.scheme_number ;;
  }

  dimension: Policy_Type {
    type: string
    sql:policy_type ;;
  }






  measure: evy {
    type: number
    sql: sum(evy) ;;
  }



  measure: ad_freq {
    type: number
    sql: sum(ad_count)/nullif(sum(evy),0) ;;
    value_format: "0.00%"
  }

  measure: tp_freq {
    type: number
    sql: sum(tp_count)/nullif(sum(evy),0) ;;
    value_format: "0.00%"
  }

  measure: pi_freq {
    type: number
    sql: sum(pi_count)/nullif(sum(evy),0) ;;
    value_format: "0.00%"
  }

  measure: ot_freq {
    type: number
    sql: sum(ot_count)/nullif(sum(evy),0) ;;
    value_format: "0.00%"
  }

  measure: ws_freq {
    type: number
    sql: sum(ws_count)/nullif(sum(evy),0) ;;
    value_format: "0.00%"
  }

  measure: ad_sev {
    type: number
    sql: sum(ad_incurred)/nullif(sum(ad_count),0);;
    value_format: "#,##0"
  }

  measure: tp_sev {
    type: number
    sql: sum(tp_incurred)/nullif(sum(tp_count),0);;
    value_format: "#,##0"
  }

  measure: pi_sev_50k {
    type: number
    sql: sum(pi_incurred_cap_50k)/nullif(sum(pi_count),0);;
    value_format: "#,##0"
  }

  measure: ot_sev {
    type: number
    sql: sum(ot_incurred)/nullif(sum(ot_count),0);;
    value_format: "#,##0"
  }

  measure: ws_sev {
    type: number
    sql: sum(ws_incurred)/nullif(sum(ws_count),0);;
    value_format: "#,##0"
  }

  measure: ad_bc {
    type: number
    sql: sum(ad_incurred)/nullif(sum(evy),0);;
    value_format: "#,##0"
  }

  measure: tp_bc {
    type: number
    sql: sum(tp_incurred)/nullif(sum(evy),0);;
    value_format: "#,##0"
  }

  measure: pi_bc_cap_50k {
    type: number
    sql: sum(pi_incurred_cap_50k)/nullif(sum(evy),0);;
    value_format: "#,##0"
  }

  measure: ot_bc {
    type: number
    sql: sum(ot_incurred)/nullif(sum(evy),0);;
    value_format: "#,##0"
  }

  measure: ws_bc {
    type: number
    sql: sum(ws_incurred)/nullif(sum(evy),0);;
    value_format: "#,##0"
  }

  measure: total_bc_cap_50k {
    type: number
    sql: ${ad_bc}+${tp_bc}+${pi_bc_cap_50k}+${ot_bc}+${ws_bc};;
    value_format: "#,##0"
  }

  measure: ad_lr {
    type: number
    sql: sum(ad_incurred)/nullif(sum(eprem),0);;
     value_format: "0.0%"
  }

  measure: tp_lr {
    type: number
    sql: sum(tp_incurred)/nullif(sum(eprem),0);;
    value_format: "0.0%"
  }

  measure: pi_cap_50k_lr {
    type: number
    sql: sum(pi_incurred_cap_50k)/nullif(sum(eprem),0);;
    value_format: "0.0%"
  }




  measure: ad_freq_pred_aug18 {
    type: number
    sql: sum(case when match_flag = 1 then predicted_ad_freq_aug18 else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }
  measure: ad_sev_pred_aug18 {
    type: number
    sql: sum(case when match_flag = 1 then predicted_ad_sev_aug18 else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: ad_bc_pred_aug18 {
    type: number
    sql: ${ad_freq_pred_aug18}*${ad_sev_pred_aug18};;
    value_format: "#,##0"
  }


  measure: tp_freq_pred_aug18 {
    type: number
    sql: sum(case when match_flag = 1 then predicted_tp_freq_aug18 else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }
  measure: tp_sev_pred_aug18 {
    type: number
    sql: sum(case when match_flag = 1 then predicted_tp_sev_aug18 else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: tp_bc_pred_aug18 {
    type: number
    sql: ${tp_freq_pred_aug18}*${tp_sev_pred_aug18};;
    value_format: "#,##0"
  }

  measure: pi_freq_pred_aug18 {
    type: number
    sql: sum(case when match_flag = 1 then predicted_pi_freq_aug18 else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }
  measure: pi_sev_pred_aug18 {
    type: number
    sql: sum(case when match_flag = 1 then predicted_pi_sev_aug18 else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: pi_bc_pred_aug18 {
    type: number
    sql: ${pi_freq_pred_aug18}*${pi_sev_pred_aug18};;
    value_format: "#,##0"
  }

  measure: ot_freq_pred_aug18 {
    type: number
    sql: sum(case when match_flag = 1 then predicted_ot_freq_aug18 else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }
  measure: ot_sev_pred_aug18 {
    type: number
    sql: sum(case when match_flag = 1 then predicted_ot_sev_aug18 else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: ot_bc_pred_aug18 {
    type: number
    sql: ${ot_freq_pred_aug18}*${ot_sev_pred_aug18};;
    value_format: "#,##0"
  }

  measure: ws_freq_pred_aug18 {
    type: number
    sql: sum(case when match_flag = 1 then predicted_ws_freq_aug18 else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }
  measure: ws_sev_pred_aug18 {
    type: number
    sql: sum(case when match_flag = 1 then predicted_ws_sev_aug18 else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: ws_bc_pred_aug18 {
    type: number
    sql: ${ws_freq_pred_aug18}*${ws_sev_pred_aug18};;
    value_format: "#,##0"
  }

  measure: total_bc_pred_aug18 {
    type: number
    sql: ${ad_bc_pred_aug18}+${tp_bc_pred_aug18}+${ot_bc_pred_aug18}+${pi_bc_pred_aug18}+${ws_bc_pred_aug18};;
    value_format: "#,##0"
  }

  }
