class my_monitor extends uvm_monitor;
  `uvm_component_utils(my_monitor)

  virtual intf                          vif;

  uvm_analysis_port #(my_sequence_item) aport;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual intf)::get(this, "", "config_vif", vif))
      `uvm_fatal(get_full_name(), "vif does not exist")

    aport = new("aport", this);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    forever begin
      my_sequence_item my_sequence_item_h;
      my_sequence_item_h = my_sequence_item::type_id::create("my_sequence_item_h");

      @ (posedge vif.program_finished);

      my_sequence_item_h.data = vif.data;
      // my_sequence_item_h.key = vif.key;
      my_sequence_item_h.result_enc = vif.result_enc;
      my_sequence_item_h.result_dec = vif.result_dec;

      aport.write(my_sequence_item_h);
    end
  endtask

endclass
