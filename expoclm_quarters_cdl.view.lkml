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


    case when ncdp = 'N' then dec19nm.predicted_ad_freq_an_nm_dec19 else dec19nm.predicted_ad_freq_ap_nm_dec19 end *evy *1.031         as predicted_ad_freq_dec19nm,
    case when ncdp = 'N' then dec19nm.predicted_ad_sev_an_nm_dec19 else dec19nm.predicted_ad_sev_ap_nm_dec19 end *evy *1.946        as predicted_ad_sev_dec19nm,
    case when ncdp = 'N' then dec19nm.predicted_pi_freq_an_nm_dec19 else dec19nm.predicted_pi_freq_ap_nm_dec19 end *evy *0.924         as predicted_pi_freq_dec19nm,
    case when ncdp = 'N' then dec19nm.predicted_pi_sev_an_nm_dec19 else dec19nm.predicted_pi_sev_ap_nm_dec19 end *evy *0.973          as predicted_pi_sev_dec19nm,
    case when ncdp = 'N' then dec19nm.predicted_tp_freq_an_nm_dec19 else dec19nm.predicted_tp_freq_ap_nm_dec19 end *evy *1.008          as predicted_tp_freq_dec19nm,
    case when ncdp = 'N' then dec19nm.predicted_tp_sev_an_nm_dec19 else dec19nm.predicted_tp_sev_ap_nm_dec19 end *evy *1.689            as predicted_tp_sev_dec19nm,
    case when ncdp = 'N' then dec19nm.predicted_ot_freq_an_nm_dec19 else dec19nm.predicted_ot_freq_ap_nm_dec19 end *evy *1.601         as predicted_ot_freq_dec19nm,
    case when ncdp = 'N' then dec19nm.predicted_ot_sev_an_nm_dec19 else dec19nm.predicted_ot_sev_ap_nm_dec19 end *evy *2.074           as predicted_ot_sev_dec19nm,
    case when ncdp = 'N' then dec19nm.predicted_ws_freq_an_nm_dec19 else dec19nm.predicted_ws_freq_ap_nm_dec19 end *evy *1.031         as predicted_ws_freq_dec19nm,
    case when ncdp = 'N' then dec19nm.predicted_ws_sev_an_nm_dec19 else dec19nm.predicted_ws_sev_ap_nm_dec19 end *evy *1.468         as predicted_ws_sev_dec19nm,

    case when ncdp = 'N' then dec19m.predicted_ad_freq_an_m_dec19 else dec19m.predicted_ad_freq_ap_m_dec19 end *evy *1.037         as predicted_ad_freq_dec19m,
    case when ncdp = 'N' then dec19m.predicted_ad_sev_an_m_dec19 else dec19m.predicted_ad_sev_ap_m_dec19 end *evy *1.947         as predicted_ad_sev_dec19m,
    case when ncdp = 'N' then dec19m.predicted_pi_freq_an_m_dec19 else dec19m.predicted_pi_freq_ap_m_dec19 end *evy *0.902           as predicted_pi_freq_dec19m,
    case when ncdp = 'N' then dec19m.predicted_pi_sev_an_m_dec19 else dec19m.predicted_pi_sev_ap_m_dec19 end *evy *0.975           as predicted_pi_sev_dec19m,
    case when ncdp = 'N' then dec19m.predicted_tp_freq_an_m_dec19 else dec19m.predicted_tp_freq_ap_m_dec19 end *evy *0.988         as predicted_tp_freq_dec19m,
    case when ncdp = 'N' then dec19m.predicted_tp_sev_an_m_dec19 else dec19m.predicted_tp_sev_ap_m_dec19 end *evy *1.692          as predicted_tp_sev_dec19m,
    case when ncdp = 'N' then dec19m.predicted_ot_freq_an_m_dec19 else dec19m.predicted_ot_freq_ap_m_dec19 end *evy *1.533          as predicted_ot_freq_dec19m,
    case when ncdp = 'N' then dec19m.predicted_ot_sev_an_m_dec19 else dec19m.predicted_ot_sev_ap_m_dec19 end *evy *2.112           as predicted_ot_sev_dec19m,
    case when ncdp = 'N' then dec19m.predicted_ws_freq_an_m_dec19 else dec19m.predicted_ws_freq_ap_m_dec19 end *evy *1.031         as predicted_ws_freq_dec19m,
    case when ncdp = 'N' then dec19m.predicted_ws_sev_an_m_dec19 else dec19m.predicted_ws_sev_ap_m_dec19 end *evy *1.468          as predicted_ws_sev_dec19m,



    predicted_ad_freq_initialcdlmodels *(CASE WHEN residual_flag = 'Y' THEN predicted_ad_freq_res_202212 ELSE 1 end) *evy *1.31  as predicted_ad_freq_initialcdlmodels_adj,
    predicted_ad_sev_initialcdlmodels *(CASE WHEN residual_flag = 'Y' THEN predicted_ad_sev_res_202212 ELSE 1 end) *evy *1.49  as predicted_ad_sev_initialcdlmodels_adj,
    predicted_ot_freq_initialcdlmodels *(CASE WHEN residual_flag = 'Y' THEN predicted_ot_freq_res_202212 ELSE 1 end) *evy *1.44  as predicted_ot_freq_initialcdlmodels_adj,
    predicted_ot_sev_initialcdlmodels *(CASE WHEN residual_flag = 'Y' THEN predicted_ot_sev_res_202212 ELSE 1 end) *evy *1.46  as predicted_ot_sev_initialcdlmodels_adj,
    predicted_pi_freq_initialcdlmodels *(CASE WHEN residual_flag = 'Y' THEN predicted_pi_freq_res_202212 ELSE 1 end) *evy *1.19  as predicted_pi_freq_initialcdlmodels_adj,
    predicted_pi_sev_initialcdlmodels *(CASE WHEN residual_flag = 'Y' THEN predicted_pi_sev_res_202212 ELSE 1 end) *evy *0.94  as predicted_pi_sev_initialcdlmodels_adj,
    predicted_tpc_freq_initialcdlmodels *evy *1.13  as predicted_tpc_freq_initialcdlmodels_adj,
    predicted_tpc_sev_initialcdlmodels *evy *1.60  as predicted_tpc_sev_initialcdlmodels_adj,
    predicted_tpo_freq_initialcdlmodels *(CASE WHEN residual_flag = 'Y' THEN predicted_tpo_freq_res_202212 ELSE 1 end) *evy *1.18  as predicted_tpo_freq_initialcdlmodels_adj,
    predicted_tpo_sev_initialcdlmodels *(CASE WHEN residual_flag = 'Y' THEN predicted_tpo_sev_res_202212 ELSE 1 end) *evy *1.44 as predicted_tpo_sev_initialcdlmodels_adj,
    predicted_ws_freq_initialcdlmodels *(CASE WHEN residual_flag = 'Y' THEN predicted_ws_freq_res_202212 ELSE 1 end) *evy *0.91  as predicted_ws_freq_initialcdlmodels_adj,
    predicted_ws_sev_initialcdlmodels *evy *1.23  as predicted_ws_sev_initialcdlmodels_adj,
    predicted_lpi_freq_initialcdlmodels *evy *1.11  as predicted_lpi_freq_initialcdlmodels_adj,
    116827 *evy as predicted_lpi_sev_initialcdlmodels_adj,



    predicted_ad_freq_cdl_apr23 * (CASE WHEN residual_flag_cdl_apr23 = 'Y' THEN predicted_ad_freq_res_cdl_apr23 ELSE 1 end) *evy *1.33  as predicted_ad_freq_cdl_apr23,
    predicted_ad_sev_cdl_apr23 * (CASE WHEN residual_flag_cdl_apr23 = 'Y' THEN predicted_ad_sev_res_cdl_apr23 ELSE 1 end) *evy *1.48   as predicted_ad_sev_cdl_apr23,
    predicted_ot_freq_cdl_apr23 * (CASE WHEN residual_flag_cdl_apr23 = 'Y' THEN predicted_ot_freq_res_cdl_apr23 ELSE 1 end) *evy *1.47   as predicted_ot_freq_cdl_apr23,
    predicted_ot_sev_cdl_apr23 * (CASE WHEN residual_flag_cdl_apr23 = 'Y' THEN predicted_ot_sev_res_cdl_apr23 ELSE 1 end) *evy *1.45   as predicted_ot_sev_cdl_apr23,
    predicted_pi_freq_cdl_apr23 * (CASE WHEN residual_flag_cdl_apr23 = 'Y' THEN predicted_pi_freq_res_cdl_apr23 ELSE 1 end) *evy *1.21   as predicted_pi_freq_cdl_apr23,
    predicted_pi_sev_cdl_apr23 * (CASE WHEN residual_flag_cdl_apr23 = 'Y' THEN predicted_pi_sev_res_cdl_apr23 ELSE 1 end) *evy *0.99   as predicted_pi_sev_cdl_apr23,
    predicted_tpc_freq_cdl_apr23 * evy   as predicted_tpc_freq_cdl_apr23,
    predicted_tpc_sev_cdl_apr23 * evy   as predicted_tpc_sev_cdl_apr23,
    predicted_tpo_freq_cdl_apr23 * (CASE WHEN residual_flag_cdl_apr23 = 'Y' THEN predicted_tpo_freq_res_cdl_apr23 ELSE 1 end) *evy   as predicted_tpo_freq_cdl_apr23,
    predicted_tpo_sev_cdl_apr23 * (CASE WHEN residual_flag_cdl_apr23 = 'Y' THEN predicted_tpo_sev_res_cdl_apr23 ELSE 1 end) *evy  as predicted_tpo_sev_cdl_apr23,
    predicted_ws_freq_cdl_apr23 * (CASE WHEN residual_flag_cdl_apr23 = 'Y' THEN predicted_ws_freq_res_cdl_apr23 ELSE 1 end) *evy *0.92   as predicted_ws_freq_cdl_apr23,
    predicted_ws_sev_cdl_apr23 * evy *1.26   as predicted_ws_sev_cdl_apr23,
    predicted_lpi_freq_cdl_apr23 * evy as predicted_lpi_freq_cdl_apr23,
    108843 * evy as predicted_lpi_sev_cdl_apr23,


    case when a.quote_id = dec19nm.quote_id then 1 else 0 end as score_flag_dec19nm,
    case when a.quote_id = dec19m.quote_id then 1 else 0 end as score_flag_dec19m,
    case when a.quote_id = cdl_models.quote_id then 1 else 0 end as score_flag_cdl_models,
    case when a.quote_id = cdl_residuals.quote_id then 1 else 0 end as score_flag_cdl_residuals,
    case when a.quote_id = cdl_apr23.quote_id then 1 else 0 end as score_flag_cdl_apr23,
    case when a.quote_id = cdl_apr23_res.quote_id then 1 else 0 end as score_flag_cdl_apr23_res,


    date_trunc('quarter',a.exposure_start) as quarter,
    uwyr


    FROM expoclm_quarters_cdl a


 left join
            (select
               *,
               row_number() over(partition by quote_id) as dup
             from aapricing.uncalibrated_scores_nmdec19_new
            ) dec19nm
            on a.quote_id = dec19nm.quote_id and dec19nm.dup = 1

left join
            (select
               *,
               row_number() over(partition by quote_id) as dup
             from aapricing.uncalibrated_scores_mdec19_new
            ) dec19m
            on a.quote_id = dec19m.quote_id and dec19m.dup = 1

left join
            (select
               *,
               row_number() over(partition by quote_id) as dup
             from aapricing.uncalibrated_scores_initial_cdl_models
            ) cdl_models
            on a.quote_id = cdl_models.quote_id and cdl_models.dup = 1


left join
            (select
               *,
               row_number() over(partition by quote_id) as dup
             from aapricing.initial_cdl_residual_scores
            ) cdl_residuals
            on a.quote_id = cdl_residuals.quote_id and cdl_residuals.dup = 1


left join
            (select
               *,
               row_number() over(partition by quote_id) as dup
             from aapricing.uncalibrated_scores_cdl_apr23
            ) cdl_apr23
            on a.quote_id = cdl_apr23.quote_id and cdl_apr23.dup = 1


left join
            (select
               *,
               row_number() over(partition by quote_id) as dup
             from aapricing.cdl_apr23_residual_scores
            ) cdl_apr23_res
            on a.quote_id = cdl_apr23_res.quote_id and cdl_apr23_res.dup = 1


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








  measure: ad_freq_pred_dec19nm {
    type: number
    sql: sum(case when score_flag_dec19nm = 1 then predicted_ad_freq_dec19nm else 0 end)/sum(case when score_flag_dec19nm = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }

  measure: ad_sev_pred_dec19nm {
    type: number
    sql: sum(case when score_flag_dec19nm = 1 then predicted_ad_sev_dec19nm else 0 end)/sum(case when score_flag_dec19nm = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: ad_bc_pred_dec19nm {
    type: number
    sql: ${ad_freq_pred_dec19nm}*${ad_sev_pred_dec19nm};;
    value_format: "#,##0"
  }


  measure: tp_freq_pred_dec19nm {
    type: number
    sql: sum(case when score_flag_dec19nm = 1 then predicted_tp_freq_dec19nm else 0 end)/sum(case when score_flag_dec19nm = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }
  measure: tp_sev_pred_dec19nm {
    type: number
    sql: sum(case when score_flag_dec19nm = 1 then predicted_tp_sev_dec19nm else 0 end)/sum(case when score_flag_dec19nm = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: tp_bc_pred_dec19nm {
    type: number
    sql: ${tp_freq_pred_dec19nm}*${tp_sev_pred_dec19nm};;
    value_format: "#,##0"
  }



  measure: pi_freq_pred_dec19nm {
    type: number
    sql: sum(case when score_flag_dec19nm = 1 then predicted_pi_freq_dec19nm else 0 end)/sum(case when score_flag_dec19nm = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }
  measure: pi_sev_pred_dec19nm {
    type: number
    sql: sum(case when score_flag_dec19nm = 1 then predicted_pi_sev_dec19nm else 0 end)/sum(case when score_flag_dec19nm = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: pi_bc_pred_dec19nm {
    type: number
    sql: ${pi_freq_pred_dec19nm}*${pi_sev_pred_dec19nm};;
    value_format: "#,##0"
  }

  measure: ot_freq_pred_dec19nm {
    type: number
    sql: sum(case when score_flag_dec19nm = 1 then predicted_ot_freq_dec19nm else 0 end)/sum(case when score_flag_dec19nm = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }
  measure: ot_sev_pred_dec19nm {
    type: number
    sql: sum(case when score_flag_dec19nm = 1 then predicted_ot_sev_dec19nm else 0 end)/sum(case when score_flag_dec19nm = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: ot_bc_pred_dec19nm {
    type: number
    sql: ${ot_freq_pred_dec19nm}*${ot_sev_pred_dec19nm};;
    value_format: "#,##0"
  }

  measure: ws_freq_pred_dec19nm {
    type: number
    sql: sum(case when score_flag_dec19nm = 1 then predicted_ws_freq_dec19nm else 0 end)/sum(case when score_flag_dec19nm = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }
  measure: ws_sev_pred_dec19nm {
    type: number
    sql: sum(case when score_flag_dec19nm = 1 then predicted_ws_sev_dec19nm else 0 end)/sum(case when score_flag_dec19nm = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: ws_bc_pred_dec19nm {
    type: number
    sql: ${ws_freq_pred_dec19nm}*${ws_sev_pred_dec19nm};;
    value_format: "#,##0"
  }

  measure: total_bc_pred_dec19nm {
    type: number
    sql: ${ad_bc_pred_dec19nm}+${tp_bc_pred_dec19nm}+${ot_bc_pred_dec19nm}+${pi_bc_pred_dec19nm}+${ws_bc_pred_dec19nm};;
    value_format: "#,##0"
  }

  measure: total_lr_pred_dec19nm {
    type: number
    sql: (${ad_bc_pred_dec19nm}+${tp_bc_pred_dec19nm}+${ot_bc_pred_dec19nm}+${pi_bc_pred_dec19nm}+${ws_bc_pred_dec19nm})/${average_earned_prem};;
    value_format: "0%"
  }








  measure: ad_freq_pred_dec19m {
    type: number
    sql: sum(case when score_flag_dec19m = 1 then predicted_ad_freq_dec19m else 0 end)/sum(case when score_flag_dec19m = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }

  measure: ad_sev_pred_dec19m {
    type: number
    sql: sum(case when score_flag_dec19m = 1 then predicted_ad_sev_dec19m else 0 end)/sum(case when score_flag_dec19m = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: ad_bc_pred_dec19m {
    type: number
    sql: ${ad_freq_pred_dec19m}*${ad_sev_pred_dec19m};;
    value_format: "#,##0"
  }


  measure: tp_freq_pred_dec19m {
    type: number
    sql: sum(case when score_flag_dec19m = 1 then predicted_tp_freq_dec19m else 0 end)/sum(case when score_flag_dec19m = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }
  measure: tp_sev_pred_dec19m {
    type: number
    sql: sum(case when score_flag_dec19m = 1 then predicted_tp_sev_dec19m else 0 end)/sum(case when score_flag_dec19m = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: tp_bc_pred_dec19m {
    type: number
    sql: ${tp_freq_pred_dec19m}*${tp_sev_pred_dec19m};;
    value_format: "#,##0"
  }



  measure: pi_freq_pred_dec19m {
    type: number
    sql: sum(case when score_flag_dec19m = 1 then predicted_pi_freq_dec19m else 0 end)/sum(case when score_flag_dec19m = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }
  measure: pi_sev_pred_dec19m {
    type: number
    sql: sum(case when score_flag_dec19m = 1 then predicted_pi_sev_dec19m else 0 end)/sum(case when score_flag_dec19m = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: pi_bc_pred_dec19m {
    type: number
    sql: ${pi_freq_pred_dec19m}*${pi_sev_pred_dec19m};;
    value_format: "#,##0"
  }

  measure: ot_freq_pred_dec19m {
    type: number
    sql: sum(case when score_flag_dec19m = 1 then predicted_ot_freq_dec19m else 0 end)/sum(case when score_flag_dec19m = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }
  measure: ot_sev_pred_dec19m {
    type: number
    sql: sum(case when score_flag_dec19m = 1 then predicted_ot_sev_dec19m else 0 end)/sum(case when score_flag_dec19m = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: ot_bc_pred_dec19m {
    type: number
    sql: ${ot_freq_pred_dec19m}*${ot_sev_pred_dec19m};;
    value_format: "#,##0"
  }

  measure: ws_freq_pred_dec19m {
    type: number
    sql: sum(case when score_flag_dec19m = 1 then predicted_ws_freq_dec19m else 0 end)/sum(case when score_flag_dec19m = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }
  measure: ws_sev_pred_dec19m {
    type: number
    sql: sum(case when score_flag_dec19m = 1 then predicted_ws_sev_dec19m else 0 end)/sum(case when score_flag_dec19m = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: ws_bc_pred_dec19m {
    type: number
    sql: ${ws_freq_pred_dec19m}*${ws_sev_pred_dec19m};;
    value_format: "#,##0"
  }

  measure: total_bc_pred_dec19m {
    type: number
    sql: ${ad_bc_pred_dec19m}+${tp_bc_pred_dec19m}+${ot_bc_pred_dec19m}+${pi_bc_pred_dec19m}+${ws_bc_pred_dec19m};;
    value_format: "#,##0"
  }

  measure: total_lr_pred_dec19m {
    type: number
    sql: (${ad_bc_pred_dec19m}+${tp_bc_pred_dec19m}+${ot_bc_pred_dec19m}+${pi_bc_pred_dec19m}+${ws_bc_pred_dec19m})/${average_earned_prem};;
    value_format: "0%"
  }










  measure: ad_freq_pred_cdl_models_adj {
    type: number
    sql: sum(case when score_flag_cdl_models = 1 AND score_flag_cdl_residuals = 1 then predicted_ad_freq_initialcdlmodels_adj else 0 end)/sum(case when score_flag_cdl_models = 1 AND score_flag_cdl_residuals = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }

  measure: ad_sev_pred_cdl_models_adj {
    type: number
    sql: sum(case when score_flag_cdl_models = 1 AND score_flag_cdl_residuals = 1 then predicted_ad_sev_initialcdlmodels_adj else 0 end)/sum(case when score_flag_cdl_models = 1 AND score_flag_cdl_residuals = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }

  measure: ad_bc_pred_cdl_models_adj {
    type: number
    sql: ${ad_freq_pred_cdl_models_adj}*${ad_sev_pred_cdl_models_adj};;
    value_format: "#,##0"
  }




  measure: tpo_freq_pred_cdl_models_adj {
    type: number
    sql: sum(case when score_flag_cdl_models = 1 AND score_flag_cdl_residuals = 1 then predicted_tpo_freq_initialcdlmodels_adj else 0 end)/sum(case when score_flag_cdl_models = 1 AND score_flag_cdl_residuals = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }

  measure: tpo_sev_pred_cdl_models_adj {
    type: number
    sql: sum(case when score_flag_cdl_models = 1 AND score_flag_cdl_residuals = 1 then predicted_tpo_sev_initialcdlmodels_adj else 0 end)/sum(case when score_flag_cdl_models = 1 AND score_flag_cdl_residuals = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }

  measure: tpo_bc_pred_cdl_models_adj {
    type: number
    sql: ${tpo_freq_pred_cdl_models_adj}*${tpo_sev_pred_cdl_models_adj};;
    value_format: "#,##0"
  }




  measure: tpc_freq_pred_cdl_models_adj {
    type: number
    sql: sum(case when score_flag_cdl_models = 1 AND score_flag_cdl_residuals = 1 then predicted_tpc_freq_initialcdlmodels_adj else 0 end)/sum(case when score_flag_cdl_models = 1 AND score_flag_cdl_residuals = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }

  measure: tpc_sev_pred_cdl_models_adj {
    type: number
    sql: sum(case when score_flag_cdl_models = 1 AND score_flag_cdl_residuals = 1 then predicted_tpc_sev_initialcdlmodels_adj else 0 end)/sum(case when score_flag_cdl_models = 1 AND score_flag_cdl_residuals = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }

  measure: tpc_bc_pred_cdl_models_adj {
    type: number
    sql: ${tpc_freq_pred_cdl_models_adj}*${tpc_sev_pred_cdl_models_adj};;
    value_format: "#,##0"
  }



  measure: pi_freq_pred_cdl_models_adj {
    type: number
    sql: sum(case when score_flag_cdl_models = 1 AND score_flag_cdl_residuals = 1 then predicted_pi_freq_initialcdlmodels_adj else 0 end)/sum(case when score_flag_cdl_models = 1 AND score_flag_cdl_residuals = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }

  measure: pi_sev_pred_cdl_models_adj {
    type: number
    sql: sum(case when score_flag_cdl_models = 1 AND score_flag_cdl_residuals = 1 then predicted_pi_sev_initialcdlmodels_adj else 0 end)/sum(case when score_flag_cdl_models = 1 AND score_flag_cdl_residuals = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }

  measure: pi_bc_pred_cdl_models_adj {
    type: number
    sql: ${pi_freq_pred_cdl_models_adj}*${pi_sev_pred_cdl_models_adj};;
    value_format: "#,##0"
  }



  measure: ot_freq_pred_cdl_models_adj {
    type: number
    sql: sum(case when score_flag_cdl_models = 1 AND score_flag_cdl_residuals = 1 then predicted_ot_freq_initialcdlmodels_adj else 0 end)/sum(case when score_flag_cdl_models = 1 AND score_flag_cdl_residuals = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }

  measure: ot_sev_pred_cdl_models_adj {
    type: number
    sql: sum(case when score_flag_cdl_models = 1 AND score_flag_cdl_residuals = 1 then predicted_ot_sev_initialcdlmodels_adj else 0 end)/sum(case when score_flag_cdl_models = 1 AND score_flag_cdl_residuals = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }

  measure: ot_bc_pred_cdl_models_adj {
    type: number
    sql: ${ot_freq_pred_cdl_models_adj}*${ot_sev_pred_cdl_models_adj};;
    value_format: "#,##0"
  }



  measure: ws_freq_pred_cdl_models_adj {
    type: number
    sql: sum(case when score_flag_cdl_models = 1 AND score_flag_cdl_residuals = 1 then predicted_ws_freq_initialcdlmodels_adj else 0 end)/sum(case when score_flag_cdl_models = 1 AND score_flag_cdl_residuals = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }

  measure: ws_sev_pred_cdl_models_adj {
    type: number
    sql: sum(case when score_flag_cdl_models = 1 AND score_flag_cdl_residuals = 1 then predicted_ws_sev_initialcdlmodels_adj else 0 end)/sum(case when score_flag_cdl_models = 1 AND score_flag_cdl_residuals = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }

  measure: ws_bc_pred_cdl_models_adj {
    type: number
    sql: ${ws_freq_pred_cdl_models_adj}*${ws_sev_pred_cdl_models_adj};;
    value_format: "#,##0"
  }



  measure: lpi_freq_pred_cdl_models_adj {
    type: number
    sql: sum(case when score_flag_cdl_models = 1 AND score_flag_cdl_residuals = 1 then predicted_lpi_freq_initialcdlmodels_adj else 0 end)/sum(case when score_flag_cdl_models = 1 AND score_flag_cdl_residuals = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }

  measure: lpi_sev_pred_cdl_models_adj {
    type: number
    sql: sum(case when score_flag_cdl_models = 1 AND score_flag_cdl_residuals = 1 then predicted_lpi_sev_initialcdlmodels_adj else 0 end)/sum(case when score_flag_cdl_models = 1 AND score_flag_cdl_residuals = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }

  measure: lpi_bc_pred_cdl_models_adj {
    type: number
    sql: ${lpi_freq_pred_cdl_models_adj}*${lpi_sev_pred_cdl_models_adj};;
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
