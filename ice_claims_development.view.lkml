view: ice_claims_development {
  derived_table: {
    sql:
    select
        a.polnum
        ,scheme
        ,a.renewseq
        ,inception
        ,uw_month
        ,uw_year
        ,uw_qtr
        ,to_timestamp(acc_month) as acc_month
        ,acc_year
        ,acc_qtr
        ,dev_month
        ,case when dev_period > 0 then 0 else earned_premium end as earned_premium
        ,earned_premium_cumulative
        ,case when dev_period > 0 then 0 else exposure end as exposure
        ,exposure_cumulative
        ,incident_date
        ,settleddate
        ,notificationdate
        ,case when dev_period > 0 then dev_period else 0 end as dev_period_acc_month
        ,case when dev_period > 0 then dev_month else acc_month end as dev_month
        ,months_between(dev_month,acc_year) AS dev_period_acc_year
        ,months_between(dev_month,acc_qtr) AS dev_period_acc_qtr
        ,months_between(dev_month+day(uw_year)-1,uw_year) AS dev_period_uw_year
        ,months_between(dev_month,uw_qtr) AS dev_period_uw_qtr
        ,total_reported_count_exc_ws AS total_reported_count_exc_ws
        ,total_reported_count AS total_reported_count
        ,total_count_exc_ws as total_count_exc_ws
        ,total_incurred - total_incurred_exc_rec - total_paid - total_paid_exc_rec AS rec_reserves
        ,ad_incurred - ad_incurred_exc_rec as ad_incurred_recoveries
        ,tp_incurred - tp_incurred_exc_rec as tp_incurred_recoveries
        ,pi_incurred - pi_incurred_exc_rec as pi_incurred_recoveries
        ,ws_incurred - ws_incurred_exc_rec as ws_incurred_recoveries
        ,ot_incurred - ot_incurred_exc_rec as ot_incurred_recoveries
        ,total_incurred - total_incurred_exc_rec as total_incurred_recoveries
        ,ad_incurred_exc_rec
        ,ad_reported_count AS AD_reported
        ,ad_count AS AD_Non_Nil
        ,ad_paid - ad_paid_exc_rec as ad_paid_rec
        ,CASE WHEN round(round(tp_incurred,2) - floor(tp_incurred),2) = 0.81 THEN 1 ELSE 0 END AS TP_Std_Reserve
        ,CASE WHEN round(round(ad_incurred,2) - floor(ad_incurred),2) = 0.81 THEN 1 ELSE 0 END AS AD_Std_Reserve
        ,CASE WHEN round(round(pi_incurred,2) - floor(pi_incurred),2) = 0.81 THEN 1 ELSE 0 END AS PI_Std_Reserve
        ,CASE WHEN round(round(ws_incurred,2) - floor(ws_incurred),2) = 0.81 THEN 1 ELSE 0 END AS WS_Std_Reserve
        ,CASE WHEN round(round(ot_incurred,2) - floor(ot_incurred),2) = 0.81 THEN 1 ELSE 0 END AS OT_Std_Reserve
        ,1.00*tp_count AS TP_Count
        ,1.00*tp_chire_count AS TP_Chire_Count
        ,1.00*AD_count AS AD_Count
        ,1.00*PI_count AS PI_Count
        ,1.00*WS_count AS WS_Count
        ,1.00*OT_count AS OT_Count
        ,1.00*ad_incurred AS ad_incurred
        ,1.00*ad_paid AS ad_paid
        ,1.00*tp_incurred AS tp_incurred
        ,1.00*tp_chire_incurred AS tp_chire_incurred
        ,1.00*tp_paid AS tp_paid
        ,1.00*tp_chire_paid AS tp_chire_paid
        ,1.00*pi_incurred AS pi_incurred
        ,1.00*pi_paid AS pi_paid
        ,1.00*ot_incurred AS ot_incurred
        ,1.00*pi_paid AS ot_paid
        ,1.00*ws_incurred AS ws_incurred
        ,1.00*ws_paid AS ws_paid
        ,ad_paid+tp_paid+pi_paid+ot_paid+ws_paid + large_pi_paid as total_paid
        ,total_incurred AS total_incurred
        ,large_pi_incurred AS large_pi_incurred
        ,large_pi_paid
        ,total_incurred - large_pi_incurred AS total_cap_incurred
        ,case when total_incurred > 25000 then 25000 else total_incurred end as total_incurred_cap_25k
        ,case when total_incurred > 50000 then 50000 else total_incurred end as total_incurred_cap_50k
        ,case when total_incurred > 1000000 then 1000000 else total_incurred end as total_incurred_cap_1m
        ,case when settleddate <= dev_month  and total_reported_count > 0 then 1.00 else 0 end as settled_indicator
        ,po.inception_strategy
        ,case when (notificationdate-day(notificationdate) +1) <=dev_month then 1 else 0 end as all_notifications
        ,case when ws_count = 0 and (notificationdate-day(notificationdate) +1) <=dev_month then 1 else 0 end as all_notifications_exc_ws

        ,fcc.FNOL_cause_code
        ,ccc.current_cause_code
    from
      (
        ,no_claimants
        ,no_noTPI
        ,no_Non_Contactable
        ,no_Successful_Int
        ,no_Unsuccessful_Int
        ,no_CHire
        ,no_Repairs
        ,no_both_CHire_Repairs
    from
          (select
          *,
          '2999-01-01' as settleddate
          from
              (
              select
                  eprem.polnum
                  ,eprem.scheme
                  ,eprem.renewseq
                  ,eprem.inception
                  ,eprem.uw_month
                  ,eprem.acc_month
                  ,d.start_date as uw_year
                  ,timestampadd(month,-1,c.fy_start_date) as acc_year
                  ,c.fy_quarter_start_date as acc_qtr
                  ,e.fy_quarter_start_date as uw_qtr
                  ,b.start_date AS dev_month
                  ,months_between(b.start_date,eprem.acc_month) AS dev_period
                  ,case when months_between(b.start_date,eprem.acc_month)  = 0 then earned_premium else 0 end as earned_premium
                  ,earned_premium as earned_premium_cumulative
                  ,exposure as exposure_cumulative
                  ,case when months_between(b.start_date,eprem.acc_month)  = 0 then exposure else 0 end as exposure
              from
                v_prem_earned eprem

              JOIN
                aauser.calendar b
                  ON eprem.acc_month <= b.start_date
                  AND to_date (sysdate-day (sysdate) + 1) >= b.start_date
              left join
                  aauser.calendar c
                  ON eprem.acc_month = c.start_date
              left join
                  aapricing.uw_years d
                  on eprem.inception >= d.start_date and eprem.inception <=d.end_date and d.scheme=eprem.scheme
              left join
                  aauser.calendar e
                  ON eprem.uw_month = e.start_date
              ) prem

          left join
            v_ice_claims_cumulative clm
            on prem.polnum = clm.polnum and prem.acc_month = clm.acc_month and  clm.policyinception = prem.inception and clm.dev_period = prem.dev_period
           /* and  clm.dev_month < (to_date(SYSDATE) -DAY(to_date(SYSDATE)))*/
            /*and prem.inception <= clm.incidentdate and (prem.inception+364) >= clm.incidentdate and prem.acc_month=clm.acc_month and exposure >0 and clm.dev_month < (to_date(SYSDATE) -DAY(to_date(SYSDATE)) +1)*/
          where prem.acc_month < (to_date(SYSDATE) -DAY(to_date(SYSDATE)) +1)  ) a
      )a
      left join v_ice_policy_origin po ON a.polnum = po.policy_reference_number
      left join (select claim_number,
             incident_cause_code AS FNOL_cause_code
      from ice_dim_claim
      where dim_effective_date_from = '1900-01-01') fcc on fcc.claim_number = a.claimnum
      left join (select claim_number,
                    incident_cause_code as current_cause_code
             from ice_dim_claim
             where dim_effective_date_to = '2099-12-31') ccc on ccc.claim_number = a.claimnum
      left join (SELECT
                claim_number,
                COUNT(claim_number) as no_claimants,
                COUNT(CASE WHEN TPI_Status = 'No TPI' THEN 1 ELSE NULL END) AS no_noTPI,
                COUNT(CASE WHEN TPI_Status = 'Non Contactable' THEN 1 ELSE NULL END) AS no_Non_Contactable,
                COUNT(CASE WHEN TPI_Status = 'Successful Intervention' THEN 1 ELSE NULL END) AS no_Successful_Int,
                COUNT(CASE WHEN TPI_Status = 'Unsuccessful Intervention' THEN 1 ELSE NULL END) AS no_Unsuccessful_Int,
                COUNT(CASE WHEN TPI_Status = 'Unknown' THEN 1 ELSE NULL END) AS no_Unknown,
                COUNT(CASE WHEN statusflag = 'CHire' OR statusflag = 'Both' THEN 1 ELSE NULL END) AS no_CHire,
                COUNT(CASE WHEN statusflag = 'Repairs' OR statusflag = 'Both' THEN 1 ELSE NULL END) AS no_Repairs,
                COUNT(CASE WHEN statusflag = 'Both' THEN 1 ELSE NULL END) AS no_both_CHire_Repairs
                FROM
                  (SELECT
                   CASE WHEN tpinterventionrequired = 'No' THEN 'No TPI'
                   WHEN tpinterventionrequired = 'Yes' AND contactsuccess = 'Successful' AND (repairsrequired = 'Yes' OR hirevehiclerequired = 'Yes') THEN 'Successful Intervention'
                   WHEN tpinterventionrequired = 'Yes' AND contactsuccess = 'Successful' AND (hirevehiclerequired IS NULL OR hirevehiclerequired = 'No') AND (repairsrequired IS NULL OR repairsrequired = 'No') THEN 'Unsuccessful Intervention'
                   WHEN tpinterventionrequired = 'Yes' AND contactsuccess = 'Not Successful' THEN 'Non Contactable'
                   ELSE 'Unknown'
                   END AS TPI_Status,
                   CASE WHEN hirevehiclerequired = 'Yes' AND repairsrequired = 'Yes' THEN 'Both'
                   WHEN hirevehiclerequired = 'Yes' THEN 'CHire'
                   WHEN repairsrequired = 'Yes' THEN 'Repairs'
                   ELSE 'N/A'
                   END AS StatusFlag,
                   tpi_int.*
                   FROM ice_aa_tp_intervention tpi_int ) summary
                GROUP BY claim_number) summary2    on a.claimnum = summary2.claim_number
      left join
          (select polnum, bustrnno, inception_strategy from expoclm
          ) exp
        on a.polnum = exp.polnum and exp.bustrnno = 1
    where a.dev_month < (to_date(SYSDATE) -DAY(to_date(SYSDATE)) +1)


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

  dimension: number_claimants {
    type: number
    sql: ${TABLE}.no_claimants ;;
  }

  dimension: number_noTPI {
    type: number
    sql: ${TABLE}.no_noTPI ;;
  }

  dimension: number_Non_Contactable {
    type: number
    sql: ${TABLE}.no_Non_Contactable ;;
  }

  dimension: number_Successful_Int {
    type: number
    sql: ${TABLE}.no_Successful_Int ;;
  }

  dimension: number_Unsuccessful_Int {
    type: number
    sql: ${TABLE}.no_Unsuccessful_Int ;;
  }

  dimension: number_CHire {
    type: number
    sql: ${TABLE}.no_CHire ;;
  }

  dimension: number_Repairs {
    type: number
    sql: ${TABLE}.no_Repairs ;;
  }

  dimension: number_both_CHire_Repairs {
    type: number
    sql: ${TABLE}.no_both_CHire_Repairs ;;
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

  dimension: tp_reserve_info {
    type: string
    sql: case when ${TABLE}.tp_count = 1 then
            case when ${TABLE}.tp_std_reserve = 0 then 'IR'
            else 'SIR' end
          else 'No TP' end;;
  }

  dimension: FNOL_Cause_Code {
    type: string
    sql: ${TABLE}.FNOL_Cause_Code ;;
  }

  dimension: current_Cause_Code {
    type: string
    sql: ${TABLE}.current_Cause_Code ;;
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
    description: "Total Incurred Claims Cap 50k"
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
    value_format: "0.0000%"
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
    value_format: "0%"
  }

  measure: loss_ratio_cap_1m {
    type: number
    sql: ${total_incurred_cap_1m} /nullif(${earned_premium_cumulative},0);;
    description: "Loss Ratio Cap 1m"
    value_format: "0%"
  }

  measure: ad_loss_ratio {
    type: number
    sql: sum(ad_incurred)/sum(earned_premium_cumulative);;
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
    value_format: "0%"
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

  measure: tp_count {
    type: sum
    sql: tp_count;;

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
    value_format: "0.0%"
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


  measure: tp_with_Chire {
    type: number
    sql: sum(TP_Chire_Count)/nullif(sum(tp_count),0) ;;
    value_format: "0.0%"
  }




  measure: ad_sev {
    type: number
    sql: sum(ad_incurred)/ sum(ad_count) ;;

  }

  measure: ad_settled_sev {
    type: number
    sql: sum(case when settled_indicator =1 then ad_incurred else 0 end) / sum(case when settled_indicator =1 then ad_count else 0.0000000000000001 end) ;;

  }

  measure: tp_sev {
    type: number
    sql: case when sum(tp_count) = 0 then 0 else sum(tp_incurred)/ sum(tp_count) end ;;

  }

  measure: tp_chire_sev {
    type: number
    sql: case when sum(tp_chire_count) = 0 then 0 else sum(tp_chire_incurred)/ sum(tp_chire_count) end ;;

  }

  measure: tp_settled_sev {
    type: number
    sql: sum(case when settled_indicator =1 then tp_incurred else 0 end) / sum(case when settled_indicator =1 then tp_count else 0.0000000000000001 end) ;;

  }

  measure: tp_chire_settled_sev {
    type: number
    sql: sum(case when settled_indicator =1 then tp_chire_incurred else 0 end) / sum(case when settled_indicator =1 then tp_chire_count else 0.0000000000000001 end) ;;

  }

  measure: pi_sev {
    type: number
    sql: case when sum(pi_count) = 0 then 0 else sum(pi_incurred)/ sum(pi_count) end;;

  }

  measure: pi_settled_sev {
    type: number
    sql: sum(case when settled_indicator =1 then pi_incurred else 0 end) / sum(case when settled_indicator =1 then pi_count else 0.0000000000000001 end) ;;

  }

  measure: ot_sev {
    type: number
    sql: case when sum(ot_count) = 0 then 0 else sum(ot_incurred)/ sum(ot_count) end;;

  }

  measure: ot_settled_sev {
    type: number
    sql: sum(case when settled_indicator =1 then ot_incurred else 0 end) / sum(case when settled_indicator =1 then ot_count else 0.0000000000000001 end) ;;

  }

  measure: ws_sev {
    type: number
    sql: case when sum(ws_count) = 0 then 0 else sum(ws_incurred)/ sum(ws_count) end ;;

  }

  measure: ws_settled_sev {
    type: number
    sql: sum(case when settled_indicator =1 then ws_incurred else 0 end) / sum(case when settled_indicator =1 then ws_count else 0.0000000000000001 end) ;;

  }

  measure: settled_proporition {
    type: number
    sql: ${settled_indicator} / ${reported_count}  ;;
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

  measure: total_paid {
    type: sum
    sql: total_paid;;

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
    sql: sum(ad_count)/sum(total_reported_count_exc_ws);;

  }

  measure: tp_pct {
    type: number
    sql: sum(tp_count)/sum(total_reported_count_exc_ws);;

  }

  measure: tp_chirepct {
    type: number
    sql: sum(tp_chire_count)/sum(total_reported_count_exc_ws);;

  }

  measure: pi_pct {
    type: number
    sql: sum(pi_count)/sum(total_reported_count_exc_ws);;

  }

  measure: tp_ad_count_ratio {
    type: number
    sql: sum(tp_count)/nullif(sum(ad_count),0);;

  }

  measure: pi_tp_count_ratio {
    type: number
    sql: sum(pi_count)/nullif(sum(tp_count),0);;

  }

  measure: ad_incurred {
    type: number
    sql:  sum(ad_incurred) ;;
  }

  measure: tp_incurred {
    type: number
    sql:  sum(tp_incurred) ;;
  }

  measure: loss_ratio_successful_tpi {
    type: number
    sql:  sum ((case when no_successful_int >= 1 then 1 else 0 end) * (tp_incurred)) / ${earned_premium_cumulative};;
    value_format: "0.00%"
  }

  measure: loss_ratio_Unsuccessful_tpi {
    type: number
    sql:  sum ((case when no_unsuccessful_int >= 1 then 1 else 0 end) * (tp_incurred)) / ${earned_premium_cumulative};;
    value_format: "0.00%"
  }

  measure: loss_ratio_non_contactable_tpi {
    type: number
    sql:  sum ((case when no_non_contactable >= 1 then 1 else 0 end) * (tp_incurred)) / ${earned_premium_cumulative};;
    value_format: "0.00%"
  }

  measure: tp_freq_successful_tpi {
    type: number
    sql: sum(case when tp_count = 1 AND no_successful_int >= 1 then 1 else 0 end)/ ${exposure_cumulative} ;;
    value_format: "0.00%"
  }

  measure: tp_freq_unsuccessful_tpi {
    type: number
    sql: sum(case when tp_count = 1 AND no_unsuccessful_int >= 1 then 1 else 0 end)/ ${exposure_cumulative} ;;
    value_format: "0.00%"
  }

  measure: tp_freq_non_contactable_tpi {
    type: number
    sql: sum(case when tp_count = 1 AND no_non_contactable >= 1 then 1 else 0 end)/ ${exposure_cumulative} ;;
    value_format: "0.00%"
  }

  measure: tp_sev_successful {
    type: number
    sql:  sum (case when no_successful_int >=1 then tp_incurred else 0 end) / sum(tp_count) ;;

  }

  measure: tp_sev_unsuccessful {
    type: number
    sql:  sum (case when no_unsuccessful_int >=1 then tp_incurred else 0 end) / sum(tp_count) ;;

  }

  measure: tp_sev_non_contactable {
    type: number
    sql:  sum (case when no_non_contactable >=1 then tp_incurred else 0 end) / sum(tp_count) ;;

  }

  measure: tpi_success_rate {
    type: number
    sql:  sum (case when no_successful_int >=1 then 1 else 0 end) / sum(tp_count) ;;
    value_format: "0.0%"
  }

  measure: tpi_unsuccessful_rate {
    type: number
    sql:  sum (case when no_unsuccessful_int >=1 then 1 else 0 end) / sum(tp_count) ;;
    value_format: "0.0%"
  }

  measure: attempted_tpi_total {
    type: number
    sql:  count (case when no_Successful_Int > 0 OR no_unsuccessful_int > 0 OR no_non_contactable > 0 then 1 else null end) ;;
  }

  measure: attempted_tpi_success {
    type: number
    sql:  count (case when no_Successful_Int> 0 then 1 else null end) ;;
  }

  measure: attempted_tpi_unsuccess {
    type: number
    sql:  count (case when no_unsuccessful_int > 0 then 1 else null end) ;;
  }

  measure: attempted_tpi_noncontactable {
    type: number
    sql:  count (case when no_non_contactable > 0 then 1 else null end) ;;
  }


  measure: pi_incurred {
    type: number
    sql:  sum(pi_incurred+large_pi_incurred) ;;
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



}
