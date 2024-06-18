view: ice_claims_development {
  derived_table: {
    sql:
    SELECT a.polnum,
       scheme,
       a.renewseq,
       inception,
       uw_month,
       uw_year,
       uw_qtr,
       financial_uw_year,
      year(f_uw_start) as f_uw_year,
      year(f_uw_start) as uw_year_needed,
       to_timestamp(acc_month) AS acc_month,
       to_timestamp(acc_year) as acc_year,
       acc_qtr,
       dev_month,
       CASE
         WHEN dev_period > 0 THEN 0
         ELSE earned_premium
       END AS earned_premium,
       earned_premium_cumulative,
       CASE
         WHEN dev_period > 0 THEN 0
         ELSE exposure
       END AS exposure,
       exposure_cumulative,
       incident_date,
       settleddate,
       notificationdate,
       CASE
         WHEN dev_period > 0 THEN dev_period
         ELSE 0
       END AS dev_period_acc_month,
       CASE
         WHEN dev_period > 0 THEN dev_month
         ELSE acc_month
       END AS dev_month,
       months_between(dev_month,acc_year) AS dev_period_acc_year,
       months_between(dev_month,acc_qtr) AS dev_period_acc_qtr,
       months_between(dev_month +day(uw_year) -1,uw_year) AS dev_period_uw_year,
       months_between(dev_month,uw_qtr) AS dev_period_uw_qtr,
       months_between(dev_month,f_uw_start) AS dev_period_fuw_year,
       total_reported_count_exc_ws AS total_reported_count_exc_ws,
       total_reported_count AS total_reported_count,
       total_count_exc_ws AS total_count_exc_ws,
       total_incurred - total_incurred_exc_rec - total_paid - total_paid_exc_rec AS rec_reserves,
       ad_incurred - ad_incurred_exc_rec AS ad_incurred_recoveries,
       tp_incurred - tp_incurred_exc_rec AS tp_incurred_recoveries,
       pi_incurred - pi_incurred_exc_rec AS pi_incurred_recoveries,
       ws_incurred - ws_incurred_exc_rec AS ws_incurred_recoveries,
       ot_incurred - ot_incurred_exc_rec AS ot_incurred_recoveries,
       total_incurred - total_incurred_exc_rec AS total_incurred_recoveries,
       ad_incurred_exc_rec,
       ad_reported_count AS AD_reported,
       ad_count AS AD_Non_Nil,
       CASE
         WHEN (ad_incurred - ad_fees_incurred) > 150 THEN 1
         ELSE 0
       END AS ad_collared_count,
       ad_paid - ad_paid_exc_rec AS ad_paid_rec,
       ad_paid_exc_rec,
       CASE
         WHEN ROUND(ROUND(tp_incurred,2) - FLOOR(tp_incurred),2) = 0.81 THEN 1
         ELSE 0
       END AS TP_Std_Reserve,
       CASE
         WHEN ROUND(ROUND(ad_incurred,2) - FLOOR(ad_incurred),2) = 0.81 THEN 1
         ELSE 0
       END AS AD_Std_Reserve,
       CASE
         WHEN ROUND(ROUND(pi_incurred,2) - FLOOR(pi_incurred),2) = 0.81 THEN 1
         ELSE 0
       END AS PI_Std_Reserve,
       CASE
         WHEN ROUND(ROUND(ws_incurred,2) - FLOOR(ws_incurred),2) = 0.81 THEN 1
         ELSE 0
       END AS WS_Std_Reserve,
       CASE
         WHEN ROUND(ROUND(ot_incurred,2) - FLOOR(ot_incurred),2) = 0.81 THEN 1
         ELSE 0
       END AS OT_Std_Reserve,
       1.00 *tp_count AS TP_Count,
       1.00 *tp_chire_count AS TP_Chire_Count,
       1.00 *tp_exc_ch_count AS TP_exc_CH_Count,
       1.00 *AD_count AS AD_Count,
       1.00 *PI_count AS PI_Count,
       1.00 *WS_count AS WS_Count,
       1.00 *OT_count AS OT_Count,
       1.00 *ad_incurred AS ad_incurred,
       1.00 *ad_paid AS ad_paid,
       1.00 *tp_incurred AS tp_incurred,
       1.00 *tp_chire_incurred AS tp_chire_incurred,
       1.00 *tp_exc_CH_incurred AS tp_exc_CH_incurred,
       1.00 *tp_paid AS tp_paid,
       1.00 *tp_chire_paid AS tp_chire_paid,
       1.00 *tp_exc_CH_paid AS tp_exc_CH_paid,
       1.00 *pi_incurred AS pi_incurred,
       1.00 *pi_paid AS pi_paid,
       1.00 *ot_incurred AS ot_incurred,
       1.00 *ot_paid AS ot_paid,
       1.00 *ws_incurred AS ws_incurred,
       1.00 *ws_paid AS ws_paid,
       1.00 *capped_pi_indexed_incurred AS capped_pi_indexed_incurred,
       1.00 *capped_pi_indexed_paid AS capped_pi_indexed_paid,
       ad_paid + tp_paid + pi_paid + ot_paid + ws_paid + large_pi_paid AS total_paid,
       total_incurred AS total_incurred,
       large_pi_incurred AS large_pi_incurred,
       large_pi_paid,
       total_incurred - large_pi_incurred AS total_cap_incurred,
       CASE
         WHEN total_incurred > 25000 THEN 25000
         ELSE total_incurred
       END AS total_incurred_cap_25k,
       CASE
         WHEN total_incurred > 50000 THEN 50000
         ELSE total_incurred
       END AS total_incurred_cap_50k,
       CASE
         WHEN total_incurred > 1000000 THEN 1000000
         ELSE total_incurred
       END AS total_incurred_cap_1m,
       CASE
         WHEN total_incurred > 2000000 THEN 2000000
         ELSE total_incurred
       END AS total_incurred_cap_2m,
      CASE
         WHEN year(f_uw_start)<2024 and total_incurred > 1000000 then 1000000
         WHEN year(f_uw_start)>=2024 and total_incurred > 2000000 then 2000000
         ELSE total_incurred
      END AS total_incurred_cap_1m_2m_b_a_24,

      CASE
         WHEN year(acc_year)<2024 and total_incurred > 1000000 then 1000000
         WHEN year(acc_year)>=2024 and total_incurred > 2000000 then 2000000
         ELSE total_incurred
      END AS total_incurred_cap_1m_2m_b_a_24_acc,
       /*CASE
         WHEN settleddate <= dev_month AND total_reported_count > 0 THEN 1.00
         ELSE 0
       END AS settled_indicator,*/ CASE
         WHEN total_incurred = total_paid AND total_count = 1 THEN 1
         ELSE 0
       END AS Settled_Indicator,
       CASE
         WHEN ad_incurred = ad_paid AND ad_count = 1 THEN 1
         ELSE 0
       END AS AD_Settled_Indicator,
       CASE
         WHEN tp_incurred = tp_paid AND tp_count = 1 THEN 1
         ELSE 0
       END AS TP_Settled_Indicator,
       CASE
         WHEN tp_chire_incurred = tp_chire_paid AND tp_chire_count = 1 THEN 1
         ELSE 0
       END AS TP_CHire_Settled_Indicator,
      CASE
         WHEN tp_exc_CH_incurred = tp_exc_CH_paid AND tp_exc_CH_count = 1 THEN 1
         ELSE 0
       END AS TP_exc_CH_Settled_Indicator,
       CASE
         WHEN pi_incurred = pi_paid AND pi_count = 1 THEN 1
         ELSE 0
       END AS PI_Settled_Indicator,
       CASE
         WHEN ot_incurred = ad_paid AND ot_count = 1 THEN 1
         ELSE 0
       END AS OT_Settled_Indicator,
       CASE
         WHEN ws_incurred = ad_paid AND ws_count = 1 THEN 1
         ELSE 0
       END AS WS_Settled_Indicator,
       po.inception_strategy,
       CASE
         WHEN (notificationdate -day(notificationdate) +1) <= dev_month THEN 1
         ELSE 0
       END AS all_notifications,
       CASE
         WHEN ws_count = 0 AND (notificationdate -day(notificationdate) +1) <= dev_month THEN 1
         ELSE 0
       END AS all_notifications_exc_ws,
       no_claimants,
       tpinterventionrequired,
       no_sucessful_int,
       no_unsuccessful_int,
       no_none_tpi,
       no_non_contactable,
       no_both,
       no_chire,
       no_repairs
FROM (SELECT *,
             '2999-01-01' AS settleddate
      FROM (SELECT eprem.polnum,
                   eprem.scheme,
                   eprem.renewseq,
                   eprem.inception,
                   eprem.uw_month,
                   eprem.acc_month,
                   d.start_date AS uw_year,
                   f.fy AS financial_uw_year,
                   e.start_date AS uw_start,
                   f.start_date AS f_uw_start,
                   timestampadd(MONTH,-1,c.fy_start_date) AS acc_year,
                   c.fy_quarter_start_date AS acc_qtr,
                   e.fy_quarter_start_date AS uw_qtr,
                   b.start_date AS dev_month,
                   months_between(b.start_date,eprem.acc_month) AS dev_period,
                   CASE
                     WHEN months_between (b.start_date,eprem.acc_month) = 0 THEN earned_premium
                     ELSE 0
                   END AS earned_premium,
                   earned_premium AS earned_premium_cumulative,
                   exposure AS exposure_cumulative,
                   CASE
                     WHEN months_between (b.start_date,eprem.acc_month) = 0 THEN exposure
                     ELSE 0
                   END AS exposure
            FROM (SELECT Polnum,
                         scheme,
                         renewseq,
                         inception,
                         MIN(uw_month) AS uw_month,
                         acc_month,
                         SUM(earned_premium) AS earned_premium,
                         SUM(exposure) AS exposure,
                         MAX(inforce) AS inforce
                  FROM ice_prem_earned
                  GROUP BY polnum,
                           scheme,
                           renewseq,
                           inception,
                           acc_month) eprem
              JOIN aauser.calendar b
                ON eprem.acc_month <= b.start_date
               AND to_date (SYSDATE-DAY (SYSDATE) + 1) >= b.start_date
              LEFT JOIN aauser.calendar c ON eprem.acc_month = c.start_date
              LEFT JOIN aapricing.uw_years d
                     ON eprem.inception >= d.start_date
                    AND eprem.inception <= d.end_date
                    AND d.scheme = eprem.scheme
              LEFT JOIN aauser.calendar e ON eprem.uw_month = e.start_date
              LEFT JOIN aapricing.financial_years f
                     ON eprem.inception >= f.start_date
                    AND eprem.inception <= f.end_date
                    AND f.scheme = eprem.scheme) prem
        LEFT JOIN ice_claims_cumulative clm
               ON prem.polnum = clm.polnum
              AND prem.acc_month = clm.acc_month
              AND clm.policyinception = prem.inception
              AND clm.dev_period = prem.dev_period /* and  clm.dev_month < (to_date(SYSDATE) -DAY(to_date(SYSDATE)))*/ /*and prem.inception <= clm.incidentdate and (prem.inception+364) >= clm.incidentdate and prem.acc_month=clm.acc_month and exposure >0 and clm.dev_month < (to_date(SYSDATE) -DAY(to_date(SYSDATE)) +1)*/
      WHERE prem.acc_month <(to_date(SYSDATE) -DAY(to_date(SYSDATE)) +1)) a
  LEFT JOIN (SELECT claim_number,
                    COUNT(claim_number) AS no_claimants,
                    SUM(CASE WHEN tpinterventionrequired = 'Yes' THEN 1 ELSE 0 END) AS tpinterventionrequired,
                    SUM(CASE WHEN tpi_status = 'Successful Intervention' THEN 1 ELSE 0 END) AS no_sucessful_int,
                    SUM(CASE WHEN tpi_status = 'Unsuccessful Intervention' THEN 1 ELSE 0 END) AS no_unsuccessful_int,
                    SUM(CASE WHEN tpi_status = 'No TPI' THEN 1 ELSE 0 END) AS no_none_tpi,
                    SUM(CASE WHEN tpi_status = 'Non Contactable' THEN 1 ELSE 0 END) AS no_non_contactable,
                    SUM(CASE WHEN type_of_int = 'Both' THEN 1 ELSE 0 END) AS no_both,
                    SUM(CASE WHEN type_of_int = 'CHire' THEN 1 ELSE 0 END) AS no_chire,
                    SUM(CASE WHEN type_of_int = 'Repairs' THEN 1 ELSE 0 END) AS no_repairs
             FROM (SELECT *,
                          CASE
                            WHEN tpinterventionrequired = 'Yes' AND contactsuccess = 'Successful' AND (hirevehiclerequired = 'Yes' OR repairsrequired = 'Yes') THEN 'Successful Intervention'
                            WHEN tpinterventionrequired = 'Yes' AND contactsuccess = 'Successful' AND (hirevehiclerequired = 'No' OR hirevehiclerequired IS NULL) AND (repairsrequired = 'No' OR repairsrequired IS NULL) THEN 'Unsuccessful Intervention'
                            WHEN tpinterventionrequired = 'No' THEN 'No TPI'
                            WHEN tpinterventionrequired = 'Yes' AND contactsuccess = 'Not Successful' THEN 'Non Contactable'
                            ELSE 'Unknown'
                          END AS tpi_status,
                          CASE
                            WHEN hirevehiclerequired = 'Yes' AND repairsrequired = 'Yes' THEN 'Both'
                            WHEN hirevehiclerequired = 'Yes' THEN 'CHire'
                            WHEN repairsrequired = 'Yes' THEN 'Repairs'
                            ELSE 'Unknown'
                          END AS type_of_int
                   FROM ice_aa_tp_intervention) a
             GROUP BY claim_number) x ON a.claimnum = x.claim_number
  LEFT JOIN v_ice_policy_origin po ON a.polnum = po.policy_reference_number
WHERE a.dev_month <(to_date(SYSDATE) -DAY(to_date(SYSDATE)) +1)
         ;;
  }


  dimension: scheme {
    type: string
    sql: ${TABLE}.scheme ;;
  }

  dimension: renewseq {
    type: number
    sql: ${TABLE}.renewseq ;;
  }

  dimension: strategy {
    type: string
    sql: ${TABLE}.inception_strategy ;;
  }

  dimension: financial_uw_year {
    type: string
    sql: ${TABLE}.financial_uw_year ;;
  }

  dimension: f_uw_year {
    type: string
    sql: ${TABLE}.f_uw_year ;;
  }

  dimension: uw_year_needed {
    type: string
    sql: ${TABLE}.uw_year_needed ;;
  }

  dimension_group: accident_month {
    type: time
    timeframes: [
      month
    ]
    sql: ${TABLE}.acc_month ;;
  }

  dimension: dev_period_acc_month {
    label: "Development Month Accident Month Basis"
    type: number
    sql: ${TABLE}.dev_period_acc_month ;;
  }

  dimension_group: accident_year {
    type: time
    timeframes: [
      year,
      date
    ]
    sql: ${TABLE}.acc_year ;;
  }

  dimension_group: underwriting_year {
    type: time
    timeframes: [
      year
    ]
    sql: ${TABLE}.uw_year ;;
  }

  dimension_group: accident_qtr {
    type: time
    timeframes: [
      fiscal_quarter
    ]
    sql: ${TABLE}.acc_qtr ;;
  }

  dimension_group: uw_qtr {
    type: time
    timeframes: [
      fiscal_quarter
    ]
    sql: ${TABLE}.uw_qtr ;;
  }

  dimension: dev_period_acc_year {
    label: "Development Month Accident Year Basis"
    type: number
    sql: ${TABLE}.dev_period_acc_year ;;
  }

  dimension: dev_period_acc_qtr {
    label: "Development Month Accident Qtr Basis"
    type: number
    sql: ${TABLE}.dev_period_acc_qtr ;;
  }

  dimension: dev_period_uw_qtr {
    label: "Development Month UW Qtr Basis"
    type: number
    sql: ${TABLE}.dev_period_uw_qtr ;;
  }

  dimension: dev_period_uw_year {
    label: "Development Month UW Year Basis"
    type: number
    sql: ${TABLE}.dev_period_uw_year ;;
  }

  dimension: dev_period_fuw_year {
    label: "Development Month Financial UW Year Basis"
    type: number
    sql: ${TABLE}.dev_period_fuw_year ;;
  }

  dimension: exclude_large_loss_pols {
    type: string
    sql:case when polnum ='AAPMB0000467125' or polnum ='AAPMB0000340730' or polnum ='AAPMB0000370516' or polnum ='AAPMB0000042813' then 'Large Losses' else 'No Large Losses' end
      ;;
  }

  dimension: tp_inc_acc_band {
    type: tier
    tiers: [0,100,500,1000,1500,2000,2500,2600,3000,3500,4000,4500,5000,10000]
    style: integer
    value_format_name: gbp_0
    sql: ${TABLE}.tp_incurred
      ;;
  }

  dimension: ad_inc_acc_band {
    type: tier
    tiers: [0,100,500,1000,1500,2000,2500,2600,3000,3500,4000,4500,5000,10000]
    style: integer
    value_format_name: gbp_0
    sql: ${TABLE}.ad_incurred
      ;;
  }

  dimension: ad_inc_exc_rec_acc_band {
    type: tier
    tiers: [0,100,500,1000,1500,2000,2500,2600,3000,3500,4000,4500,5000,10000]
    style: integer
    value_format_name: gbp_0
    sql: ${TABLE}.ad_incurred_exc_rec
      ;;
  }

  dimension: tp_reserve_info {
    type: string
    sql: case when ${TABLE}.tp_count = 1 then
            case when ${TABLE}.tp_std_reserve = 0 then 'IR'
            else 'SIR' end
          else 'No TP' end;;
  }

  dimension: capped_pi_indexed_incurred_dim {
    type:  number
    sql: capped_pi_indexed_incurred ;;
  }

  dimension: FNOL_Cause_Code {
    type: string
    sql: ${TABLE}.FNOL_Cause_Code ;;
  }

  dimension: current_Cause_Code {
    type: string
    sql: ${TABLE}.current_Cause_Code ;;
  }

  dimension: Jul_Aug_Inception_2020_flag {
    type:  number
    sql: CASE WHEN date(${TABLE}.inception) >= '2020-07-01' AND date(${TABLE}.inception) <= '2020-08-31' then 1 else 0 end  ;;
  }

  measure: ad_incurred {
    type: number
    sql:  sum(ad_incurred) ;;
  }

  measure: tp_incurred {
    type: number
    sql:  sum(tp_incurred) ;;
  }

  measure: tp_chire_incurred {
    type: number
    sql:  sum(tp_chire_incurred) ;;
  }


  measure: pi_incurred {
    type: number
    sql:  sum(pi_incurred) ;;
  }

  measure: pi_incurred_cap1m {
    type: number
    sql:  sum(case when (pi_incurred+large_pi_incurred) > 1000000 then 1000000 else (pi_incurred+large_pi_incurred) end) ;;
  }

  measure: pi_incurred_cap25k {
    type: number
    sql:  sum(case when (pi_incurred+large_pi_incurred) > 25000 then 25000 else (pi_incurred+large_pi_incurred) end) ;;
  }

  measure: pi_xs_incurred_cap1m {
    type: number
    sql:  sum(case when (pi_incurred+large_pi_incurred) > 1000000 then 975000 else (large_pi_incurred) end) ;;
  }

  measure: capped_pi_indexed_incurred {
    type:  number
    sql: avg(CASE WHEN capped_pi_indexed_incurred > 0 THEN capped_pi_indexed_incurred END) ;;
  }

  measure:capped_pi_indexed_freq{
    type: number
    sql: sum(case when capped_pi_indexed_incurred > 0 THEN 1 ELSE 0 END)/${exposure_cumulative} ;;
  }

  measure: capped_pi_indexed_paid {
    type:  number
    sql:avg(capped_pi_indexed_paid) ;;
  }

  measure: ot_incurred {
    type: number
    sql:  sum(ot_incurred) ;;
  }

  measure: ws_incurred {
    type: number
    sql:  sum(ws_incurred) ;;
  }

  measure: ad_paid {
    type: number
    sql:  sum(ad_paid) ;;
  }

  measure: tp_paid {
    type: number
    sql:  sum(tp_paid) ;;
  }

  measure: pi_paid {
    type: number
    sql:  sum(pi_paid+large_pi_paid) ;;
  }

  measure: pi_paid_cap1m {
    type: number
    sql:  sum(case when (pi_paid+large_pi_paid) > 1000000 then 1000000 else (pi_paid+large_pi_paid) end) ;;
  }

  measure: pi_paid_cap25k {
    type: number
    sql:  sum(case when (pi_paid+large_pi_paid) > 25000 then 25000 else (pi_paid+large_pi_paid) end) ;;
  }

  measure: ot_paid {
    type: number
    sql:  sum(ot_paid) ;;
  }

  measure: ws_paid {
    type: number
    sql:  sum(ws_paid) ;;
  }

  measure: recoveries_paid {
    type: sum
    sql: ad_paid_rec ;;
  }

  measure: total_paid {
    type: sum
    sql: total_paid;;
  }

  measure: total_incurred {
    type: sum
    sql: total_incurred ;;
    description: "Total Incurred Claims"
  }

  measure: total_incurred_cap_25k {
    type: sum
    sql: total_incurred_cap_25k ;;
    description: "Total Incurred Claims Cap 25k"
  }

  measure: total_incurred_cap_50k {
    type: sum
    sql: total_incurred_cap_50k ;;
    description: "Total Incurred Claims Cap 50k"
  }

  measure: total_incurred_cap_1m {
    type: sum
    sql: total_incurred_cap_1m ;;
    description: "Total Incurred Claims Cap 1 million"
  }

  measure: total_incurred_cap_2m {
    type: sum
    sql: total_incurred_cap_2m ;;
    description: "Total Incurred Claims Cap 2 million"
  }

  measure: total_incurred_cap_1m_2m_b_a_24 {
    type: sum
    sql: total_incurred_cap_1m_2m_b_a_24 ;;
    description: "Total Incurred Claims Cap 1 and 2 million b/a 2024"
  }


  measure: total_incurred_cap_1m_2m_b_a_24_acc {
    type: sum
    sql: total_incurred_cap_1m_2m_b_a_24_acc ;;
    description: "Total Incurred Claims Cap 1 and 2 million b/a 2024 Acc"
  }
  measure: earned_premium {
    type: sum
    sql:earned_premium ;;
    description: "Earned Premium"
  }

  measure: earned_premium_cumulative {
    type: sum
    sql:earned_premium_cumulative ;;
    description: "Earned Premium Cumulative"
  }

  measure: exposure_cumulative {
    type: sum
    sql:exposure_cumulative ;;
    description: "Exposure Cumulative"
  }

  measure: earned_premium_cumulative_chk {
    type: running_total
    sql: ${earned_premium};;
    direction: "column"
    description: "Earned Premium_Cumulative_Chk"
  }

  measure: loss_ratio {
    type: number
    sql: ${total_incurred} / ${earned_premium_cumulative};;
    description: "Loss Ratio"
    value_format: "0.0%"
  }

  measure: loss_ratio_ex_cumulative {
    type: number
    sql: ${total_incurred} / ${earned_premium};;
    value_format: "0.0%"
  }

  measure: loss_ratio_cap_25k {
    type: number
    sql: ${total_incurred_cap_25k} / nullif(${earned_premium_cumulative},0);;
    description: "Loss Ratio Cap 25k"
    value_format: "0.0%"
  }

  measure: loss_ratio_cap_25k_pi {
    type: number
    sql: sum(total_cap_incurred) / nullif(${earned_premium_cumulative},0);;
    description: "loss_ratio_cap_25k_PI"
    value_format: "0.0%"
  }

  measure: total_cap_incurred {
    type: number
    sql: sum(total_cap_incurred);;
  }

  measure: loss_ratio_cap_50k {
    type: number
    sql: ${total_incurred_cap_50k} / nullif(${earned_premium_cumulative},0);;
    description: "Loss Ratio Cap 50k"
    value_format: "0.0%"
  }

  measure: loss_ratio_cap_1m {
    type: number
    sql: ${total_incurred_cap_1m} /nullif(${earned_premium_cumulative},0);;
    description: "Loss Ratio Cap 1m"
    value_format: "0%"
  }

  measure: loss_ratio_cap_2m {
    type: number
    sql: ${total_incurred_cap_2m} /nullif(${earned_premium_cumulative},0);;
    description: "Loss Ratio Cap 2m"
    value_format: "0%"
  }

  measure: ad_loss_ratio {
    type: number
    sql: sum(ad_incurred)/sum(earned_premium_cumulative);;
    value_format: "0%"
  }

  measure: ad_paid_loss_ratio {
    type: number
    sql: sum(ad_paid)/sum(earned_premium_cumulative);;
    value_format: "0%"
  }

  measure: ad_paid_ex_rec_loss_ratio {
    type: number
    sql: sum(ad_paid_exc_rec)/sum(earned_premium_cumulative);;
    value_format: "0%"
  }

  measure: ad_paid_rec_loss_ratio {
    type: number
    sql: sum(ad_paid_rec)/sum(earned_premium_cumulative);;
    value_format: "0%"
  }

  measure: tp_loss_ratio {
    type: number
    sql: sum(tp_incurred)/sum(earned_premium_cumulative);;
    value_format: "0%"
  }

  measure: tp_paid_lr {
    type: number
    sql: sum(tp_paid)/sum(earned_premium_cumulative);;
    value_format: "0%"
  }

  measure: total_paid_lr {
    type: number
    sql: sum(total_paid)/sum(earned_premium_cumulative);;
    value_format: "0%"
  }

  measure: pi_loss_ratio {
    type: number
    sql: sum(pi_incurred)/sum(earned_premium_cumulative);;
    value_format: "0%"
  }

  measure: pi_large_loss_ratio {
    type: number
    sql: sum(large_pi_incurred)/sum(earned_premium_cumulative);;
    value_format: "0%"
  }

  measure: pi_large_loss_ratio_cap1m {
    type: number
    sql: sum(case when large_pi_incurred > 1000000 then 1000000 else large_pi_incurred end)/sum(earned_premium_cumulative);;
    value_format: "0%"
  }

  measure: ot_loss_ratio {
    type: number
    sql: sum(ot_incurred)/sum(earned_premium_cumulative);;
    value_format: "0%"
  }

  measure: ws_loss_ratio {
    type: number
    sql: sum(ws_incurred)/sum(earned_premium_cumulative);;
    value_format: "0.0%"
  }

  measure: reported_count_ex_ws {
    type: sum
    sql: total_reported_count_exc_ws;;
    description: "Reported Count Ex WS"
  }

  measure: reported_count {
    type: sum
    sql: total_reported_count;;
  }

  measure: ad_count {
    type: sum
    sql: ad_count;;
  }

  measure: tp_count {
    type: sum
    sql: tp_count;;
  }

  measure: tp_chire_count {
    type: sum
    sql: tp_chire_count;;
  }

  measure: ot_count {
    type: sum
    sql: ot_count;;
  }
  measure: ws_count {
    type: sum
    sql: ws_count;;
  }

  measure: tp_std_res_count {
    type: sum
    sql:  TP_Std_Reserve;;
  }

  measure: tp_std_res_proportion {
    type: number
    sql:  sum(TP_Std_Reserve)/nullif(sum(tp_count),0);;
    value_format: "0.0%"
  }

  measure: pi_std_res_proportion {
    type: number
    sql:  sum(PI_Std_Reserve)/nullif(sum(pi_count),0);;
    value_format: "0.0%"
  }

  measure: ad_std_res_proportion {
    type: number
    sql:  sum(AD_Std_Reserve)/nullif(sum(AD_count),0);;
    value_format: "0.0%"
  }

  measure: ad_std_res_count {
    type: sum
    sql:  AD_Std_Reserve;;
  }

  measure: reported_freq_ex_ws {
    type: number
    sql: ${reported_count_ex_ws} / ${exposure_cumulative} ;;
    description: "Reported Freq Exc WS"
    value_format: "0.00%"
  }

  measure: all_notification_freq {
    type: number
    sql: sum(all_notifications) / ${exposure_cumulative} ;;
    value_format: "0.00%"
  }

  measure: all_notification_ex_ws_freq {
    type: number
    sql: sum(all_notifications_exc_ws) / ${exposure_cumulative} ;;
    value_format: "0.00%"
  }

  measure: nonnil_count_exc_ws {
    type: sum
    sql: total_count_exc_ws*1.00;;
    description: "Total Non Nil Count Ex WS"
  }

  measure: all_notifications_ex_ws {
    type: number
    sql:sum(all_notifications_exc_ws*1.00);;
  }

  measure: non_nil_pct_notfs {
    type:  number
    sql: ${nonnil_count_exc_ws}/${all_notifications_ex_ws} ;;
    value_format: "0.0%"
  }

  measure: nonnil_freq_ex_ws {
    type: number
    sql: ${nonnil_count_exc_ws} / ${exposure_cumulative} ;;
    description: "Non Nil Freq Exc WS"
    value_format: "0.00%"
  }

  measure: ad_freq {
    type: number
    sql: sum(ad_count)/ ${exposure_cumulative} ;;
    value_format: "0.0%"
  }

  measure: ad_freq_over150 {
    type: number
    sql: sum(ad_collared_count)/ ${exposure_cumulative} ;;
    value_format: "0.0%"
  }

  measure: ad_nil_freq {
    type: number
    sql: sum(case when ad_incurred_exc_rec > 0 and ad_incurred < 50 then 1 else 0 end)/ ${exposure_cumulative} ;;
    value_format: "0.0%"
  }

  measure: ad_reported_claim_freq {
    type: number
    sql:  sum(case when ad_incurred_exc_rec > 0 then 1 else 0 end) / ${exposure_cumulative};;
  }


  measure: tp_freq {
    type: number
    sql: sum(tp_count)/ ${exposure_cumulative} ;;
    value_format: "0.0%"
  }

  measure: pi_freq {
    type: number
    sql: sum(pi_count)/ ${exposure_cumulative} ;;
    value_format: "0.00%"
  }

  measure: pi_count {
    type: number
    sql: sum(pi_count) ;;
  }

  measure: exposure {
    type: number
    sql: sum(exposure) ;;
  }

  measure: ot_freq {
    type: number
    sql: sum(ot_count)/ ${exposure_cumulative} ;;
    value_format: "0.00%"
  }

  measure: ws_freq {
    type: number
    sql: sum(ws_count)/ ${exposure_cumulative} ;;
    value_format: "0.0%"
  }

  measure: large_PI_freq {
    type: number
    sql: sum(large_pi_count)/ ${exposure_cumulative} ;;
    value_format: "0.0%"
  }

  measure: settled_indicator {
    type: sum
    sql: settled_indicator;;
    value_format: "0.0%"
  }

  measure: tp_chire_loss_ratio {
    type: number
    sql: sum(tp_chire_incurred)/sum(earned_premium_cumulative);;
    value_format: "0%"
  }

  measure: tp_chire_freq {
    type: number
    sql: sum(tp_chire_count)/ ${exposure_cumulative} ;;
    value_format: "0.00%"
  }

  measure: tp_with_Chire {
    type: number
    sql: sum(TP_Chire_Count)/nullif(sum(tp_count),0) ;;
    value_format: "0.0%"
  }

  measure: tp_exc_chire_loss_ratio {
    type: number
    sql: sum(tp_exc_ch_incurred)/sum(earned_premium_cumulative);;
    value_format: "0%"
  }

  measure: tp_exc_ch_freq {
    type: number
    sql: sum(tp_exc_ch_count)/ ${exposure_cumulative} ;;
    value_format: "0.00%"
  }

  measure: tp_exc_Ch {
    type: number
    sql: sum(tp_exc_ch_Count)/nullif(sum(tp_count),0) ;;
    value_format: "0.0%"
  }
  measure: chire_cost_prop_tp_cost {
    type: number
    sql: sum(tp_chire_incurred)/sum(tp_incurred);;
    value_format: "0%"
  }

  measure: non_chire_cost_prop_tp_cost {
    type: number
    sql: sum(tp_exc_ch_incurred)/sum(tp_incurred);;
    value_format: "0%"
  }

  measure: ad_sev {
    type: number
    sql: sum(ad_incurred)/ sum(ad_count) ;;
  }

  measure: ad_paid_sev {
    type: number
    sql: sum(ad_paid)/ nullif(sum(ad_count),0) ;;
  }

  measure: ad_ex_rec_paid_sev {
    type: number
    sql: sum(ad_paid_exc_rec)/ nullif(sum(ad_count),0) ;;
  }

  measure: ad_bc {
    type: number
    sql: sum(ad_incurred)/ ${exposure_cumulative} ;;
  }

  measure: ad_settled_incurred {
    type: number
    sql: sum(case when AD_Settled_Indicator =1 then ad_incurred else 0 end)  ;;
  }

  measure: ad_settled_count {
    type: number
    sql: sum(case when AD_Settled_Indicator =1 then ad_count else 0 end) ;;
  }


  measure: ad_settled_sev {
    type: number
    sql: sum(case when AD_Settled_Indicator =1 then ad_incurred else 0 end) / sum(case when AD_Settled_Indicator =1 then ad_count else 0.0000000000000001 end) ;;
  }

  measure: tp_sev {
    type: number
    sql: case when sum(tp_count) = 0 then 0 else sum(tp_incurred)/ sum(tp_count) end ;;
  }

  measure: tp_chire_sev {
    type: number
    sql: case when sum(tp_chire_count) = 0 then 0 else sum(tp_chire_incurred)/ sum(tp_chire_count) end ;;
  }

  measure: tp_exc_ch_sev {
    type: number
    sql: case when sum(tp_exc_ch_count) = 0 then 0 else sum(tp_exc_ch_incurred)/ sum(tp_exc_ch_count) end ;;
  }


  measure: tp_settled_incurred {
    type: number
    sql: sum(case when tp_settled_indicator =1 then tp_incurred else 0 end)  ;;
  }


  measure: tp_settled_count {
    type: number
    sql: sum(case when tp_settled_indicator =1 then tp_count else 0 end) ;;
  }


  measure: tp_settled_sev {
    type: number
    sql: sum(case when tp_settled_indicator =1 then tp_incurred else 0 end) / sum(case when tp_settled_indicator =1 then tp_count else 0.0000000000000001 end) ;;
  }



  measure: tp_chire_settled_sev {
    type: number
    sql: sum(case when TP_CHire_Settled_Indicator =1 then tp_chire_incurred else 0 end) / sum(case when TP_CHire_Settled_Indicator =1 then tp_chire_count else 0.0000000000000001 end) ;;
  }

  measure: tp_chire_settled_count {
    type: number
    sql: sum(case when TP_CHire_Settled_Indicator =1 then tp_chire_count else 0 end) ;;
  }

  measure: tp_chire_settled_incurred {
    type: number
    sql: sum(case when TP_CHire_Settled_Indicator =1 then tp_chire_incurred else 0 end)  ;;
  }

  measure: tp_exc_ch_settled_sev {
    type: number
    sql: sum(case when TP_exc_CH_Settled_Indicator =1 then tp_exc_ch_incurred else 0 end) / sum(case when TP_exc_CH_Settled_Indicator =1 then tp_exc_ch_count else 0.0000000000000001 end) ;;
  }

  measure: pi_sev {
    type: number
    sql: case when sum(pi_count) = 0 then 0 else sum(pi_incurred)/ sum(pi_count) end;;
  }



  measure: pi_settled_incurred {
    type: number
    sql: sum(case when pi_settled_indicator =1 then pi_incurred else 0 end)  ;;
  }



  measure: pi_settled_count {
    type: number
    sql:  sum(case when pi_settled_indicator =1 then pi_count else 0 end) ;;
  }


  measure: pi_settled_sev {
    type: number
    sql: sum(case when pi_settled_indicator =1 then pi_incurred else 0 end) / sum(case when pi_settled_indicator =1 then pi_count else 0.0000000000000001 end) ;;
  }

  measure: ot_sev {
    type: number
    sql: case when sum(ot_count) = 0 then 0 else sum(ot_incurred)/ sum(ot_count) end;;
  }

  measure: ot_settled_sev {
    type: number
    sql: sum(case when ot_settled_indicator =1 then ot_incurred else 0 end) / sum(case when ot_settled_indicator =1 then ot_count else 0.0000000000000001 end) ;;
  }

  measure: ws_sev {
    type: number
    sql: case when sum(ws_count) = 0 then 0 else sum(ws_incurred)/ sum(ws_count) end ;;
  }

  measure: ws_settled_sev {
    type: number
    sql: sum(case when ws_settled_indicator =1 then ws_incurred else 0 end) / sum(case when ws_settled_indicator =1 then ws_count else 0.0000000000000001 end) ;;
  }

  measure: settled_proporition {
    type: number
    sql: ${settled_indicator} / nullif(${reported_count},0)  ;;
    description: "Settled Proportion"
    value_format: "0%"
  }

  measure: AD_settled_proporition {
    type: number
    sql: sum(ad_settled_indicator) / nullif(sum(ad_count),0)  ;;
    description: "Settled Proportion"
    value_format: "0%"
  }

  measure: TP_settled_proporition {
    type: number
    sql: sum(tp_settled_indicator) / nullif(sum(tp_count),0)  ;;
    description: "Settled Proportion"
    value_format: "0%"
  }

  measure: TP_CHire_settled_proporition {
    type: number
    sql: sum(TP_CHire_Settled_Indicator) / nullif(sum(tp_chire_count),0)  ;;
    description: "Settled Proportion"
    value_format: "0%"
  }

  measure: TP_exc_CH_settled_proportion {
    type: number
    sql: sum(TP_exc_CH_Settled_Indicator) / nullif(sum(tp_exc_ch_count),0)  ;;
    description: "Settled Proportion"
    value_format: "0%"
  }

  measure: PI_settled_proporition {
    type: number
    sql: sum(pi_settled_indicator) / nullif(sum(pi_count),0)  ;;
    description: "Settled Proportion"
    value_format: "0%"
  }

  measure: OT_settled_proporition {
    type: number
    sql: sum(ot_settled_indicator) / nullif(sum(ot_count),0)  ;;
    description: "Settled Proportion"
    value_format: "0%"
  }

  measure: ws_settled_proporition {
    type: number
    sql: sum(ws_settled_indicator) / nullif(sum(ws_count),0)  ;;
    description: "Settled Proportion"
    value_format: "0%"
  }

  measure: recovery_indicator {
    type: sum
    sql: rec_reserves;;
  }

  measure: ad_incurred_recoveries {
    type: sum
    sql: ad_incurred_recoveries;;
  }

  measure: ad_recoveries_vs_total_ad {
    type: number
    sql: sum(-ad_incurred_recoveries) / sum(ad_incurred - ad_incurred_recoveries) ;;
  }

  measure: total_incurred_recoveries {
    type: sum
    sql: total_incurred_recoveries;;
  }

  measure: ad_with_partial_recovery {
    type: number
    description: ""
    sql: sum(case when ad_incurred > 0 and ad_incurred_recoveries < 0 then 1.00 else 0.00 end) / sum(ad_reported);;
    value_format: "0.0%"
  }

  measure: ad_with_full_recovery {
    type: number
    description: ""
    sql: sum(case when ad_incurred = 0 and ad_incurred_exc_rec > 0 then 1.00 else 0.00 end) / sum(ad_reported);;
    value_format: "0.0%"
  }

  measure: ad_with_nearly_full_recovery {
    type: number
    description: "Recovery to within £10"
    sql: sum(case when ad_incurred < 10 and ad_incurred_exc_rec > 0 then 1.00 else 0.00 end) / sum(ad_reported);;
    value_format: "0.0%"
  }

  measure: ad_with_no_recovery {
    type: number
    description: ""
    sql: sum(case when ad_incurred > 0 and ad_incurred_recoveries = 0 then 1.00 else 0.00 end) / sum(ad_reported);;
    value_format: "0.0%"
  }

  measure: ad_with_over_recovery {
    type: number
    description: ""
    sql: sum(case when ad_incurred < -10 and ad_incurred_exc_rec > 0 then 1.000 else 0.000 end) / sum(ad_reported);;
    value_format: "0.00%"
  }

  measure: average_paid {
    type: average
    sql: total_paid;;
  }

  measure: paid_proportion {
    type: number
    sql: ${total_paid}/${total_incurred};;
  }

  measure: ad_paid_proportion {
    type: number
    sql: sum(ad_paid)/sum(ad_incurred);;
  }

  measure: ad_paid_proportion_ex_recs {
    type: number
    sql: sum(ad_paid-ad_paid_rec)/sum(ad_incurred-ad_incurred_recoveries);;
  }

  measure: ad_paid_recovery_proportion {
    type: number
    sql: sum(-ad_paid_rec)/sum(-ad_incurred_recoveries);;
  }

  measure: tp_paid_proportion {
    type: number
    sql: case when sum(tp_incurred) > 0 then sum(tp_paid)/sum(tp_incurred) else 0 end;;
  }

  measure: pi_paid_proportion_ex_large {
    type: number
    sql: case when sum(pi_incurred) > 0 then sum(pi_paid)/sum(pi_incurred) else 0 end;;
  }

  measure: ad_non_nil_pct {
    type: number
    sql: sum(ad_count)/${nonnil_count_exc_ws};;
  }

  measure: tp_pct {
    type: number
    sql: sum(tp_count)/${nonnil_count_exc_ws};;
  }

  measure: tp_chirepct {
    type: number
    sql: sum(tp_chire_count)/sum(total_reported_count_exc_ws);;
  }

  measure: tp_exc_ch_pct {
    type: number
    sql: sum(tp_exc_ch_count)/sum(total_reported_count_exc_ws);;
  }

  measure: pi_pct {
    type: number
    sql: sum(pi_count)/${nonnil_count_exc_ws};;
  }

  measure: tp_ad_count_ratio {
    type: number
    sql: sum(tp_count)/nullif(sum(ad_count),0);;

  }

  measure: pi_tp_count_ratio {
    type: number
    sql: sum(pi_count)/nullif(sum(tp_count),0);;
  }

  measure: loss_ratio_successful_tpi {
    type: number
    sql: sum(case when no_sucessful_int >= 1 then tp_incurred else 0 end) / sum(earned_premium_cumulative);;
    value_format: "0%"
  }

  measure: loss_ratio_unsuccessful_tpi {
    type: number
    sql: sum(case when no_unsuccessful_int >= 1 and no_sucessful_int = 0 then tp_incurred else 0 end) / sum(earned_premium_cumulative);;
    value_format: "0%"
  }

  measure: loss_ratio_non_contactable_tpi {
    type: number
    sql: sum(case when no_sucessful_int = 0 and no_unsuccessful_int = 0 and no_non_contactable>= 1 then tp_incurred else 0 end) / sum(earned_premium_cumulative);;
    value_format: "0%"
  }

  measure: tp_freq_successful_tpi {
    type: number
    sql: sum(case when no_sucessful_int >= 1 then tp_count else 0 end)/ ${exposure_cumulative} ;;
    value_format: "0.0%"
  }

  measure: tp_freq_unsuccessful_tpi {
    type: number
    sql: sum(case when no_unsuccessful_int >= 1 and no_sucessful_int = 0 then tp_count else 0 end)/ ${exposure_cumulative} ;;
    value_format: "0.0%"
  }

  measure: tp_freq_non_contactable_tpi {
    type: number
    sql: sum(case when no_sucessful_int = 0 and no_unsuccessful_int = 0 and no_non_contactable>= 1 then tp_count else 0 end)/ ${exposure_cumulative} ;;
    value_format: "0.0%"
  }

  measure: tp_sev_successful_tpi {
    type: number
    sql: sum(case when no_sucessful_int >= 1 then tp_incurred else 0 end) / sum(case when no_sucessful_int >= 1 then tp_count else 0.000000000000000000000001 end)  ;;
    value_format: "0.0"
  }

  measure: tp_sev_unsuccessful_tpi {
    type: number
    sql: sum(case when no_unsuccessful_int >= 1 and no_sucessful_int = 0 then tp_incurred else 0 end) / sum(case when no_unsuccessful_int >= 1 and no_sucessful_int = 0 then tp_count else 0.000000000000000000000001 end) ;;
    value_format: "0.0"
  }

  measure: tp_sev_non_contactable_tpi {
    type: number
    sql: sum(case when no_sucessful_int = 0 and no_unsuccessful_int = 0 and no_non_contactable>= 1 then tp_incurred else 0 end) / sum(case when no_sucessful_int = 0 and no_unsuccessful_int = 0 and no_non_contactable>= 1 then tp_count else 0.000000000000000000000001 end) ;;
    value_format: "0.0"
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
    sql: sum(case when no_sucessful_int = 0 and no_unsuccessful_int = 0 and no_non_contactable>= 1 then 1 else 0 end) / sum(case when tpinterventionrequired >= 1 then 1 else 0.000000000000000000000001 end) ;;
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

  measure: pi_sev_cap25k {
    type: number
    sql: case when sum(pi_count) = 0 then 0 else sum(pi_incurred_cap25k)/ sum(pi_count) end;;
  }

  measure: pi_settled_sev_cap25k {
    type: number
    sql: sum(case when pi_settled_indicator =1 then pi_incurred_cap25k else 0 end) / sum(case when pi_settled_indicator =1 then pi_count else 0.0000000000000001 end) ;;
  }




}
