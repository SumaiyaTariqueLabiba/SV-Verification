module top_mem();
   timeunit 1ns;
   timeprecision 100ps;

   bit clk;
   wire read, write;
   wire [4:0] addr;
   wire [7:0] data_in, data_out;

   always #5 clk = ~clk;

   memory memory1 (.*);                   //instantiate
   mem_testbench mem_testbench1 (.*); 

endmodule