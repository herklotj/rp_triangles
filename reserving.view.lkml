view: reserving {
  derived_table: {
    sql:
    select
      ultimates.*
      ,eprem.earned_premium
      ,eprem.exposure
    from
      v_reserving_dfm_ultimates ultimates
    left join
      (select
          acc_month
          ,sum(earned_premium) as earned_premium
          ,sum(exposure) as exposure
       from
          v_ice_prem_earned
       group by acc_month
       ) eprem
        on eprem.acc_month = ultimates.acc_month
         ;;
  }


  dimension_group: accident_month {
    type: time
    timeframes: [
      month
    ]
    sql: ${TABLE}.acc_month ;;
  }




  measure: Exposure {
    type: sum
    sql: exposure ;;
    value_format: "#,##0"
    }

  measure: Earned_Premium {
    type: sum
    sql: earned_premium ;;
    value_format: "0.0,,\" M\""
    }

  measure: Av_Earned_Premium {
    type: number
    sql: ${Earned_Premium}/${Exposure} ;;
    value_format: "#,##0"
  }









  measure: total_count {
    type: sum
    sql: total_count ;;
  }

  measure:total_freq {
    type: number
    sql: ${total_count} / ${Exposure} ;;
    value_format: "0.0%"
  }

  measure: total_count_ultimate {
    type: sum
    sql: total_count_ultimate ;;
  }

  measure:total_ult_freq {
    type: number
    sql: ${total_count_ultimate} / ${Exposure} ;;
    value_format: "0.0%"
  }




  measure: total_count_exc_ws {
    type: sum
    sql: total_count_exc_ws ;;
  }

  measure:total_exc_ws_freq {
    type: number
    sql: ${total_count_exc_ws} / ${Exposure} ;;
    value_format: "0.0%"
  }

  measure: total_count_exc_ws_ultimate {
    type: sum
    sql: total_count_exc_ws_ultimate ;;
  }

  measure:total_exc_ws_ult_freq {
    type: number
    sql: ${total_count_exc_ws_ultimate} / ${Exposure} ;;
    value_format: "0.0%"
  }








  measure: ad_nonnil_count {
    type: sum
    sql: ad_count ;;
  }

  measure: ad_nonnil_freq {
    type: number
    sql: ${ad_nonnil_count} / ${Exposure} ;;
    value_format: "0.0%"
  }


  measure: ad_nonnil_ultimate {
    type: sum
    sql: ad_count_ultimate ;;
  }

  measure: ad_nonnil_ult_freq {
    type: number
    sql: ${ad_nonnil_ultimate} / ${Exposure} ;;
    value_format: "0.0%"
  }






  }
