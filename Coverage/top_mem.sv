module top_mem();
   timeunit 1ns;
   timeprecision 100ps;
   
   logic clk = 0;
   always #5 clk = ~clk;

   mem_interface mbus (.*);   
   memory memory1 (.*,
                   .mbus(mbus.mem_design));                  
   mem_testbench mem_testbench1 (.*,
                                 .mbus(mbus.mem_tb)); 

endmodule