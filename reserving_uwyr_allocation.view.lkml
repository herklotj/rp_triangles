view: reserving_uwyr_allocation {
  derived_table: {
    sql:

     select
          ultimates.*
          ,eprem.earned_premium
          ,eprem.exposure
        from
          reserving_uwyr_ultimates ultimates
        left join
          (select
              acc_month
              ,pr.scheme
              ,d.uwy
              ,sum(earned_premium) as earned_premium
              ,sum(exposure) as exposure
           from
              dbuser.ice_prem_earned pr
           LEFT JOIN
              aapricing.uw_years d
              ON pr.inception >= d.start_date
                 AND pr.inception <= d.end_date
                 AND d.scheme = pr.scheme
           group by acc_month,pr.scheme,d.uwy
           ) eprem
            on eprem.acc_month = ultimates.acc_month and eprem.scheme = ultimates.scheme and eprem.uwy = ultimates.uwy
             ;;
  }


  dimension: Underwriting_Year{
    type: string
    sql: ${TABLE}.uwy ;;
  }


  dimension: scheme{
    type: string
    sql: ${TABLE}.scheme ;;
  }




  measure: Exposure {
    type: sum
    sql: nullif(exposure,0) ;;
    value_format: "#,##0"
  }

  measure: Earned_Premium {
    type: sum
    sql: earned_premium ;;
    value_format: "0.0,,\" M\""
  }

  measure: Av_Earned_Premium {
    type: number
    sql: ${Earned_Premium}/nullif(${Exposure},0) ;;
    value_format: "#,##0"
  }








  measure: incurred_cap50k {
    type: sum
    sql: total_incurred_cap50k ;;
    value_format: "0.0,,\" M\""
  }

  measure: incurred_cap50k_lr {
    type: number
    sql: ${incurred_cap50k} /nullif(${Earned_Premium},0) ;;
    value_format: "0.0%"
  }

  measure: ultimate_cap50k {
    type: sum
    sql: ultimate_cap50k ;;
    value_format: "0.0,,\" M\""
  }

  measure: ultimate_cap50k_lr {
    type: number
    sql: ${ultimate_cap50k} /nullif(${Earned_Premium},0) ;;
    value_format: "0.0%"
  }



  measure: incurred_50k_to_1m {
    type: sum
    sql: total_incurred_50k_1m ;;
    value_format: "0.0,,\" M\""
  }

  measure:incurred_50k_to_1m_lr {
    type: number
    sql: ${incurred_50k_to_1m} /nullif(${Earned_Premium},0) ;;
    value_format: "0.0%"
  }

  measure: ultimate_50k_to_1m {
    type: sum
    sql: total_incurred_50k_1m ;;
    value_format: "0.0,,\" M\""
  }

  measure: ultimate_50k_to_1m_lr {
    type: number
    sql: ${ultimate_50k_to_1m} /nullif(${Earned_Premium},0) ;;
    value_format: "0.0%"
  }


  measure: incurred_cap_1m {
    type: number
    sql: ${incurred_cap50k} + ${incurred_50k_to_1m} ;;
    value_format: "0.0,,\" M\""
  }

  measure:incurred_cap_1m_lr {
    type: number
    sql: ${incurred_cap_1m} /nullif(${Earned_Premium},0) ;;
    value_format: "0.0%"
  }

  measure: ultimate_cap_1m {
    type: sum
    sql: ultimate_cap_1m ;;
    value_format: "0.0,,\" M\""
  }

  measure: ultimate_cap_1m_lr {
    type: number
    sql: ${ultimate_cap_1m} /nullif(${Earned_Premium},0) ;;
    value_format: "0.0%"
  }

}
