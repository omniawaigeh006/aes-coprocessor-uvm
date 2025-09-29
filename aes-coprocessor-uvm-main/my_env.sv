class my_env extends uvm_env;
  `uvm_component_utils(my_env)

  my_agent      my_agent_h;
  my_subscriber my_subscriber_h;
  my_scoreboard my_scoreboard_h;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    my_agent_h      = my_agent::type_id::create("my_agent_h", this);
    my_subscriber_h = my_subscriber::type_id::create("my_subscriber_h", this);
    my_scoreboard_h = my_scoreboard::type_id::create("my_scoreboard_h", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    my_agent_h.aport.connect(my_subscriber_h.analysis_export);
    my_agent_h.aport.connect(my_scoreboard_h.aimp);
  endfunction

endclass
