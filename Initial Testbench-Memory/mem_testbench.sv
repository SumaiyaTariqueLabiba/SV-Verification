module mem_testbench (input logic clk,
                      input logic [7:0] data_out
                        output logic write, read,
                        output logic [4:0] addr,
                        output logic [7:0] data_in);
timeunit 1ns;
timeprecision 100ps;

logic debug = 1;
logic [7:0] rdata;


initial begin

    int error_count;

    clear_mem: begin
        for (int i=0; i<32; i++)
            write_mem (i,'b0, debug);
        for (int i=0; i<32; i++) begin
            read_mem(i, rdata, debug)
            error_count = check(i, rdata, 'b0);    
        end
        final_status(error_count);  
    end

    data_mem: begin
        for (int i=0; i<32; i++)
            write_mem (i, i, debug);   //data == addr
        for (int i=0; i<32; i++) begin
            read_mem (i, rdata, debug)
            error_count = check(i, rdata, i);     
        end
        final_status(error_count);  
    end

    $finish; 

end

initial begin
    #5000ns $display("Simulation timeout!");
           $finish;
end

//-------task/func--------//

task write_mem (input waddr, input wdata, input debug = 0);
    @(negedge clk)
       write <= 1;
       read <= 0;
       addr <= waddr;
       data_in <= wdata;
    @(negedge clk)
       write <= 0;
   /* @(negedge clk)
       write <= 1;
       read <= 1;    */////////////
    if(debug == 1)
        $display ("write addr = %d data = %d", waddr, wdata);        
endtask

task read_mem (input raddr, output rdata, input debug = 0);
    @(negedge clk)
       write <= 0;
       read <= 1;
       addr <= raddr;
    @(negedge clk)
       read <= 0;
       rdata = data_out;   //blocking =
   /*@(negedge clk)
       write <= 1;
       read <= 1;    */
    if(debug == 1)
        $display ("read addr = %d data = %d", raddr, rdata);        
endtask

function int check (input [4:0] addr, input [7:0] actual, expected, output error_count);
     static int error_count;

     if (actual !== expected) begin
         $display ("ERROR: Address %d: Data %d don't match expected %d",addr,actual,expected);
         error_count++;
         end
  //   return (error_count);    
endfunction

function final_status (input int error_count);
    if (error_count == 0)
        $display("TEST PASSED SUCCESSFULLY");
    else
        $display("TEST FAILED: Total Errors: %d",error_count);
endfunction

endmodule