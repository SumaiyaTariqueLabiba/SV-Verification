
module consumer_m
#(parameter int unsigned consume_time_min=5, consume_time_max=15)
 (interface intfc);     //consumer time is uniform distribution

  timeunit       1ns;
  timeprecision 10ps;
  import trans_pkg::*;

  mailbox #(my_tr_base_c) config_box = new ;
  mailbox #(my_tr_base_c) synch_box  = new ; 
  mailbox #(my_tr_base_c) comms_box  = new ; 


  task automatic consume(ref my_tr_base_c trans) ;
    $display("%t: BEGIN consuming transaction %d of type %s",
              $stime, trans.id, trans.get_type() ) ;
            
    #($urandom_range( consume_time_max,consume_time_min) ) ;

    $display("%t: END consuming transaction %d of type %s",
              $stime, trans.id, trans.get_type() ) ;
  endtask : consume

  ///////Consume/GET transactions//////
    always begin : consume_config
      my_tr_base_c trans ;
      config_box.get(trans) ;
      consume(trans) ;
    end : consume_config

    always begin : consume_synch
      my_tr_base_c trans ;
      synch_box.get(trans) ;
      consume(trans) ;
    end : consume_synch

     always begin : consume_comms
      my_tr_base_c trans ;
      comms_box.get(trans) ;
      consume(trans) ;
     end : consume_comms


 // /////Put transactions//////
 
     always begin : dispatch_blk
      my_tr_base_c trans ;
      intfc.get(trans) ;

      case ( trans.get_type() )
        "my_tr_config_c" : config_box.put(trans) ;
        "my_tr_synch_c"  : synch_box.put(trans) ;
        "my_tr_comms_c"  : comms_box.put(trans) ;
      endcase
    end : dispatch_blk

endmodule : consumer_m
