
interface mailbox_if ;

  timeunit       1ns;
  timeprecision 10ps;
  import trans_pkg::*;

  mailbox mbox = new;

  function int num() ;
    return mbox.num() ;  //returns he number of items in malbox
  endfunction : num


  modport put_port (import num, put, try_put);
  modport get_port (import num, get, try_get, peek, try_peek);

////////////////////Blocking Put/////////////////

  task automatic put(ref my_tr_base_c my_tr_base) ;   /*we need to pass the base transaction class handle by reference as passing by value copies only the base parts, hus we must make the task automatic */
    my_tr_config_c my_tr_config ;  //handes
    my_tr_synch_c  my_tr_synch  ;
    my_tr_comms_c  my_tr_comms  ;

         if ( my_tr_base.get_type() == "my_tr_config_c" ) begin
              mbox.put(my_tr_config) ;
                 if ($cast(my_tr_config, my_tr_base) == 0 ) begin 
                     $display("Cannot cast trans class"); 
                     $finish(0); 
                 end
         end

         else if ( my_tr_base.get_type() == "my_tr_synch_c") begin 
             mbox.put(my_tr_synch) ;
                if ($cast(my_tr_synch, my_tr_base) == 0 ) begin 
                    $display("Cannot cast trans class"); 
                    $finish(0); 
                end
         end

         else if ( my_tr_base.get_type() == "my_tr_comms_c" ) begin
            mbox.put(my_tr_comms) ; 
               if ($cast(my_tr_comms, my_tr_base) == 0 ) begin 
                   $display("Cannot cast trans class"); 
                   $finish(0); 
               end
         end
  endtask : put

////////////////////Non-blocking Put/////////////////

  function automatic int try_put(ref my_tr_base_c my_tr_base) ;
    my_tr_config_c my_tr_config ;
    my_tr_synch_c  my_tr_synch  ;
    my_tr_comms_c  my_tr_comms  ;

         if ( my_tr_base.get_type() == "my_tr_config_c" )begin 
              return mbox.try_put(my_tr_config) ;
              if ($cast(my_tr_config, my_tr_base) == 0 ) begin 
                  $display("Cannot cast trans class"); 
                  $finish(0); 
              end
         end

         else if (my_tr_base.get_type() == "my_tr_synch_c" ) begin 
                  return mbox.try_put(my_tr_synch) ;
                  if ($cast(my_tr_synch, my_tr_base) == 0 ) begin 
                      $display("Cannot cast trans class"); 
                      $finish(0); 
                  end
         end 

         else if (my_tr_base.get_type() == "my_tr_comms_c" ) begin
                  return mbox.try_put(my_tr_comms) ;
                  if ($cast(my_tr_comms, my_tr_base) == 0 ) begin 
                      $display("Cannot cast trans class"); 
                      $finish(0); 
                  end
         end
  endfunction : try_put


////////////////////Blocking Get/////////////////

  task automatic get(ref my_tr_base_c my_tr_base) ;
    mbox.get(my_tr_base) ;
  endtask : get


////////////////////Non-blocking Get/////////////////

  function automatic int try_get(ref my_tr_base_c my_tr_base) ;
    return mbox.try_get(my_tr_base) ;
  endfunction : try_get


////////////////////Blocking Peek/////////////////

  task automatic peek(ref my_tr_base_c my_tr_base) ;
    mbox.peek(my_tr_base) ;
  endtask : peek

////////////////////Non-blocking Peek/////////////////
 
  function automatic int try_peek(ref my_tr_base_c my_tr_base) ;
    return mbox.try_peek(my_tr_base) ;
  endfunction : try_peek

endinterface : mailbox_if
