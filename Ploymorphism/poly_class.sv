
module counterclass_poly;
    
   virtual class counter;     
     int count;
     int max, min;
     
     function new(input int start, upper, lower);
       check_limit(upper, lower);
       check_set(start);
     endfunction

     function int getcount();
       return (count);
     endfunction
   
     function void load(input int value);
       check_set(value);
     endfunction
   
     virtual function void next();
       $display("counter class");
     endfunction
   
     function void check_limit (input int upper, lower);
        if (lower > upper) begin
          $display("lower bound %0d > upper bound %0d - bounds swapped", lower, upper);
          max = lower;
          min = upper;
          end
        else begin
          max = upper;
          min = lower;
        end
      endfunction
    
      function void check_set(input int set);
        if ((set < min) || (set > max))
          begin
          $display("count set value %0d outside bounds %0d to %0d - set to min", set, min, max);
          count = min;
          end
        else
          count = set;
      endfunction

   endclass
   
   class upcounter extends counter;
   
     logic carry;
     function new(input int start, upper, lower);
       super.new(start, upper, lower);     
     endfunction
   
     virtual function void next();  //"virtual" keyword optiinal in subclasses
       if (count == max) begin
         carry = 1;
         count = min;
       end
       else begin
         carry = 0;
            for (int i=count; i<=max; i++) begin    
            count++;
            $display("upcounter next %0d %0d",count,carry);  
            end
       end
     endfunction
   
   endclass
   
   class downcounter extends counter;
   
     logic borrow;
     function new(input int start, upper, lower);
       super.new(start, upper, lower);     
     endfunction
   
     virtual function void next(); //"virtual" keyword optional
       if (count == min) begin
         borrow = 1;
         count = max;
       end
       else begin
         borrow = 0; 
               for (int i=count; i>=min; i--) begin   
                count--;
                $display("downcounter next %0d %0d", count, borrow);  ///////
               end 
       end
      endfunction
      
   endclass   
   
   counter c1, c2;
   upcounter u1;
   downcounter d1; 
   
     initial begin
        u1 = new(0,7,0);    ///////////////
        c1 = u1;     // copy upconter instance to counter handle
        c1.next();   //contains (u1) instances, as next() is virtual
           $display("call next from counter handle");
    /*    
        d1 = new(7,7,0);
        c2 = d1;
        c2.next();
           $display("call next from counter handle");
    */    
       end

     initial begin
        #40000ns $display("Simulation timeout!");
                $finish;
     end 
   
   endmodule
   