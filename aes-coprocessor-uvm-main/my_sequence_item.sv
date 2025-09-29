class my_sequence_item extends uvm_sequence_item;
  `uvm_object_utils(my_sequence_item)

  rand logic [127:0] data;
  rand logic [127:0] key;
  logic [127:0] result_enc;
  logic [127:0] result_dec;
  
  function new(string name = "my_sequence_item");
    super.new(name);
  endfunction

endclass
