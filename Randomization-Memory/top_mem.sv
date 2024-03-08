module top_mem();
   timeunit 1ns;
   timeprecision 1ns;
   
   logic clk = 0;
   always #5 clk = ~clk;

   mem_interface mbus (.*);   
   memory memory1 (.*);                  
   mem_testbench mem_testbench1 (.*); 

endmodule