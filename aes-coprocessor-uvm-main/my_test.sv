class my_test extends uvm_test;
  `uvm_component_utils(my_test)

  my_env my_env_h;
  my_sequence my_sequence_h;

  virtual intf vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    my_env_h = my_env::type_id::create("my_env_h", this);
    my_sequence_h = my_sequence::type_id::create("my_sequence_h");

    if (!uvm_config_db#(virtual intf)::get(this, "", "config_vif", vif))
      `uvm_fatal(get_full_name(), "vif does not exist")

    uvm_config_db#(virtual intf)::set(this, "*", "config_vif", vif);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    phase.raise_objection(this);
    my_sequence_h.start(my_env_h.my_agent_h.my_sequencer_h);
    phase.drop_objection(this);
  endtask

endclass
