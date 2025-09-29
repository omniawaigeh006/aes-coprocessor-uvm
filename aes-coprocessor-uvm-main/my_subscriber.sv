class my_subscriber extends uvm_subscriber #(my_sequence_item);
  `uvm_component_utils(my_subscriber)

  my_sequence_item my_sequence_item_h;

  covergroup cvg;
    result_enc: coverpoint my_sequence_item_h.result_enc;
    result_dec: coverpoint my_sequence_item_h.result_dec;
  endgroup

  function new(string name, uvm_component parent);
    super.new(name, parent);
    cvg = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    my_sequence_item_h = my_sequence_item::type_id::create("my_sequence_item_h");
  endfunction

  function void write(my_sequence_item t);
    this.my_sequence_item_h = t;
    cvg.sample();
  endfunction

endclass
