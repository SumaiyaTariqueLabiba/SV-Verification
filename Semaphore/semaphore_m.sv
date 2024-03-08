
module semaphore_m ;

  timeunit 1ns;
  timeprecision 1ns;

  localparam int unsigned num_users = 2 ; //concurrent processes
  /*localparam*/ int unsigned arrival_time_min[num_users]='{default:1};
  /*localparam*/ int unsigned arrival_time_max[num_users]='{default:7};
  /*localparam*/ int unsigned service_time_min[num_users]='{default:1};
 /*localparam*/ int unsigned service_time_max[num_users]='{default:9};
  localparam int unsigned simulation_time_max = 100 ; 
  var bit running = 1 ;        //flag to disable concurrent processes


  semaphore semaphore_inst = new(1) ;

  /////shared resource////

  task limited_resource (input int unsigned service_time, 
                         inout int unsigned clobberable_var); // (#time) task consumes simulation time, has a shared var
    #service_time;    
  endtask



  //////user processes/////
  
  task automatic user (input string name, 
                       input int unsigned arrival_time_min, arrival_time_max,
                       input int unsigned service_time_min, service_time_max ) ;   // Auto-task randomly uses resource
    
    while (running) begin
        bit blocking;
        int unsigned arrival_time, service_time;
        int unsigned clobberable_var, clobberable_var_orig;
        bit success;

        success = randomize(blocking, arrival_time, service_time, clobberable_var) with
                  {
                  arrival_time_min <= arrival_time && arrival_time <= arrival_time_max;
                  service_time_min <= service_time && service_time <= service_time_max;
                  };
            if (!success) begin 
                $display("randomize failed"); 
                $finish; 
            end

        #arrival_time;  //(#time)
        $display("%t: %s get key %s", $time, name, blocking?"blocking":"nonblock");



        ///////Get key/////////

        if (blocking)
          semaphore_inst.get(1);       //Get key blocking
        else                           //Get key Non-blocking
          semaphore_inst.try_get(1)    ////////////////////////////////////////////?
          while (!semaphore_inst.try_get(1)) #1ns;

        $display("%t: %s got key", $time, name);


        clobberable_var_orig = clobberable_var;
        limited_resource(service_time, clobberable_var);
            if (clobberable_var !== clobberable_var_orig) begin
                $display("%t: %s clobberable_var got clobbered!", $time, name);
                $display("TEST FAILED");
                $finish(0);
            end
        $display("%t: %s put key", $time, name);



        ///////Put key/////////
        semaphore_inst.put(1);
       end

  endtask : user


  // Simulate
  initial begin
      $timeformat ( -9, 0, "ns", 5 ) ;


      if (semaphore_inst == null) begin     //no key in semaphore
          $display("Cannot construct semaphore");
          $finish(0);
        end

      for ( int unsigned i=0, string name="user0"; i<num_users; ++i, ++name[4] )
        begin
          fork user( name, arrival_time_min[i], arrival_time_max[i],
                           service_time_min[i], service_time_max[i] ) ;
          join_none
          #1ns ; // wait for process to start up
        end

      #simulation_time_max running <= 0 ; // after delay schedule shutdown
      wait fork ; // wait for shutdown
   
      $display("TEST COMPLETE");
      $finish(0);
  end

endmodule : semaphore_m
