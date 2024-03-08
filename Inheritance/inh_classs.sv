
module counterclass3;
    
    class counter;
     int count;
     
     function new(input int start);
       count = start;
     endfunction
     
     function int getcount();
       return (count);
     endfunction
   
     function void load(input int value);
       count = value;
     endfunction
   
   endclass
   
   class upcounter extends counter;
   
     function new(input int start);
       super.new(start);
     endfunction
   
     function void next();
      for (int i=0; i<=10; i++) begin   /////////
       count++;
       $display("upcounter next %0d", count);
      end
     endfunction
   
    endclass
   
   class downcounter extends counter;
   
     function new(input int start);
       super.new(start);
     endfunction
   
     function void next();
      for (int i=0; i<=10; i++) begin   ///////////
       count--;
       $display("downcounter next %0d", count);
      end
      endfunction
      
   endclass   
       
   int countval;
   
   upcounter up1 = new(7);
   downcounter down2 = new(0);
   
   
   initial
     begin
   
     countval = up1.getcount();
     $display("getcount from up1 constructor %0d", countval);
     up1.next();
   
     countval = dn1.getcount();
        $display("getcount from down2 constructor %0d", countval);
     dn1.next();  
   
     end
   
   endmodule
   