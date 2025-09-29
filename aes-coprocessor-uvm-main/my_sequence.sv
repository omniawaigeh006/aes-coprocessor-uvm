class my_sequence extends uvm_sequence;
  `uvm_object_utils(my_sequence)

  int inputsFile;

  function new(string name = "my_sequence");
    super.new(name);
  endfunction

  task body();

    for (int i = 0; i < 500; i++) begin

      my_sequence_item my_sequence_item_h;
      my_sequence_item_h = my_sequence_item::type_id::create("my_sequence_item_h");

      start_item(my_sequence_item_h);

      if (!my_sequence_item_h.randomize()) `uvm_fatal(get_full_name(), "randomize failed")

      inputsFile = $fopen("D:/College/GP/aes-coprocessor-uvm/inputs.txt", "w");
      $fwrite(inputsFile, "%h\n%h", my_sequence_item_h.data, my_sequence_item_h.key);
      $fclose(inputsFile);
      $system("python D:/College/GP/aes-coprocessor-uvm/aes_model.py");

      finish_item(my_sequence_item_h);
    end

  endtask

endclass
