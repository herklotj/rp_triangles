view: expoclm_quarters_smart {
  derived_table: {
    sql:
         select
   a.min_age,
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
    CASE WHEN p.dev_quarter IS NOT NULL THEN a.tp_count*p.tp_frequency
          ELSE a.tp_count END AS projected_tp_count,
    CASE WHEN p.dev_quarter IS NOT NULL THEN a.ad_count*p.ad_frequency
          ELSE a.ad_count END AS projected_ad_count,
    CASE WHEN p.dev_quarter IS NOT NULL THEN a.pi_count*p.pi_frequency
          ELSE a.pi_count END AS projected_pi_count,
    CASE WHEN p.dev_quarter IS NOT NULL THEN a.ot_count*1
          ELSE a.ot_count END AS projected_ot_count,
    CASE WHEN p.dev_quarter IS NOT NULL THEN a.ws_count*1
          ELSE a.ws_count END AS projected_ws_count,

    CASE WHEN p.dev_quarter IS NOT NULL THEN a.tp_incurred*p.tp_frequency
          ELSE a.tp_incurred END AS projected_tp_incurred,

  CASE WHEN p.dev_quarter IS NOT NULL THEN a.ad_incurred*p.ad_frequency
          ELSE a.ad_incurred END AS projected_ad_incurred,

  CASE WHEN p.dev_quarter IS NOT NULL THEN a.pi_incurred_cap_50k*p.pi_frequency
          ELSE a.pi_incurred_cap_50k END AS projected_pi_incurred_cap_50k,

    smart.predicted_ad_freq_s_mar16*evy         as predicted_ad_freq_smar16,
    smart.predicted_ad_sev_s_mar16*evy         as predicted_ad_sev_smar16,
    smart.predicted_pi_freq_s_mar16*evy         as predicted_pi_freq_smar16,
    smart.predicted_pi_sev_s_mar16*evy         as predicted_pi_sev_smar16,
    smart.predicted_tp_freq_s_mar16*evy         as predicted_tp_freq_smar16,
    smart.predicted_tp_sev_s_mar16*evy         as predicted_tp_sev_smar16,
    smart.predicted_ot_freq_s_mar16*evy         as predicted_ot_freq_smar16,
    smart.predicted_ot_sev_s_mar16*evy         as predicted_ot_sev_smar16,
    smart.predicted_ws_freq_s_mar16*evy         as predicted_ws_freq_smar16,
    smart.predicted_ws_sev_s_mar16*evy         as predicted_ws_sec_smar16,


    case when a.quote_id = smart.quote_id then 1 else 0 end as score_flag_smar16,

    date_trunc('quarter',a.exposure_start) as quarter,
    uwyr



  from
            expoclm_quarters a
  left join
            (select
               *,
               row_number() over(partition by quote_id) as dup
             from uncalibrated_scores_smar16
            ) smart
            on a.quote_id = smart.quote_id and smart.dup = 1

      left join
        motor_model_calibrations aug18sc
        on aug18sc.policy_start_month = date_trunc('month',a.termincep) and aug18sc.model='August_18_pricing' and aug18sc.end = '9999-01-01'

    left join
                motor_model_calibrations jcredsc
                on jcredsc.policy_start_month = date_trunc('month',a.termincep) and jcredsc.model='July_19_Cred_Pric' and jcredsc.end = '9999-01-01'

    LEFT JOIN
          pattern_to_ultimate p
          ON (months_between (trunc (SYSDATE,'quarter'),trunc (a.exposure_start,'quarter')) / 3)-1 = p.dev_quarter


      where date_trunc('quarter',a.exposure_start) < date_trunc('quarter',to_date(sysdate)) and min_age < 25
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

  dimension: UWYR {
    type:  string
    sql: ${TABLE}.uwyr ;;
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

  measure: ad_freq_ult {
    type: number
    sql: sum(projected_ad_count)/nullif(sum(evy),0) ;;
    value_format: "0.00%"
  }

  measure: tp_freq {
    type: number
    sql: sum(tp_count)/nullif(sum(evy),0) ;;
    value_format: "0.00%"
  }

  measure: tp_freq_ult {
    type: number
    sql: sum(projected_tp_count)/nullif(sum(evy),0) ;;
    value_format: "0.00%"
  }

  measure: pi_freq {
    type: number
    sql: sum(pi_count)/nullif(sum(evy),0) ;;
    value_format: "0.00%"
  }

  measure: pi_freq_ult {
    type: number
    sql: sum(projected_pi_count)/nullif(sum(evy),0) ;;
    value_format: "0.00%"
  }

  measure: ot_freq {
    type: number
    sql: sum(ot_count)/nullif(sum(evy),0) ;;
    value_format: "0.00%"
  }

  measure: ot_freq_ult {
    type: number
    sql: sum(projected_ot_count)/nullif(sum(evy),0) ;;
    value_format: "0.00%"
  }

  measure: ws_freq {
    type: number
    sql: sum(ws_count)/nullif(sum(evy),0) ;;
    value_format: "0.00%"
  }

  measure: ws_freq_ult {
    type: number
    sql: sum(projected_ws_count)/nullif(sum(evy),0) ;;
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

  measure: ad_ult_bc {
    type: number
    sql: sum(projected_ad_incurred)/nullif(sum(evy),0);;
    value_format: "#,##0"
  }

  measure: tp_bc {
    type: number
    sql: sum(tp_incurred)/nullif(sum(evy),0);;
    value_format: "#,##0"
  }

  measure: tp_ult_bc {
    type: number
    sql: sum(projected_tp_incurred)/nullif(sum(evy),0);;
    value_format: "#,##0"
  }


  measure: pi_bc_cap_50k {
    type: number
    sql: sum(pi_incurred_cap_50k)/nullif(sum(evy),0);;
    value_format: "#,##0"
  }

  measure: pi_ult_bc_cap_50k {
    type: number
    sql: sum(projected_pi_incurred_cap_50k)/nullif(sum(evy),0);;
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

  measure: total_ult_bc_cap_50k {
    type: number
    sql: ${ad_ult_bc}+${tp_ult_bc}+${pi_ult_bc_cap_50k}+${ot_bc}+${ws_bc};;
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

  measure: total_lr_cap_50k {
    type: number
    sql: (sum(ad_incurred+tp_incurred+pi_incurred_cap_50k+ot_incurred+ws_incurred))/nullif(sum(eprem),0);;
    value_format: "0%"
  }

  measure: total_ult_lr_cap_50k {
    type: number
    sql: (sum(projected_ad_incurred+projected_tp_incurred+projected_pi_incurred_cap_50k+ot_incurred+ws_incurred))/nullif(sum(eprem),0);;
    value_format: "0%"
  }

  measure: ad_freq_pred_smar16 {
    type: number
    sql: sum(predicted_ad_freq_smar16)/sum(evy) ;;
    value_format: "0.00%"
  }
  measure: ad_sev_pred_smar16 {
    type: number
    sql: sum(predicted_ad_sev_smar16)/sum(evy) ;;
    value_format: "#,##0"
  }
  measure: ad_bc_pred_smar16 {
    type: number
    sql: ${ad_freq_pred_smar16}*${ad_sev_pred_smar16};;
    value_format: "#,##0"
  }


  measure: tp_freq_pred_smar16 {
    type: number
    sql: sum(predicted_tp_freq_smar16)/sum(evy) ;;
    value_format: "0.00%"
  }
  measure: tp_sev_pred_smar16 {
    type: number
    sql: sum(predicted_tp_sev_smar16)/sum(evy) ;;
    value_format: "#,##0"
  }
  measure: tp_bc_pred_smar16 {
    type: number
    sql: ${tp_freq_pred_smar16}*${tp_sev_pred_smar16};;
    value_format: "#,##0"
  }



  measure: pi_freq_pred_smar16 {
    type: number
    sql: sum(predicted_pi_freq_smar16)/sum(evy) ;;
    value_format: "0.00%"
  }
  measure: pi_sev_pred_smar16 {
    type: number
    sql: sum(predicted_pi_sev_smar16)/sum(evy) ;;
    value_format: "#,##0"
  }
  measure: pi_bc_pred_smar16 {
    type: number
    sql: ${pi_freq_pred_smar16}*${pi_sev_pred_smar16};;
    value_format: "#,##0"
  }

  measure: ot_freq_pred_smar16 {
    type: number
    sql: sum(predicted_ot_freq_smar16)/sum(evy) ;;
    value_format: "0.00%"
  }
  measure: ot_sev_pred_smar16 {
    type: number
    sql: sum(predicted_ot_sev_smar16)/sum(evy) ;;
    value_format: "#,##0"
  }
  measure: ot_bc_pred_smar16 {
    type: number
    sql: ${ot_freq_pred_smar16}*${ot_sev_pred_smar16};;
    value_format: "#,##0"
  }

  measure: ws_freq_pred_smar16 {
    type: number
    sql: sum(predicted_ws_freq_smar16)/sum(evy) ;;
    value_format: "0.00%"
  }
  measure: ws_sev_pred_smar16 {
    type: number
    sql: sum(predicted_ws_sev_smar16)/sum(evy) ;;
    value_format: "#,##0"
  }
  measure: ws_bc_pred_smar16 {
    type: number
    sql: ${ws_freq_pred_smar16}*${ws_sev_pred_smar16};;
    value_format: "#,##0"
  }

  measure: total_bc_pred_smar16 {
    type: number
    sql: ${ad_bc_pred_smar16}+${tp_bc_pred_smar16}+${ot_bc_pred_smar16}+${pi_bc_pred_smar16}+${ws_bc_pred_smar16};;
    value_format: "#,##0"
  }

  measure: total_lr_pred_smar16 {
    type: number
    sql: (${ad_bc_pred_smar16}+${tp_bc_pred_smar16}+${ot_bc_pred_smar16}+${pi_bc_pred_smar16}+${ws_bc_pred_smar16})/${average_earned_prem};;
    value_format: "0%"
  }

  measure: average_earned_prem {
    type: number
    sql: sum(eprem)/nullif(sum(evy),0);;
    value_format: "#,##0"
  }

}
