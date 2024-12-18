view: ad_hod_tri {
  derived_table: {
    sql:
       SELECT a.polnum,
      a.claim_number,
       scheme,
       a.renewseq,
       inception,
       uw_month,
       uw_year,
       uw_qtr,
       to_timestamp(acc_month) AS acc_month,
       acc_year,
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
       1.00 *AD_count AS AD_count,
       total_incurred AS ad_incurred,
       total_paid AS ad_paid,
       fee_paid,
       fee_incurred,
       veh_paid,
       veh_incurred,
       rec_paid,
       rec_incurred,
       hire_paid,
       hire_incurred,
       store_paid,
       store_incurred,
       ccs_paid,
       ccs_incurred,
       pb_paid,
       pb_incurred,
       other_paid,
       other_incurred,
       tl_paid,
       tl_incurred,
       salvage_paid,
       salvage_incurred,
       1.00 *fee_count AS fee_count,
       1.00 *veh_count AS veh_count,
       1.00 *rec_count AS rec_count,
       1.00 *hire_count AS hire_count,
       1.00 *store_count AS store_count,
       1.00 *ccs_count AS ccs_count,
       1.00 *pb_count AS pb_count,
       1.00 *other_count AS other_count,
       1.00 *tl_count AS tl_count,
       1.00 *repair_count AS repair_count,
       1.00 *salvage_count AS salvage_count,
       po.inception_strategy,
       liability_decision
FROM (SELECT *,
             '2999-01-01' AS settleddate
      FROM (SELECT eprem.polnum,
                   eprem.scheme,
                   eprem.renewseq,
                   eprem.inception,
                   eprem.uw_month,
                   eprem.acc_month,
                   d.start_date AS uw_year,
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
            FROM ice_prem_earned_tiara eprem
              JOIN aauser.calendar b
                ON eprem.acc_month <= b.start_date
               AND to_date (SYSDATE-DAY (SYSDATE) + 1) >= b.start_date
              LEFT JOIN aauser.calendar c ON eprem.acc_month = c.start_date
              LEFT JOIN aapricing.uw_years d
                     ON eprem.inception >= d.start_date
                    AND eprem.inception <= d.end_date
                    AND d.scheme = eprem.scheme
              LEFT JOIN aauser.calendar e ON eprem.uw_month = e.start_date) prem
        LEFT JOIN ad_hod_tri clm
               ON prem.polnum = clm.polnum
              AND prem.acc_month = clm.acc_month
              AND clm.inception = prem.inception
              AND clm.dev_month = prem.dev_month
        LEFT JOIN (SELECT claim_number,
                          liability_decision
                   FROM dbuser.ice_dim_claim
                   WHERE current_flag = 'Y') lib ON clm.claimnum = lib.claim_number
      WHERE prem.acc_month <(to_date(SYSDATE) -DAY(to_date(SYSDATE)) +1)) a
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

  dimension: liability_decision {
    type: string
    sql: ${TABLE}.liability_decision ;;
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
    sql: CAST(${TABLE}.acc_qtr AS TIMESTAMP WITHOUT TIME ZONE) ;;
  }

  dimension_group: uw_qtr {
    type: time
    timeframes: [
      fiscal_quarter
    ]
    sql: CAST(${TABLE}.uw_qtr AS TIMESTAMP WITHOUT TIME ZONE) ;;
  }

  dimension: claim_number {
    label: "Claim Number"
    type: string
    sql: ${TABLE}.claim_number ;;
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

  measure: ad_loss_ratio {
    type: number
    sql: sum(ad_incurred)/sum(earned_premium_cumulative);;
    value_format: "0%"
  }

  measure: ad_count {
    type: sum
    sql: ad_count;;
  }

  measure: ad_freq {
    type: number
    sql: sum(ad_count)/ ${exposure_cumulative} ;;
    value_format: "0.0%"
  }

  measure: exposure {
    type: number
    sql: sum(exposure) ;;
  }

  measure: ad_sev {
    type: number
    sql: sum(ad_incurred)/ sum(ad_count) ;;
    value_format_name: gbp
  }

  measure: ad_sev_exc_fees {
    type: number
    sql: sum(ad_incurred - fee_incurred)/ sum(ad_count) ;;
    value_format_name: gbp
  }

  measure: ad_incurred {
    type: number
    sql:  sum(ad_incurred) ;;
    value_format_name: gbp
  }

  measure: ad_paid {
    type: number
    sql:  sum(ad_paid) ;;
    value_format_name: gbp
  }

  measure: ad_paid_sev {
    type: number
    sql: sum(ad_paid)/ sum(ad_count) ;;
    value_format_name: gbp
  }

  measure: fee_count {
    type: sum
    sql: fee_count;;
  }

  measure: fee_freq {
    type: number
    sql: sum(fee_count)/ ${exposure_cumulative} ;;
    value_format: "0.0%"
  }

  measure: only_fee_no_ad_freq {
    type: number
    sql: sum(case when ad_count = 0 then fee_count else 0 end)/ ${exposure_cumulative} ;;
    value_format: "0.0%"
  }

  measure: fee_with_ad_freq {
    type: number
    sql: sum(case when ad_count = 1 then fee_count else 0 end)/ ${exposure_cumulative} ;;
    value_format: "0.0%"
  }

  measure: fee_sev {
    type: number
    sql: sum(fee_incurred)/ sum(fee_count) ;;
    value_format_name: gbp
  }

  measure: veh_count {
    type: sum
    sql: veh_count;;
  }

  measure: veh_freq {
    type: number
    sql: sum(veh_count)/ ${exposure_cumulative} ;;
    value_format: "0.0%"
  }

  measure: veh_proportion {
    type: number
    sql: sum(veh_count)/ sum(ad_count) ;;
    value_format: "0.0%"
  }

  measure: veh_sev {
    type: number
    sql: sum(veh_incurred)/ sum(veh_count) ;;
    value_format_name: gbp
  }

  measure: veh_paid_sev {
    type: number
    sql: sum(veh_paid)/ sum(veh_count) ;;
    value_format_name: gbp
  }

  measure: veh_paid_freq {
    type: number
    sql: sum(case when veh_paid > 0 then veh_count else 0 end)/ ${exposure_cumulative} ;;
  }

  measure: veh_settled_freq {
    type: number
    sql: sum(case when veh_paid > 0 and veh_paid = veh_incurred then veh_count else 0 end)/ ${exposure_cumulative} ;;
  }

  measure: veh_with_payment_settled_prop {
    type: number
    sql: sum(case when veh_paid > 0 and veh_paid = veh_incurred then veh_count else 0 end)/ sum(case when veh_paid > 0 then veh_count else 0 end) ;;
  }

  measure: veh_settled_sev {
    type: number
    sql: sum(case when veh_paid > 0 and veh_paid = veh_incurred then veh_paid else 0 end)/ sum(case when veh_paid > 0 and veh_paid = veh_incurred then veh_count else 0 end) ;;
    value_format_name: gbp
  }

  measure: rec_count {
    type: sum
    sql: rec_count;;
  }

  measure: rec_freq {
    type: number
    sql: sum(rec_count)/ ${exposure_cumulative} ;;
    value_format: "0.0%"
  }

  measure: rec_sev {
    type: number
    sql: sum(rec_incurred)/ sum(rec_count) ;;
    value_format_name: gbp
  }

  measure: rec_proportion {
    type: number
    sql: sum(rec_count)/ sum(ad_count) ;;
    value_format: "0.0%"
  }

  measure: rec_paid_sev {
    type: number
    sql: sum(rec_paid)/ sum(rec_count) ;;
    value_format_name: gbp
  }

  measure: hire_count {
    type: sum
    sql: hire_count;;
  }

  measure: hire_freq {
    type: number
    sql: sum(hire_count)/ ${exposure_cumulative} ;;
    value_format: "0.0%"
  }

  measure: hire_sev {
    type: number
    sql: sum(hire_incurred)/ sum(hire_count) ;;
    value_format_name: gbp
  }

  measure: hire_proportion {
    type: number
    sql: sum(hire_count)/ sum(ad_count) ;;
    value_format: "0.0%"
  }

  measure: hire_paid_sev {
    type: number
    sql: sum(hire_paid)/ sum(hire_count) ;;
    value_format_name: gbp
  }

  measure: store_count {
    type: sum
    sql: store_count;;
  }

  measure: store_freq {
    type: number
    sql: sum(store_count)/ ${exposure_cumulative} ;;
    value_format: "0.0%"
  }

  measure: store_sev {
    type: number
    sql: sum(store_incurred)/ sum(store_count) ;;
    value_format_name: gbp
  }

  measure: store_proportion {
    type: number
    sql: sum(store_count)/ sum(ad_count) ;;
    value_format: "0.0%"
  }

  measure: store_paid_sev {
    type: number
    sql: sum(store_paid)/ sum(store_count) ;;
    value_format_name: gbp
  }

  measure: ccs_count {
    type: sum
    sql: ccs_count;;
  }

  measure: ccs_freq {
    type: number
    sql: sum(ccs_count)/ ${exposure_cumulative} ;;
    value_format: "0.0%"
  }

  measure: ccs_sev {
    type: number
    sql: sum(ccs_incurred)/ sum(ccs_count) ;;
    value_format_name: gbp
  }

  measure: ccs_proportion {
    type: number
    sql: sum(ccs_count)/ sum(ad_count) ;;
    value_format: "0.0%"
  }

  measure: ccs_paid_sev {
    type: number
    sql: sum(ccs_paid)/ sum(ccs_count) ;;
    value_format_name: gbp
  }

  measure: pb_count {
    type: sum
    sql: pb_count;;
  }

  measure: pb_freq {
    type: number
    sql: sum(pb_count)/ ${exposure_cumulative} ;;
    value_format: "0.000%"
  }

  measure: pb_sev {
    type: number
    sql: sum(pb_incurred)/ sum(pb_count) ;;
    value_format_name: gbp
  }

  measure: pb_proportion {
    type: number
    sql: sum(pb_count)/ sum(ad_count) ;;
    value_format: "0.000%"
  }

  measure: pb_paid_sev {
    type: number
    sql: sum(pb_paid)/ sum(pb_count) ;;
    value_format_name: gbp
  }

  measure: other_count {
    type: sum
    sql: other_count;;
  }

  measure: other_freq {
    type: number
    sql: sum(other_count)/ ${exposure_cumulative} ;;
    value_format: "0.0%"
  }

  measure: other_sev {
    type: number
    sql: sum(other_incurred)/ sum(other_count) ;;
    value_format_name: gbp
  }

  measure: other_proportion {
    type: number
    sql: sum(other_count)/ sum(ad_count) ;;
    value_format: "0.0%"
  }

  measure: other_paid_sev {
    type: number
    sql: sum(other_paid)/ sum(other_count) ;;
    value_format_name: gbp
  }

  measure: tl_count {
    type: sum
    sql: tl_count;;
  }

    measure: tl_prop_all_ad {
    type: number
    sql: sum(tl_count)/ sum(ad_count) ;;
      value_format: "0.0%"
  }

  measure: tl_prop_veh {
    type: number
    sql: sum(tl_count)/ sum(veh_count) ;;
    value_format: "0.0%"
  }

  measure: tl_sev {
    type: number
    sql: sum(tl_incurred)/ sum(tl_count) ;;
    value_format_name: gbp
  }

  measure: repair_sev {
    type: number
    sql:  CASE WHEN sum(veh_count - tl_count) = 0 then 0 else sum(veh_incurred - tl_incurred)/ sum(veh_count - tl_count) end;;
    value_format_name: gbp
  }


  measure: salvage_count {
    type: sum
    sql: salvage_count;;
  }

  measure: salvage_freq {
    type: number
    sql: sum(salvage_count)/ ${exposure_cumulative} ;;
    value_format: "0.0%"
  }

  measure: salvage_sev {
    type: number
    sql: sum(-1*salvage_incurred)/ sum(salvage_count) ;;
    value_format_name: gbp
  }

  measure: salvage_proportion {
    type: number
    sql: sum(salvage_count)/ sum(ad_count) ;;
    value_format: "0.0%"
  }

  measure: salvage_paid_sev {
    type: number
    sql: sum(-1*salvage_paid)/ sum(hire_count) ;;
    value_format_name: gbp
  }

  }
