module mux_testbench;

    timeunit 1ns;
    timeprecision 1ns;
    
    logic [3:0] ip1, ip2, ip3;
    logic sel1 = 0, sel2 = 0, sel3 = 0;
    logic clk;
    logic [3:0] mux_op;

    mux_assert mux1 (.*);    //port connection
 
    always begin 
    clk = 0;
    #5 clk = ~clk;
    end
     
    initial begin
        @(posedge clk) 
     #1 ip1 <= 4'b0010;
        ip2 <= 4'b0100;
        ip3 <= 4'b1000;

        #10 sel1 <= 1;
        #10 sel2 <= 1;
        #10 sel3 <= 1; 

        $display ("ip1 = %d, ip2 = %d, ip3 = %d, max_op = %d", ip1,ip2,ip3,max_op);
    end

endmodule