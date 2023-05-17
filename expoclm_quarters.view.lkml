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


    (case when a.ncdp = 'N' then b.predicted_ad_freq_an else b.predicted_ad_freq_ap end)*evy*aug18sc.AD_F* 0.96  as predicted_ad_freq_aug18,
    (case when a.ncdp = 'N' then b.predicted_ad_sev_an else b.predicted_ad_sev_ap end)*evy*aug18sc.AD_S* 1.081   as predicted_ad_sev_aug18,
    (case when a.ncdp = 'N' then b.predicted_pi_freq_an else b.predicted_pi_freq_ap end)*evy*aug18sc.PI_F*1.07   as predicted_pi_freq_aug18,
    (case when a.ncdp = 'N' then b.predicted_pi_sev_an else b.predicted_pi_sev_ap end)*evy*aug18sc.PI_S*0.95     as predicted_pi_sev_aug18,
    (case when a.ncdp = 'N' then b.predicted_tpd_freq_an else b.predicted_tpd_freq_ap end)*evy*aug18sc.TP_F      as predicted_tp_freq_aug18,
    (case when a.ncdp = 'N' then b.predicted_tpd_sev_an else b.predicted_tpd_sev_ap end)*evy*aug18sc.TP_S*1.02   as predicted_tp_sev_aug18,
    (case when a.ncdp = 'N' then b.predicted_ot_freq_an else b.predicted_ot_freq_ap end)*evy*aug18sc.OT_F        as predicted_ot_freq_aug18,
    (case when a.ncdp = 'N' then b.predicted_ot_sev_an else b.predicted_ot_sev_ap end)*evy*aug18sc.OT_S          as predicted_ot_sev_aug18,
    (case when a.ncdp = 'N' then b.predicted_ws_freq_an else b.predicted_ws_freq_ap end)*evy*aug18sc.WS_F *0.9   as predicted_ws_freq_aug18,
    (case when a.ncdp = 'N' then b.predicted_ws_sev_an else b.predicted_ws_sev_ap end)*evy*aug18sc.WS_S*1.035    as predicted_ws_sev_aug18,

    case when ncdp = 'N' then jcred.predicted_ad_freq_an*jcredsc.AD_F else jcred.predicted_ad_freq_ap*jcredsc.AD_F end *evy    *1.05* 0.96 as predicted_ad_freq_jul19cred,
    case when ncdp = 'N' then jcred.predicted_ad_sev_an*jcredsc.AD_S else jcred.predicted_ad_sev_ap*jcredsc.AD_S end *evy      *1.16* 1.06 as predicted_ad_sev_jul19cred,
    case when ncdp = 'N' then jcred.predicted_pi_freq_an*jcredsc.PI_F else jcred.predicted_pi_freq_ap*jcredsc.PI_F end *evy    *0.99*1.07 as predicted_pi_freq_jul19cred,
    case when ncdp = 'N' then jcred.predicted_pi_sev_an*jcredsc.PI_S else jcred.predicted_pi_sev_ap*jcredsc.PI_S end *evy      *0.87       as predicted_pi_sev_jul19cred,
    case when ncdp = 'N' then jcred.predicted_tpd_freq_an*jcredsc.TP_F else jcred.predicted_tpd_freq_ap*jcredsc.TP_F end *evy  *0.92*1.016 as predicted_tp_freq_jul19cred,
    case when ncdp = 'N' then jcred.predicted_tpd_sev_an*jcredsc.TP_S else jcred.predicted_tpd_sev_ap*jcredsc.TP_S end *evy    *1.23*1.02  as predicted_tp_sev_jul19cred,
    case when ncdp = 'N' then jcred.predicted_ot_freq_an*jcredsc.OT_F else jcred.predicted_ot_freq_ap*jcredsc.OT_F end *evy    *0.90       as predicted_ot_freq_jul19cred,
    case when ncdp = 'N' then jcred.predicted_ot_sev_an*jcredsc.OT_S else jcred.predicted_ot_sev_ap*jcredsc.OT_S end *evy      *2.02       as predicted_ot_sev_jul19cred,
    case when ncdp = 'N' then jcred.predicted_ws_freq_an*jcredsc.WS_F else jcred.predicted_ws_freq_ap*jcredsc.WS_F end *evy    *0.895 *0.9 as predicted_ws_freq_jul19cred,
    case when ncdp = 'N' then jcred.predicted_ws_sev_an*jcredsc.WS_S else jcred.predicted_ws_sev_ap*jcredsc.WS_S end *evy      *1.22 *1.035 as predicted_ws_sev_jul19cred,

    case when ncdp = 'N' then jul18nm.predicted_ad_freq_an else jul18nm.predicted_ad_freq_ap end *evy    *1.00       as predicted_ad_freq_jul18nm,
    case when ncdp = 'N' then jul18nm.predicted_ad_sev_an else jul18nm.predicted_ad_sev_ap end *evy      *1.16       as predicted_ad_sev_jul18nm,
    case when ncdp = 'N' then jul18nm.predicted_pi_freq_an else jul18nm.predicted_pi_freq_ap end *evy    *1.045      as predicted_pi_freq_jul18nm,
    case when ncdp = 'N' then jul18nm.predicted_pi_sev_an else jul18nm.predicted_pi_sev_ap end *evy      *0.80       as predicted_pi_sev_jul18nm,
    case when ncdp = 'N' then jul18nm.predicted_tpd_freq_an else jul18nm.predicted_tpd_freq_ap end *evy  *0.86       as predicted_tp_freq_jul18nm,
    case when ncdp = 'N' then jul18nm.predicted_tpd_sev_an else jul18nm.predicted_tpd_sev_ap end *evy    *1.12       as predicted_tp_sev_jul18nm,
    case when ncdp = 'N' then jul18nm.predicted_ot_freq_an else jul18nm.predicted_ot_freq_ap end *evy    *1.10       as predicted_ot_freq_jul18nm,
    case when ncdp = 'N' then jul18nm.predicted_ot_sev_an else jul18nm.predicted_ot_sev_ap end *evy      *1.67       as predicted_ot_sev_jul18nm,
    case when ncdp = 'N' then jul18nm.predicted_ws_freq_an else jul18nm.predicted_ws_freq_ap end *evy    *0.90       as predicted_ws_freq_jul18nm,
    case when ncdp = 'N' then jul18nm.predicted_ws_sev_an else jul18nm.predicted_ws_sev_ap end *evy      *1.00*1.24  as predicted_ws_sev_jul18nm,

    case when ncdp = 'N' then dec19nm.predicted_ad_freq_an_nm_dec19 else dec19nm.predicted_ad_freq_ap_nm_dec19 end *evy *1.043         as predicted_ad_freq_dec19nm,
    case when ncdp = 'N' then dec19nm.predicted_ad_sev_an_nm_dec19 else dec19nm.predicted_ad_sev_ap_nm_dec19 end *evy *1.868        as predicted_ad_sev_dec19nm,
    case when ncdp = 'N' then dec19nm.predicted_pi_freq_an_nm_dec19 else dec19nm.predicted_pi_freq_ap_nm_dec19 end *evy *0.909         as predicted_pi_freq_dec19nm,
    case when ncdp = 'N' then dec19nm.predicted_pi_sev_an_nm_dec19 else dec19nm.predicted_pi_sev_ap_nm_dec19 end *evy *0.932          as predicted_pi_sev_dec19nm,
    case when ncdp = 'N' then dec19nm.predicted_tp_freq_an_nm_dec19 else dec19nm.predicted_tp_freq_ap_nm_dec19 end *evy *1.023          as predicted_tp_freq_dec19nm,
    case when ncdp = 'N' then dec19nm.predicted_tp_sev_an_nm_dec19 else dec19nm.predicted_tp_sev_ap_nm_dec19 end *evy *1.652            as predicted_tp_sev_dec19nm,
    case when ncdp = 'N' then dec19nm.predicted_ot_freq_an_nm_dec19 else dec19nm.predicted_ot_freq_ap_nm_dec19 end *evy *1.572         as predicted_ot_freq_dec19nm,
    case when ncdp = 'N' then dec19nm.predicted_ot_sev_an_nm_dec19 else dec19nm.predicted_ot_sev_ap_nm_dec19 end *evy *2.007           as predicted_ot_sev_dec19nm,
    case when ncdp = 'N' then dec19nm.predicted_ws_freq_an_nm_dec19 else dec19nm.predicted_ws_freq_ap_nm_dec19 end *evy *1.043         as predicted_ws_freq_dec19nm,
    case when ncdp = 'N' then dec19nm.predicted_ws_sev_an_nm_dec19 else dec19nm.predicted_ws_sev_ap_nm_dec19 end *evy *1.396         as predicted_ws_sev_dec19nm,

    case when ncdp = 'N' then dec19m.predicted_ad_freq_an_m_dec19 else dec19m.predicted_ad_freq_ap_m_dec19 end *evy *1.049         as predicted_ad_freq_dec19m,
    case when ncdp = 'N' then dec19m.predicted_ad_sev_an_m_dec19 else dec19m.predicted_ad_sev_ap_m_dec19 end *evy *1.87          as predicted_ad_sev_dec19m,
    case when ncdp = 'N' then dec19m.predicted_pi_freq_an_m_dec19 else dec19m.predicted_pi_freq_ap_m_dec19 end *evy *0.905           as predicted_pi_freq_dec19m,
    case when ncdp = 'N' then dec19m.predicted_pi_sev_an_m_dec19 else dec19m.predicted_pi_sev_ap_m_dec19 end *evy *0.933           as predicted_pi_sev_dec19m,
    case when ncdp = 'N' then dec19m.predicted_tp_freq_an_m_dec19 else dec19m.predicted_tp_freq_ap_m_dec19 end *evy *1.013         as predicted_tp_freq_dec19m,
    case when ncdp = 'N' then dec19m.predicted_tp_sev_an_m_dec19 else dec19m.predicted_tp_sev_ap_m_dec19 end *evy *1.662          as predicted_tp_sev_dec19m,
    case when ncdp = 'N' then dec19m.predicted_ot_freq_an_m_dec19 else dec19m.predicted_ot_freq_ap_m_dec19 end *evy *1.505          as predicted_ot_freq_dec19m,
    case when ncdp = 'N' then dec19m.predicted_ot_sev_an_m_dec19 else dec19m.predicted_ot_sev_ap_m_dec19 end *evy *2.043           as predicted_ot_sev_dec19m,
    case when ncdp = 'N' then dec19m.predicted_ws_freq_an_m_dec19 else dec19m.predicted_ws_freq_ap_m_dec19 end *evy *1.043         as predicted_ws_freq_dec19m,
    case when ncdp = 'N' then dec19m.predicted_ws_sev_an_m_dec19 else dec19m.predicted_ws_sev_ap_m_dec19 end *evy *1.396          as predicted_ws_sev_dec19m,

    case when ncdp = 'N' then jul19nm.predicted_ad_freq_an else jul19nm.predicted_ad_freq_ap end *evy *1.107         as predicted_ad_freq_jul19nm,
    case when ncdp = 'N' then jul19nm.predicted_ad_sev_an else jul19nm.predicted_ad_sev_ap end *evy *1.994          as predicted_ad_sev_jul19nm,
    case when ncdp = 'N' then jul19nm.predicted_pi_freq_an else jul19nm.predicted_pi_freq_ap end *evy *0.933         as predicted_pi_freq_jul19nm,
    case when ncdp = 'N' then jul19nm.predicted_pi_sev_an else jul19nm.predicted_pi_sev_ap end *evy *0.877          as predicted_pi_sev_jul19nm,
    case when ncdp = 'N' then jul19nm.predicted_tpd_freq_an else jul19nm.predicted_tpd_freq_ap end *evy *1.039        as predicted_tp_freq_jul19nm,
    case when ncdp = 'N' then jul19nm.predicted_tpd_sev_an else jul19nm.predicted_tpd_sev_ap end *evy *1.707           as predicted_tp_sev_jul19nm,
    case when ncdp = 'N' then jul19nm.predicted_ot_freq_an else jul19nm.predicted_ot_freq_ap end *evy *3.043         as predicted_ot_freq_jul19nm,
    case when ncdp = 'N' then jul19nm.predicted_ot_sev_an else jul19nm.predicted_ot_sev_ap end *evy *1.525          as predicted_ot_sev_jul19nm,
    case when ncdp = 'N' then jul19nm.predicted_ws_freq_an else jul19nm.predicted_ws_freq_ap end *evy        as predicted_ws_freq_jul19nm,
    case when ncdp = 'N' then jul19nm.predicted_ws_sev_an else jul19nm.predicted_ws_sev_ap end *evy * 1.478        as predicted_ws_sev_jul19nm,

    case when ncdp = 'N' then jcred.predicted_ad_freq_an else jcred.predicted_ad_freq_ap end *evy *0.94         as predicted_ad_freq_jul19cred_new,
    case when ncdp = 'N' then jcred.predicted_ad_sev_an else jcred.predicted_ad_sev_ap end *evy   *1.64         as predicted_ad_sev_jul19cred_new,
    case when ncdp = 'N' then jcred.predicted_pi_freq_an else jcred.predicted_pi_freq_ap end *evy *1.02         as predicted_pi_freq_jul19cred_new,
    case when ncdp = 'N' then jcred.predicted_pi_sev_an else jcred.predicted_pi_sev_ap end *evy   *0.87         as predicted_pi_sev_jul19cred_new,
    case when ncdp = 'N' then jcred.predicted_tpd_freq_an else jcred.predicted_tpd_freq_ap end *evy *0.99         as predicted_tp_freq_jul19cred_new,
    case when ncdp = 'N' then jcred.predicted_tpd_sev_an else jcred.predicted_tpd_sev_ap end *evy   *1.57         as predicted_tp_sev_jul19cred_new,
    case when ncdp = 'N' then jcred.predicted_ot_freq_an else jcred.predicted_ot_freq_ap end *evy *1.27         as predicted_ot_freq_jul19cred_new,
    case when ncdp = 'N' then jcred.predicted_ot_sev_an else jcred.predicted_ot_sev_ap end *evy   *2.02         as predicted_ot_sev_jul19cred_new,
    case when ncdp = 'N' then jcred.predicted_ws_freq_an else jcred.predicted_ws_freq_ap end *evy *0.90         as predicted_ws_freq_jul19cred_new,
    case when ncdp = 'N' then jcred.predicted_ws_sev_an else jcred.predicted_ws_sev_ap end *evy   *1.42        as predicted_ws_sev_jul19cred_new,



    case when b.dup = 1 and jcred.dup=1 and jul18nm.dup = 1 then 1 else 0 end as match_flag,

    case when a.quote_id = dec19nm.quote_id then 1 else 0 end as score_flag_dec19nm,

    case when a.quote_id = dec19m.quote_id then 1 else 0 end as score_flag_dec19m,

    case when a.quote_id = jul19nm.quote_id then 1 else 0 end as score_flag_jul19nm,

    case when a.quote_id = jcred.quote_id then 1 else 0 end as score_flag_jul19cred_new,

    date_trunc('quarter',a.exposure_start) as quarter,
    uwyr



  from
            expoclm_quarters a
  left join
            (select
               *,
               row_number() over(partition by quote_id) as dup
             from uncalibrated_scores_aug18
            ) b
            on a.quote_id = b.quote_id and b.dup = 1

  left join
            (select
               *,
               row_number() over(partition by quote_id) as dup
             from aapricing.uncalibrated_scores_jul19_cred
            ) jcred
            on a.quote_id = jcred.quote_id and jcred.dup = 1

 left join
            (select
               *,
               row_number() over(partition by quote_id) as dup
             from aapricing.uncalibrated_scores_jul18
            ) jul18nm
            on a.quote_id = jul18nm.quote_id and jul18nm.dup = 1

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
             from aapricing.uncalibrated_scores_nmjul19
            ) jul19nm
            on a.quote_id = jul19nm.quote_id and jul19nm.dup = 1


    left join
        motor_model_calibrations aug18sc
        on aug18sc.policy_start_month = date_trunc('month',a.termincep) and aug18sc.model='August_18_pricing' and aug18sc.end = '9999-01-01'

    left join
                motor_model_calibrations jcredsc
                on jcredsc.policy_start_month = date_trunc('month',a.termincep) and jcredsc.model='July_19_Cred_Pric' and jcredsc.end = '9999-01-01'

    LEFT JOIN
          pattern_to_ultimate p
          ON (months_between (trunc (SYSDATE,'quarter'),trunc (a.exposure_start,'quarter')) / 3)-1 = p.dev_quarter


      where date_trunc('quarter',a.exposure_start) < date_trunc('quarter',to_date(sysdate))
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

  measure: total_lr_pred_aug18 {
    type: number
    sql: (${ad_bc_pred_aug18}+${tp_bc_pred_aug18}+${ot_bc_pred_aug18}+${pi_bc_pred_aug18}+${ws_bc_pred_aug18})/${average_earned_prem};;
    value_format: "0%"
  }

  measure: average_earned_prem {
    type: number
    sql: sum(eprem)/nullif(sum(evy),0);;
    value_format: "#,##0"
  }

  measure: ad_freq_pred_jul19cred {
    type: number
    sql: sum(case when match_flag = 1 then predicted_ad_freq_jul19cred else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }

  measure: ad_sev_pred_jul19cred {
    type: number
    sql: sum(case when match_flag = 1 then predicted_ad_sev_jul19cred else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: ad_bc_pred_jul19cred {
    type: number
    sql: ${ad_freq_pred_jul19cred}*${ad_sev_pred_jul19cred};;
    value_format: "#,##0"
  }


  measure: tp_freq_pred_jul19cred {
    type: number
    sql: sum(case when match_flag = 1 then predicted_tp_freq_jul19cred else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }
  measure: tp_sev_pred_jul19cred {
    type: number
    sql: sum(case when match_flag = 1 then predicted_tp_sev_jul19cred else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: tp_bc_pred_jul19cred {
    type: number
    sql: ${tp_freq_pred_jul19cred}*${tp_sev_pred_jul19cred};;
    value_format: "#,##0"
  }



  measure: pi_freq_pred_jul19cred {
    type: number
    sql: sum(case when match_flag = 1 then predicted_pi_freq_jul19cred else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }
  measure: pi_sev_pred_jul19cred {
    type: number
    sql: sum(case when match_flag = 1 then predicted_pi_sev_jul19cred else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: pi_bc_pred_jul19cred {
    type: number
    sql: ${pi_freq_pred_jul19cred}*${pi_sev_pred_jul19cred};;
    value_format: "#,##0"
  }

  measure: ot_freq_pred_jul19cred {
    type: number
    sql: sum(case when match_flag = 1 then predicted_ot_freq_jul19cred else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }
  measure: ot_sev_pred_jul19cred {
    type: number
    sql: sum(case when match_flag = 1 then predicted_ot_sev_jul19cred else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: ot_bc_pred_jul19cred {
    type: number
    sql: ${ot_freq_pred_jul19cred}*${ot_sev_pred_jul19cred};;
    value_format: "#,##0"
  }

  measure: ws_freq_pred_jul19cred {
    type: number
    sql: sum(case when match_flag = 1 then predicted_ws_freq_jul19cred else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }
  measure: ws_sev_pred_jul19cred {
    type: number
    sql: sum(case when match_flag = 1 then predicted_ws_sev_jul19cred else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: ws_bc_pred_jul19cred {
    type: number
    sql: ${ws_freq_pred_jul19cred}*${ws_sev_pred_jul19cred};;
    value_format: "#,##0"
  }

  measure: total_bc_pred_jul19cred {
    type: number
    sql: ${ad_bc_pred_jul19cred}+${tp_bc_pred_jul19cred}+${ot_bc_pred_jul19cred}+${pi_bc_pred_jul19cred}+${ws_bc_pred_jul19cred};;
    value_format: "#,##0"
  }

  measure: total_lr_pred_jul19cred {
    type: number
    sql: (${ad_bc_pred_jul19cred}+${tp_bc_pred_jul19cred}+${ot_bc_pred_jul19cred}+${pi_bc_pred_jul19cred}+${ws_bc_pred_jul19cred})/${average_earned_prem};;
    value_format: "0%"
  }







  measure: ad_freq_pred_jul18nm {
    type: number
    sql: sum(case when match_flag = 1 then predicted_ad_freq_jul18nm else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }

  measure: ad_sev_pred_jul18nm {
    type: number
    sql: sum(case when match_flag = 1 then predicted_ad_sev_jul18nm else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: ad_bc_pred_jul18nm {
    type: number
    sql: ${ad_freq_pred_jul18nm}*${ad_sev_pred_jul18nm};;
    value_format: "#,##0"
  }


  measure: tp_freq_pred_jul18nm {
    type: number
    sql: sum(case when match_flag = 1 then predicted_tp_freq_jul18nm else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }
  measure: tp_sev_pred_jul18nm {
    type: number
    sql: sum(case when match_flag = 1 then predicted_tp_sev_jul18nm else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: tp_bc_pred_jul18nm {
    type: number
    sql: ${tp_freq_pred_jul18nm}*${tp_sev_pred_jul18nm};;
    value_format: "#,##0"
  }



  measure: pi_freq_pred_jul18nm {
    type: number
    sql: sum(case when match_flag = 1 then predicted_pi_freq_jul18nm else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }
  measure: pi_sev_pred_jul18nm {
    type: number
    sql: sum(case when match_flag = 1 then predicted_pi_sev_jul18nm else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: pi_bc_pred_jul18nm {
    type: number
    sql: ${pi_freq_pred_jul18nm}*${pi_sev_pred_jul18nm};;
    value_format: "#,##0"
  }

  measure: ot_freq_pred_jul18nm {
    type: number
    sql: sum(case when match_flag = 1 then predicted_ot_freq_jul18nm else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }
  measure: ot_sev_pred_jul18nm {
    type: number
    sql: sum(case when match_flag = 1 then predicted_ot_sev_jul18nm else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: ot_bc_pred_jul18nm {
    type: number
    sql: ${ot_freq_pred_jul18nm}*${ot_sev_pred_jul18nm};;
    value_format: "#,##0"
  }

  measure: ws_freq_pred_jul18nm {
    type: number
    sql: sum(case when match_flag = 1 then predicted_ws_freq_jul18nm else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }
  measure: ws_sev_pred_jul18nm {
    type: number
    sql: sum(case when match_flag = 1 then predicted_ws_sev_jul18nm else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: ws_bc_pred_jul18nm {
    type: number
    sql: ${ws_freq_pred_jul18nm}*${ws_sev_pred_jul18nm};;
    value_format: "#,##0"
  }

  measure: total_bc_pred_jul18nm {
    type: number
    sql: ${ad_bc_pred_jul18nm}+${tp_bc_pred_jul18nm}+${ot_bc_pred_jul18nm}+${pi_bc_pred_jul18nm}+${ws_bc_pred_jul18nm};;
    value_format: "#,##0"
  }

  measure: total_lr_pred_jul18nm {
    type: number
    sql: (${ad_bc_pred_jul18nm}+${tp_bc_pred_jul18nm}+${ot_bc_pred_jul18nm}+${pi_bc_pred_jul18nm}+${ws_bc_pred_jul18nm})/${average_earned_prem};;
    value_format: "0%"
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








  measure: ad_freq_pred_jul19nm {
    type: number
    sql: sum(case when score_flag_jul19nm = 1 then predicted_ad_freq_jul19nm else 0 end)/sum(case when score_flag_jul19nm = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }

  measure: ad_sev_pred_jul19nm {
    type: number
    sql: sum(case when score_flag_jul19nm = 1 then predicted_ad_sev_jul19nm else 0 end)/sum(case when score_flag_jul19nm = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: ad_bc_pred_jul19nm {
    type: number
    sql: ${ad_freq_pred_jul19nm}*${ad_sev_pred_jul19nm};;
    value_format: "#,##0"
  }


  measure: tp_freq_pred_jul19nm {
    type: number
    sql: sum(case when score_flag_jul19nm = 1 then predicted_tp_freq_jul19nm else 0 end)/sum(case when score_flag_jul19nm = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }
  measure: tp_sev_pred_jul19nm {
    type: number
    sql: sum(case when score_flag_jul19nm = 1 then predicted_tp_sev_jul19nm else 0 end)/sum(case when score_flag_jul19nm = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: tp_bc_pred_jul19nm {
    type: number
    sql: ${tp_freq_pred_jul19nm}*${tp_sev_pred_jul19nm};;
    value_format: "#,##0"
  }



  measure: pi_freq_pred_jul19nm {
    type: number
    sql: sum(case when score_flag_jul19nm = 1 then predicted_pi_freq_jul19nm else 0 end)/sum(case when score_flag_jul19nm = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }
  measure: pi_sev_pred_jul19nm {
    type: number
    sql: sum(case when score_flag_jul19nm = 1 then predicted_pi_sev_jul19nm else 0 end)/sum(case when score_flag_jul19nm = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: pi_bc_pred_jul19nm {
    type: number
    sql: ${pi_freq_pred_jul19nm}*${pi_sev_pred_jul19nm};;
    value_format: "#,##0"
  }

  measure: ot_freq_pred_jul19nm {
    type: number
    sql: sum(case when score_flag_jul19nm = 1 then predicted_ot_freq_jul19nm else 0 end)/sum(case when score_flag_jul19nm = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }
  measure: ot_sev_pred_jul19nm {
    type: number
    sql: sum(case when score_flag_jul19nm = 1 then predicted_ot_sev_jul19nm else 0 end)/sum(case when score_flag_jul19nm = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: ot_bc_pred_jul19nm {
    type: number
    sql: ${ot_freq_pred_jul19nm}*${ot_sev_pred_jul19nm};;
    value_format: "#,##0"
  }

  measure: ws_freq_pred_jul19nm {
    type: number
    sql: sum(case when score_flag_jul19nm = 1 then predicted_ws_freq_jul19nm else 0 end)/sum(case when score_flag_jul19nm = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }
  measure: ws_sev_pred_jul19nm {
    type: number
    sql: sum(case when  score_flag_jul19nm = 1 then predicted_ws_sev_jul19nm else 0 end)/sum(case when  score_flag_jul19nm = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: ws_bc_pred_jul19nm {
    type: number
    sql: ${ws_freq_pred_jul19nm}*${ws_sev_pred_jul19nm};;
    value_format: "#,##0"
  }

  measure: total_bc_pred_jul19nm {
    type: number
    sql: ${ad_bc_pred_jul19nm}+${tp_bc_pred_jul19nm}+${ot_bc_pred_jul19nm}+${pi_bc_pred_jul19nm}+${ws_bc_pred_jul19nm};;
    value_format: "#,##0"
  }

  measure: total_lr_pred_jul19nm {
    type: number
    sql: (${ad_bc_pred_jul19nm}+${tp_bc_pred_jul19nm}+${ot_bc_pred_jul19nm}+${pi_bc_pred_jul19nm}+${ws_bc_pred_jul19nm})/${average_earned_prem};;
    value_format: "0%"
  }









  measure: ad_freq_pred_jul19cred_new {
    type: number
    sql: sum(case when match_flag = 1 AND score_flag_jul19cred_new = 1 then predicted_ad_freq_jul19cred_new else 0 end)/sum(case when match_flag = 1 AND score_flag_jul19cred_new = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }

  measure: ad_sev_pred_jul19cred_new {
    type: number
    sql: sum(case when match_flag = 1 AND score_flag_jul19cred_new = 1 then predicted_ad_sev_jul19cred_new else 0 end)/sum(case when match_flag = 1 AND score_flag_jul19cred_new = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: ad_bc_pred_jul19cred_new {
    type: number
    sql: ${ad_freq_pred_jul19cred_new}*${ad_sev_pred_jul19cred_new};;
    value_format: "#,##0"
  }


  measure: tp_freq_pred_jul19cred_new {
    type: number
    sql: sum(case when match_flag = 1 AND score_flag_jul19cred_new = 1 then predicted_tp_freq_jul19cred_new else 0 end)/sum(case when match_flag = 1 AND score_flag_jul19cred_new = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }
  measure: tp_sev_pred_jul19cred_new {
    type: number
    sql: sum(case when match_flag = 1 AND score_flag_jul19cred_new = 1 then predicted_tp_sev_jul19cred_new else 0 end)/sum(case when match_flag = 1 AND score_flag_jul19cred_new = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: tp_bc_pred_jul19cred_new {
    type: number
    sql: ${tp_freq_pred_jul19cred_new}*${tp_sev_pred_jul19cred_new};;
    value_format: "#,##0"
  }



  measure: pi_freq_pred_jul19cred_new {
    type: number
    sql: sum(case when match_flag = 1 AND score_flag_jul19cred_new = 1 then predicted_pi_freq_jul19cred_new else 0 end)/sum(case when match_flag = 1 AND score_flag_jul19cred_new = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }
  measure: pi_sev_pred_jul19cred_new {
    type: number
    sql: sum(case when match_flag = 1 AND score_flag_jul19cred_new = 1 then predicted_pi_sev_jul19cred_new else 0 end)/sum(case when match_flag = 1 AND score_flag_jul19cred_new = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: pi_bc_pred_jul19cred_new {
    type: number
    sql: ${pi_freq_pred_jul19cred_new}*${pi_sev_pred_jul19cred_new};;
    value_format: "#,##0"
  }

  measure: ot_freq_pred_jul19cred_new {
    type: number
    sql: sum(case when match_flag = 1 AND score_flag_jul19cred_new = 1 then predicted_ot_freq_jul19cred_new else 0 end)/sum(case when match_flag = 1 AND score_flag_jul19cred_new = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }
  measure: ot_sev_pred_jul19cred_new {
    type: number
    sql: sum(case when match_flag = 1 AND score_flag_jul19cred_new = 1 then predicted_ot_sev_jul19cred_new else 0 end)/sum(case when match_flag = 1 AND score_flag_jul19cred_new = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: ot_bc_pred_jul19cred_new {
    type: number
    sql: ${ot_freq_pred_jul19cred_new}*${ot_sev_pred_jul19cred_new};;
    value_format: "#,##0"
  }

  measure: ws_freq_pred_jul19cred_new {
    type: number
    sql: sum(case when match_flag = 1 AND score_flag_jul19cred_new = 1 then predicted_ws_freq_jul19cred_new else 0 end)/sum(case when match_flag = 1 AND score_flag_jul19cred_new = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }
  measure: ws_sev_pred_jul19cred_new {
    type: number
    sql: sum(case when match_flag = 1 AND score_flag_jul19cred_new = 1 then predicted_ws_sev_jul19cred_new else 0 end)/sum(case when match_flag = 1 AND score_flag_jul19cred_new = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }
  measure: ws_bc_pred_jul19cred_new {
    type: number
    sql: ${ws_freq_pred_jul19cred_new}*${ws_sev_pred_jul19cred_new};;
    value_format: "#,##0"
  }

  measure: total_bc_pred_jul19cred_new {
    type: number
    sql: ${ad_bc_pred_jul19cred_new}+${tp_bc_pred_jul19cred_new}+${ot_bc_pred_jul19cred_new}+${pi_bc_pred_jul19cred_new}+${ws_bc_pred_jul19cred_new};;
    value_format: "#,##0"
  }

  measure: total_lr_pred_jul19cred_new {
    type: number
    sql: (${ad_bc_pred_jul19cred_new}+${tp_bc_pred_jul19cred_new}+${ot_bc_pred_jul19cred_new}+${pi_bc_pred_jul19cred_new}+${ws_bc_pred_jul19cred_new})/${average_earned_prem};;
    value_format: "0%"
  }











  measure: ad_freq_pred_combined {
    type: number
    sql: sum(case when match_flag = 1 and scheme_number=103 then predicted_ad_freq_jul18nm when match_flag = 1 and scheme_number=102 then predicted_ad_freq_jul19cred else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }

  measure: ad_sev_pred_combined {
    type: number
    sql: sum(case when match_flag = 1 and scheme_number=103 then predicted_ad_sev_jul18nm when match_flag = 1 and scheme_number=102 then predicted_ad_sev_jul19cred else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }

  measure: ad_bc_pred_combined {
    type: number
    sql: ${ad_freq_pred_combined}*${ad_sev_pred_combined};;
    value_format: "#,##0"
  }

  measure: tp_freq_pred_combined {
    type: number
    sql: sum(case when match_flag = 1 and scheme_number=103 then predicted_tp_freq_jul18nm when match_flag = 1 and scheme_number=102 then predicted_tp_freq_jul19cred else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }

  measure: tp_sev_pred_combined {
    type: number
    sql: sum(case when match_flag = 1 and scheme_number=103 then predicted_tp_sev_jul18nm when match_flag = 1 and scheme_number=102 then predicted_tp_sev_jul19cred else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }

  measure: tp_bc_pred_combined {
    type: number
    sql: ${tp_freq_pred_combined}*${tp_sev_pred_combined};;
    value_format: "#,##0"
  }

  measure: pi_freq_pred_combined {
    type: number
    sql: sum(case when match_flag = 1 and scheme_number=103 then predicted_pi_freq_jul18nm when match_flag = 1 and scheme_number=102 then predicted_pi_freq_jul19cred else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }

  measure: pi_sev_pred_combined {
    type: number
    sql: sum(case when match_flag = 1 and scheme_number=103 then predicted_pi_sev_jul18nm when match_flag = 1 and scheme_number=102 then predicted_pi_sev_jul19cred else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }

  measure: pi_bc_pred_combined {
    type: number
    sql: ${pi_freq_pred_combined}*${pi_sev_pred_combined};;
    value_format: "#,##0"
  }

  measure: ot_freq_pred_combined {
    type: number
    sql: sum(case when match_flag = 1 and scheme_number=103 then predicted_ot_freq_jul18nm when match_flag = 1 and scheme_number=102 then predicted_ot_freq_jul19cred else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }

  measure: ot_sev_pred_combined {
    type: number
    sql: sum(case when match_flag = 1 and scheme_number=103 then predicted_ot_sev_jul18nm when match_flag = 1 and scheme_number=102 then predicted_ot_sev_jul19cred else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }

  measure: ot_bc_pred_combined {
    type: number
    sql: ${ot_freq_pred_combined}*${ot_sev_pred_combined};;
    value_format: "#,##0"
  }

  measure: ws_freq_pred_combined {
    type: number
    sql: sum(case when match_flag = 1 and scheme_number=103 then predicted_ws_freq_jul18nm when match_flag = 1 and scheme_number=102 then predicted_ws_freq_jul19cred else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "0.00%"
  }

  measure: ws_sev_pred_combined {
    type: number
    sql: sum(case when match_flag = 1 and scheme_number=103 then predicted_ws_sev_jul18nm when match_flag = 1 and scheme_number=102 then predicted_ws_sev_jul19cred else 0 end)/sum(case when match_flag = 1 then evy else 0 end) ;;
    value_format: "#,##0"
  }

  measure: ws_bc_pred_combined {
    type: number
    sql: ${ws_freq_pred_combined}*${ws_sev_pred_combined};;
    value_format: "#,##0"
  }


  measure: total_bc_pred_combined {
    type: number
    sql: ${ad_bc_pred_combined}+${tp_bc_pred_combined}+${ot_bc_pred_combined}+${pi_bc_pred_combined}+${ws_bc_pred_combined};;
    value_format: "#,##0"
  }

  measure: total_lr_pred_combined {
    type: number
    sql: (${ad_bc_pred_combined}+${tp_bc_pred_combined}+${ot_bc_pred_combined}+${pi_bc_pred_combined}+${ws_bc_pred_combined})/${average_earned_prem};;
    value_format: "0%"
  }

}
