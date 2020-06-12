view: ad_hod_tri {
  derived_table: {
    sql:
       SELECT a.polnum,
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
           1.00 *AD_count AS AD_Count,
           1.00 *total_incurred AS ad_incurred,
           1.00 *total_paid AS ad_paid,
           po.inception_strategy
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
                FROM v_ice_prem_earned eprem
                  JOIN aauser.calendar b
                    ON eprem.acc_month <= b.start_date
                   AND to_date (SYSDATE-DAY (SYSDATE) + 1) >= b.start_date
                  LEFT JOIN aauser.calendar c ON eprem.acc_month = c.start_date
                  LEFT JOIN aapricing.uw_years d
                         ON eprem.inception >= d.start_date
                        AND eprem.inception <= d.end_date
                        AND d.scheme = eprem.scheme
                  LEFT JOIN aauser.calendar e ON eprem.uw_month = e.start_date) prem
            LEFT JOIN v_ad_hod_tri clm
                   ON prem.polnum = clm.polnum
                  AND prem.acc_month = clm.acc_month
                  AND clm.inception = prem.inception
                  AND clm.dev_month = prem.dev_month
          WHERE prem.acc_month <(to_date(SYSDATE) -DAY(to_date(SYSDATE)) +1)) a
      LEFT JOIN v_ice_policy_origin po ON a.polnum = po.policy_reference_number
      LEFT JOIN (SELECT polnum, inevncnt, inception_strategy FROM expoclm) EXP
             ON a.polnum = exp.polnum
            AND exp.inevncnt = 1
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

  }


  measure: ad_incurred {
    type: number
    sql:  sum(ad_incurred) ;;
  }


  measure: ad_paid {
    type: number
    sql:  sum(ad_paid) ;;
  }


  }
