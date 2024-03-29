view: expoclm_quarters_cdl {
  derived_table: {
    sql:
      select
    a.polnum,
    a.evy,
    a.exposure_asat,
    a.exposure_start,
    a.exposure_end,
    a.net_premium,
    a.eprem,
    a.policy_type,
    a.ncdp,
    a.quote_id,

    a.ad_paid,
    a.ad_incurred,
    a.ad_incurred_cap_50k,
    a.ad_count,

    a.tp_paid,
    a.tp_incurred,
    a.tp_incurred_cap_50k,
    a.tp_count,

    a.tp_other_count,
    a.tp_other_incurred,

    a.tp_chire_count,
    a.tp_chire_incurred,

    a.pi_paid,
    a.pi_incurred,
    a.pi_incurred_cap_25k,
    a.pi_incurred_cap_50k,
    a.pi_count,

    a.ot_paid,
    a.ot_incurred,
    a.ot_incurred_cap_50k,
    a.ot_count,

    a.ws_paid,
    a.ws_incurred,
    a.ws_incurred_cap_50k,
    a.ws_count,

    CASE WHEN a.pi_incurred_excess_25k > 0 then 1 else 0 end as large_pi_count,
    CASE WHEN a.pi_incurred_excess_25k > 0 then pi_incurred_excess_25k else 0 end as large_pi_incurred,


    CASE WHEN p.dev_quarter IS NOT NULL THEN a.tp_count*p.tp_frequency ELSE a.tp_count END AS projected_tp_count,
    CASE WHEN p.dev_quarter IS NOT NULL THEN a.ad_count*p.ad_frequency ELSE a.ad_count END AS projected_ad_count,
    CASE WHEN p.dev_quarter IS NOT NULL THEN a.pi_count*p.pi_frequency ELSE a.pi_count END AS projected_pi_count,
    CASE WHEN p.dev_quarter IS NOT NULL THEN a.ot_count*1 ELSE a.ot_count END AS projected_ot_count,
    CASE WHEN p.dev_quarter IS NOT NULL THEN a.ws_count*1 ELSE a.ws_count END AS projected_ws_count,

    CASE WHEN p.dev_quarter IS NOT NULL THEN a.ad_incurred*p.ad_frequency ELSE a.ad_incurred END AS projected_ad_incurred,
    CASE WHEN p.dev_quarter IS NOT NULL THEN a.tp_incurred*p.tp_frequency ELSE a.tp_incurred END AS projected_tp_incurred,
    CASE WHEN p.dev_quarter IS NOT NULL THEN a.pi_incurred_cap_50k*p.pi_frequency ELSE a.pi_incurred_cap_50k END AS projected_pi_incurred_cap_50k,


    predicted_ad_freq_cdl_apr23 * (CASE WHEN cdl_apr23_res.residual_flag = 'Y' THEN predicted_ad_freq_res_cdl_apr23 ELSE 1 end) *evy *1.321 as predicted_ad_freq_cdl_apr23,
    predicted_ad_sev_cdl_apr23 * (CASE WHEN cdl_apr23_res.residual_flag = 'Y' THEN predicted_ad_sev_res_cdl_apr23 ELSE 1 end) *evy *1.592    as predicted_ad_sev_cdl_apr23,
    predicted_ot_freq_cdl_apr23 * (CASE WHEN cdl_apr23_res.residual_flag = 'Y' THEN predicted_ot_freq_res_cdl_apr23 ELSE 1 end) *evy *1.214    as predicted_ot_freq_cdl_apr23,
    predicted_ot_sev_cdl_apr23 * (CASE WHEN cdl_apr23_res.residual_flag = 'Y' THEN predicted_ot_sev_res_cdl_apr23 ELSE 1 end) *evy *1.639    as predicted_ot_sev_cdl_apr23,
    predicted_pi_freq_cdl_apr23 * (CASE WHEN cdl_apr23_res.residual_flag = 'Y' THEN predicted_pi_freq_res_cdl_apr23 ELSE 1 end) *evy *1.16    as predicted_pi_freq_cdl_apr23,
    predicted_pi_sev_cdl_apr23 * (CASE WHEN cdl_apr23_res.residual_flag = 'Y' THEN predicted_pi_sev_res_cdl_apr23 ELSE 1 end) *evy *1.067    as predicted_pi_sev_cdl_apr23,
    predicted_tpc_freq_cdl_apr23 * evy *1.250   as predicted_tpc_freq_cdl_apr23,
    predicted_tpc_sev_cdl_apr23 * evy *1.894    as predicted_tpc_sev_cdl_apr23,
    predicted_tpo_freq_cdl_apr23 * (CASE WHEN cdl_apr23_res.residual_flag = 'Y' THEN predicted_tpo_freq_res_cdl_apr23 ELSE 1 end) *evy *1.238    as predicted_tpo_freq_cdl_apr23,
    predicted_tpo_sev_cdl_apr23 * (CASE WHEN cdl_apr23_res.residual_flag = 'Y' THEN predicted_tpo_sev_res_cdl_apr23 ELSE 1 end) *evy *1.539   as predicted_tpo_sev_cdl_apr23,
    predicted_ws_freq_cdl_apr23 * (CASE WHEN cdl_apr23_res.residual_flag = 'Y' THEN predicted_ws_freq_res_cdl_apr23 ELSE 1 end) *evy *0.940    as predicted_ws_freq_cdl_apr23,
    predicted_ws_sev_cdl_apr23 * evy *1.409    as predicted_ws_sev_cdl_apr23,
    predicted_lpi_freq_cdl_apr23 * evy *1.90  as predicted_lpi_freq_cdl_apr23,
    140192.4 * evy *0.733 as predicted_lpi_sev_cdl_apr23,


    case when a.quote_id = cdl_apr23.quote_id then 1 else 0 end as score_flag_cdl_apr23,
    case when a.quote_id = cdl_apr23_res.quote_id then 1 else 0 end as score_flag_cdl_apr23_res,


    date_trunc('quarter',a.exposure_start) as quarter,
    uwyr


    FROM expoclm_quarters_cdl a


left join
            (select
               *,
               row_number() over(partition by quote_id) as dup
             from uncalibrated_scores_cdl_apr23
            ) cdl_apr23
            on uuid_to_char(a.quote_id) = cdl_apr23.quote_id and cdl_apr23.dup = 1


left join
            (select
               *,
               row_number() over(partition by quote_id) as dup
             from cdl_apr23_residual_scores
            ) cdl_apr23_res
            on uuid_to_char(a.quote_id) = cdl_apr23_res.quote_id and cdl_apr23_res.dup = 1


    LEFT JOIN
          pattern_to_ultimate p
          ON (months_between (trunc (SYSDATE,'quarter'),trunc (a.exposure_start,'quarter')) / 3)-1 = p.dev_quarter


    WHERE date_trunc('quarter',a.exposure_start) < date_trunc('quarter',to_date(sysdate))

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

  measure: tp_other_freq {
    type: number
    sql: sum(tp_other_count)/nullif(sum(evy),0) ;;
    value_format: "0.00%"
  }

  measure: tp_chire_freq {
    type: number
    sql: sum(tp_chire_count)/nullif(sum(evy),0) ;;
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

  measure: large_pi_freq {
    type: number
    sql: sum(large_pi_count)/nullif(sum(evy),0) ;;
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

  measure: tp_other_sev {
    type: number
    sql: sum(tp_other_incurred)/nullif(sum(tp_other_count),0);;
    value_format: "#,##0"
  }

  measure: tp_chire_sev {
    type: number
    sql: sum(tp_chire_incurred)/nullif(sum(tp_chire_count),0);;
    value_format: "#,##0"
  }

  measure: pi_sev_50k {
    type: number
    sql: sum(pi_incurred_cap_50k)/nullif(sum(pi_count),0);;
    value_format: "#,##0"
  }

  measure: pi_sev_25k {
    type: number
    sql: sum(pi_incurred_cap_25k)/nullif(sum(pi_count),0);;
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

  measure: large_pi_sev {
    type: number
    sql: sum(large_pi_incurred)/nullif(sum(large_pi_count),0);;
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

  measure: pi_bc_cap_25k {
    type: number
    sql: sum(pi_incurred_cap_25k)/nullif(sum(evy),0);;
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

  measure: tp_other_bc {
    type: number
    sql: sum(tp_other_incurred)/nullif(sum(evy),0);;
    value_format: "#,##0"
  }

  measure: tp_chire_bc {
    type: number
    sql: sum(tp_chire_incurred)/nullif(sum(evy),0);;
    value_format: "#,##0"
  }

  measure: large_pi_bc {
    type: number
    sql: sum(large_pi_incurred)/nullif(sum(evy),0);;
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


  measure: average_earned_prem {
    type: number
    sql: sum(eprem)/nullif(sum(evy),0);;
    value_format: "#,##0"
  }





  measure: ad_freq_pred_cdl_apr23 {
    type: number
    sql: sum(case when score_flag_cdl_apr23 = 1 AND score_flag_cdl_apr23_res = 1 then predicted_ad_freq_cdl_apr23 else 0 end)/sum(case when score_flag_cdl_apr23 = 1 AND score_flag_cdl_apr23_res = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }

  measure: ad_sev_pred_cdl_apr23 {
    type: number
    sql: sum(case when score_flag_cdl_apr23 = 1 AND score_flag_cdl_apr23_res = 1 then predicted_ad_sev_cdl_apr23 else 0 end)/sum(case when score_flag_cdl_apr23 = 1 AND score_flag_cdl_apr23_res = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }

  measure: ad_bc_pred_cdl_apr23 {
    type: number
    sql: ${ad_freq_pred_cdl_apr23}*${ad_sev_pred_cdl_apr23};;
    value_format: "#,##0"
  }




  measure: tpo_freq_pred_cdl_apr23 {
    type: number
    sql: sum(case when score_flag_cdl_apr23 = 1 AND score_flag_cdl_apr23_res = 1 then predicted_tpo_freq_cdl_apr23 else 0 end)/sum(case when score_flag_cdl_apr23 = 1 AND score_flag_cdl_apr23_res = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }

  measure: tpo_sev_pred_cdl_apr23 {
    type: number
    sql: sum(case when score_flag_cdl_apr23 = 1 AND score_flag_cdl_apr23_res = 1 then predicted_tpo_sev_cdl_apr23 else 0 end)/sum(case when score_flag_cdl_apr23 = 1 AND score_flag_cdl_apr23_res = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }

  measure: tpo_bc_pred_cdl_apr23 {
    type: number
    sql: ${tpo_freq_pred_cdl_apr23}*${tpo_sev_pred_cdl_apr23};;
    value_format: "#,##0"
  }




  measure: tpc_freq_pred_cdl_apr23 {
    type: number
    sql: sum(case when score_flag_cdl_apr23 = 1 AND score_flag_cdl_apr23_res = 1 then predicted_tpc_freq_cdl_apr23 else 0 end)/sum(case when score_flag_cdl_apr23 = 1 AND score_flag_cdl_apr23_res = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }

  measure: tpc_sev_pred_cdl_apr23 {
    type: number
    sql: sum(case when score_flag_cdl_apr23 = 1 AND score_flag_cdl_apr23_res = 1 then predicted_tpc_sev_cdl_apr23 else 0 end)/sum(case when score_flag_cdl_apr23 = 1 AND score_flag_cdl_apr23_res = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }

  measure: tpc_bc_pred_cdl_apr23 {
    type: number
    sql: ${tpc_freq_pred_cdl_apr23}*${tpc_sev_pred_cdl_apr23};;
    value_format: "#,##0"
  }



  measure: pi_freq_pred_cdl_apr23 {
    type: number
    sql: sum(case when score_flag_cdl_apr23 = 1 AND score_flag_cdl_apr23_res = 1 then predicted_pi_freq_cdl_apr23 else 0 end)/sum(case when score_flag_cdl_apr23 = 1 AND score_flag_cdl_apr23_res = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }

  measure: pi_sev_pred_cdl_apr23 {
    type: number
    sql: sum(case when score_flag_cdl_apr23 = 1 AND score_flag_cdl_apr23_res = 1 then predicted_pi_sev_cdl_apr23 else 0 end)/sum(case when score_flag_cdl_apr23 = 1 AND score_flag_cdl_apr23_res = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }

  measure: pi_bc_pred_cdl_apr23 {
    type: number
    sql: ${pi_freq_pred_cdl_apr23}*${pi_sev_pred_cdl_apr23};;
    value_format: "#,##0"
  }




  measure: ot_freq_pred_cdl_apr23 {
    type: number
    sql: sum(case when score_flag_cdl_apr23 = 1 AND score_flag_cdl_apr23_res = 1 then predicted_ot_freq_cdl_apr23 else 0 end)/sum(case when score_flag_cdl_apr23 = 1 AND score_flag_cdl_apr23_res = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }

  measure: ot_sev_pred_cdl_apr23 {
    type: number
    sql: sum(case when score_flag_cdl_apr23 = 1 AND score_flag_cdl_apr23_res = 1 then predicted_ot_sev_cdl_apr23 else 0 end)/sum(case when score_flag_cdl_apr23 = 1 AND score_flag_cdl_apr23_res = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }

  measure: ot_bc_pred_cdl_apr23 {
    type: number
    sql: ${ot_freq_pred_cdl_apr23}*${ot_sev_pred_cdl_apr23};;
    value_format: "#,##0"
  }


  measure: ws_freq_pred_cdl_apr23 {
    type: number
    sql: sum(case when score_flag_cdl_apr23 = 1 AND score_flag_cdl_apr23_res = 1 then predicted_ws_freq_cdl_apr23 else 0 end)/sum(case when score_flag_cdl_apr23 = 1 AND score_flag_cdl_apr23_res = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }

  measure: ws_sev_pred_cdl_apr23 {
    type: number
    sql: sum(case when score_flag_cdl_apr23 = 1 AND score_flag_cdl_apr23_res = 1 then predicted_ws_sev_cdl_apr23 else 0 end)/sum(case when score_flag_cdl_apr23 = 1 AND score_flag_cdl_apr23_res = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }

  measure: ws_bc_pred_cdl_apr23 {
    type: number
    sql: ${ws_freq_pred_cdl_apr23}*${ws_sev_pred_cdl_apr23};;
    value_format: "#,##0"
  }



  measure: lpi_freq_pred_cdl_apr23 {
    type: number
    sql: sum(case when score_flag_cdl_apr23 = 1 AND score_flag_cdl_apr23_res = 1 then predicted_lpi_freq_cdl_apr23 else 0 end)/sum(case when score_flag_cdl_apr23 = 1 AND score_flag_cdl_apr23_res = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }

  measure: lpi_sev_pred_cdl_apr23 {
    type: number
    sql: sum(case when score_flag_cdl_apr23 = 1 AND score_flag_cdl_apr23_res = 1 then predicted_lpi_sev_cdl_apr23 else 0 end)/sum(case when score_flag_cdl_apr23 = 1 AND score_flag_cdl_apr23_res = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }

  measure: lpi_bc_pred_cdl_apr23 {
    type: number
    sql: ${lpi_freq_pred_cdl_apr23}*${lpi_sev_pred_cdl_apr23};;
    value_format: "#,##0"
  }





}
