module mem_testbench (mem_interface.mem_tb mbus);
timeunit 1ns;
timeprecision 100ps;

logic debug = 1;
logic [7:0] rdata;
int ok;

class randclass;
    randc bit [4:0] rand_addr;
    rand bit [7:0] rand_data;
 
    constraint c_upper {rand_data inside {[8'h41:8'h5a]}; }                  
    constraint c_lower {rand_data inside {[8'h61:8'h7a]}; }
endclass

randclass rnd = new;      //class handle construct       

covergroup coverblock @(posedge mbus.clk);
    cv_addr: coverpoint mbus.addr;
    cv_data_in: coverpoint mbus.data_in { bins b_up = {[8'h41:8'h5a]};
                                          bins b_lw = {[8'h61:8'h7a]};
                                          bins b_rest = default; 
                                        }
    cv_data_out: coverpoint mbus.data_out { bins b_up = {[8'h41:8'h5a]};
                                            bins b_lw = {[8'h61:8'h7a]};
                                            bins b_rest = default;
                                          }
endgroup

coverblock cvg = new();      

//////////////////////////////////////

initial begin
    
    rand_upper: begin
        for (int i=0, i<=31, i++) begin

            rnd.constraint_mode(0);           //disable both constraint
            rnd.c_upper.constraint_mode(1);   //enable c_upper
            ok = rnd.randomize();             //randomizes with only c_upper

            if (!rnd.randomize())
                $display("Randomization failure"); 

            mbus.write_mem (rnd.rand_addr, rnd.rand_data, 1);
            mbus.read_mem(rnd.rand_addr, rdata, 1)
            check(rnd.rand_addr, rdata, rnd.rand_data); 

            cvg.sample();     //coverage implementation
        end
        final_status(error_count); 
    end

    rand_lower: begin
        for (int i=0, i<=31, i++) begin

            rnd.constraint_mode(0);          
            rnd.c_lower.constraint_mode(1);   
            ok = rnd.randomize();             

            if (!rnd.randomize())
                $display("Randomization failure"); 

            mbus.write_mem (rnd.rand_addr, rnd.rand_data, 1);
            mbus.read_mem(rnd.rand_addr, rdata, 1)
            check(rnd.rand_addr, rdata, rnd.rand_data);     
        end
        final_status(error_count); 
    end

    clear_mem: begin
        for (int i=0, i<=31, i++)
            mbus.write_mem (i,'b0, debug);
        for (int i=0, i<=31, i++) begin
            mbus.read_mem(i, rdata, debug)
            check(i, rdata, 'b0);      
        end
        final_status(error_count);
    end

    data_mem: begin
        for (int i=0, i<=31, i++)
            mbus.write_mem (i, i, debug);   //data == addr
        for (int i=0, i<=31, i++) begin
            mbus.read_mem (i, rdata, debug)
            check(i, rdata, i);       
        end
        final_status(error_count); 
    end

    $finish; 

end

//////////////////////////////////////////////

function int check (input [4:0] addr, input [7:0] actual, expected, output error_count);
     static int error_count;

     if (actual !== expected) begin
         $display ("ERROR: Address %d: Data %d don't match expected %d",addr,actual,expected);
         error_count++;
         end
     ////return (error_count);    
endfunction

function final_status (input error_count);
    if (error_count == 0)
        $display("TEST PASSED SUCCESSFULLY");
    else
        $display("TEST FAILED: Total Errors: %d",error_count);
endfunction

initial begin
    #50000ns $display("Simulation timeout!");
           $finish;
end

endmodule