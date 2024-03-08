
package trans_pkg ;

  virtual class my_tr_base_c ;
    int unsigned id   ; // transaction number
    int unsigned addr ;
    protected static int unsigned count = 0 ;

    function new ;
      id = ++count ;
    endfunction

    virtual function string get_type ;
    endfunction

  endclass


  // configuration transaction

  class my_tr_config_c extends my_tr_base_c ;
    function new(int unsigned config) ;
      super.new() ;
      this.config = config ;
    endfunction

    function string get_type ;
      return "my_tr_config_c" ;
    endfunction

    local int unsigned config ; // meaningless incremental property
  endclass


  // synchronization transaction

  class my_tr_synch_c extends my_tr_base_c ;
    function new(int unsigned synch) ;
      super.new() ;
      this.synch = synch ;
    endfunction

    function string get_type ;
      return "my_tr_synch_c" ;
    endfunction

    local int unsigned synch ; // meaningless incremental property
  endclass


  // communications transaction

  class my_tr_comms_c extends my_tr_base_c ;
    function new(int unsigned comms) ;
      super.new() ;
      this.comms = comms ;
    endfunction

    function string get_type ;
      return "my_tr_comms_c" ;
    endfunction
    
    local int unsigned comms ; // meaningless incremental property
  endclass

endpackage : trans_pkg
