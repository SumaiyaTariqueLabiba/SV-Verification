
module top_m;

  timeunit       1ns;
  timeprecision 10ps;

  localparam int unsigned number_of_transactions=20 ; // How long to sim (producer should run slightly slower than consumers or FIFO blows up)
  localparam int unsigned produce_time_ave=10 ;
  localparam int unsigned consume_time_min=5, consume_time_max=15 ;

  mailbox_if intfc() ;

  producer_m #(.number_of_transactions(number_of_transactions),
               .produce_time_ave(produce_time_ave))
  producer (.intfc(intfc.put_port)) ;

  consumer_m #(.consume_time_min(consume_time_min),
               .consume_time_max(consume_time_max))
  consumer(.intfc(intfc.get_port)) ;

endmodule : top_m
