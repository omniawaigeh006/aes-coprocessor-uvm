class my_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(my_scoreboard)

  my_sequence_item my_sequence_item_h;

  uvm_analysis_imp #(my_sequence_item, my_scoreboard) aimp;

  int enc_pass_count, enc_fail_count, enc_no_output_count;
  int dec_pass_count, dec_fail_count;
  int total_transactions_count;

  logic [127:0] golden_model_out;
  int outputFile;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    my_sequence_item_h = my_sequence_item::type_id::create("my_sequence_item_h");

    aimp = new("aimp", this);
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);

    `uvm_info(get_full_name(), $sformatf(
              "\nTotal transactions count: %0d
              \n---Encryption---\nPass count: %0d\nFail count: %0d\nNo output count: %0d\n
              \n---Decryption---\nPass count: %0d\nFail count: %0d\n",
              total_transactions_count,
              enc_pass_count,
              enc_fail_count,
              enc_no_output_count,
              dec_pass_count,
              dec_fail_count,
              ), UVM_LOW);

  endfunction

  function void write(my_sequence_item t);
    total_transactions_count++;

    // Decryption
    if (t.data == t.result_dec) begin
      $display("TX %0d, Decryption passed: Original data: %h, Processor output: %h",
               total_transactions_count, t.data, t.result_dec);
      dec_pass_count++;
    end else begin
      $display("TX %0d, Decryption failed: Original data: %h, Processor output: %h",
               total_transactions_count, t.data, t.result_dec);
      dec_fail_count++;
    end

    // Encryption
    outputFile = $fopen("D:/College/GP/aes-coprocessor-uvm/output.txt", "r");

    if ($fscanf(outputFile, "%h", golden_model_out) != 1) begin
      $display("TX %0d, No encryption output", total_transactions_count);
      enc_no_output_count++;
    end else if (golden_model_out == t.result_enc) begin
      $display("TX %0d, Encryption passed: Golden model output: %h, Processor output: %h",
               total_transactions_count, golden_model_out, t.result_enc);
      enc_pass_count++;
    end else begin
      $display("TX %0d, Encryption failed: Golden model output: %h, Processor output: %h",
               total_transactions_count, golden_model_out, t.result_enc);
      enc_fail_count++;
    end

    $fclose(outputFile);

  endfunction

endclass
