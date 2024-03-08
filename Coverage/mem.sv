module memory (mem_interface.mem_design mbus);

 timeunit 1ns;
 timeprecision 100ps; 
 logic [7:0] memory [0:31]; 
  
  always @(posedge mbus.clk)
    if (mbus.write && !mbus.read)
      #1 memory[mbus.addr] <= mbus.data_in;
    
  always_ff @(posedge mbus.clk iff ((mbus.read == '1) && (mbus.write == '0)))
    mbus.data_out <= memory[mbus.addr];
       
endmodule:memory