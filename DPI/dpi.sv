
`include "math.sv"
module dpi;

// import functions from C stdlib.h:
import "DPI" function int system ( input string s );
import "DPI" function string getenv ( input string name );

// import functions from C math.h:
import "DPI" function real sin ( input real arg );

string syscmd;
real x,y;
int ok;

initial begin
  ok = system( "echo 'hello world'");
  $display("date");
  ok = system( "date");

  $display("UNIX PATH = %s", getenv( "PATH" ) );

  for (int i =0; i<8; i++) begin
  x = `M_PI_4 * i;  // from math.sv: pi/2
  y =  sin( x );
  $display("sin( %f ) = %f", x, y);
  end
end

endmodule
