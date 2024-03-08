
module counterclass1;
    
    class counter;
     int count;
     
     function int getcount();
       return (count);
     endfunction
   
     function void load(input int value);
       count = value;
     endfunction
      
    endclass   
       
   int countval;
   
   counter c1 = new;
   
   
   initial begin
     countval = c1.getcount();
     $display("getcount %0d", countval);
   
     c1.load(3); 
     countval = c1.getcount();
     $display("getcount %0d", countval);
    end
   
   endmodule