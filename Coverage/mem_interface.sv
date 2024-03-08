interface mem_interface (input logic clk);

    timeunit 1ns;
    timeprecision 100ps;
    
    logic read, write;
    logic [4:0] addr;
    logic [7:0] data_in;
    logic [7:0] data_out;

    modport mem_design (input read, write, clk, addr, data_in,
                        output data_out);
    
    modport mem_tb (input data_out, clk,
                    output read, write, addr, data_in,
                    import write_mem, read_mem);
                  
//-------task/func--------//

    task write_mem (input [4:0] waddr, input [7:0] wdata, input debug = 0);
        @(negedge clk)
        write <= 1;
        read <= 0;
        addr <= waddr;
        data_in <= wdata;
        @(negedge clk)
        write <= 0;
        @(negedge clk)
        write <= 1;
        read <= 1;    /////////////
        if(debug == 1)
            $display ("write addr = %d data = %d", waddr, wdata);        
    endtask

    task read_mem (input [4:0] raddr, output [7:0] rdata, input debug = 0);
        @(negedge clk)
        write <= 0;
        read <= 1;
        addr <= raddr;
        rdata = data_out;   //blocking =
        @(negedge clk)
        read <= 0;
        @(negedge clk)
        write <= 1;
        read <= 1;    /////////////
        if(debug == 1)
            $display ("read addr = %d data = %d", raddr, rdata);        
    endtask

endinterface