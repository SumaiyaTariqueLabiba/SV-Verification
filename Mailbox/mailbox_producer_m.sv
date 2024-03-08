
module producer_m #(parameter int unsigned number_of_transactions=20, 
                    parameter int unsigned produce_time_ave=10 )
                   (interface intfc );  // Mailbox interface

  timeunit       1ns;
  timeprecision 10ps;

  import trans_pkg::*;

  initial begin : producer_blk

      my_tr_base_c   my_tr_base   ;   //handles
      my_tr_config_c my_tr_config ; 
      my_tr_synch_c  my_tr_synch  ; 
      my_tr_comms_c  my_tr_comms  ; 

      $timeformat(-9,0,"",3); 

      for ( int unsigned i=1; i<=number_of_transactions; ++i ) begin

          int seed; 
          seed = $urandom; 
          #($dist_exponential(seed, produce_time_ave) ) ; // wait an exponentially distributed amount of time

          // produce a random transaction and mail it
          randsequence(main)
            main: A:=1 | B:=2 | C:=7 ;  //weight dist.
            A: {my_tr_config = new(1);
                $display( "%t:       Produced  transaction %d of type %s",
                          $stime,my_tr_config.id, my_tr_config.get_type() );
                my_tr_base = my_tr_config;
                intfc.put(my_tr_base) ;
               };
            B: {my_tr_synch  = new(2);
                $display( "%t:       Produced  transaction %d of type %s",
                          $stime,my_tr_synch.id,my_tr_synch.get_type() ) ;
                my_tr_base = my_tr_synch;
                intfc.put(my_tr_base) ;
               };
            C: {my_tr_comms  = new(3);
                $display( "%t:       Produced  transaction %d of type %s",
                          $stime,my_tr_comms.id,my_tr_comms.get_type() ) ;
                my_tr_base = my_tr_comms;
                intfc.put(my_tr_base) ;
               };
          endsequence

      end // for
end : producer_blk

endmodule : producer_m
