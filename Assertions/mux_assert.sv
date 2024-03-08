module mux_assert (input logic [3:0] ip1, ip2, ip3,
            input logic sel1, sel2, sel3,
            input logic clk,
            output logic [3:0] mux_op);
  
 timeunit 1ns;
 timeprecision 100ps;
  
  always @(posedge clk)
    if (sel1)      mux_op <= ip1;
    else if (sel2) mux_op <= ip2;
    else if (sel3) mux_op <= ip3;
  
//assertions

    property SEL1;
      @(negedge clk) (sel1 == 1) |=> (mux_op == ip1);
    endproperty
    property SEL2;
      @(negedge clk) (sel2 == 1) |=> (mux_op == ip2);
    endproperty
    property SEL3;
      @(negedge clk) (sel3 == 1) |=> (mux_op == ip3);
    endproperty

    A1: assert property (SEL1);
    A2: assert property (SEL2);
    A3: assert property (SEL3);


endmodule:mux_assert