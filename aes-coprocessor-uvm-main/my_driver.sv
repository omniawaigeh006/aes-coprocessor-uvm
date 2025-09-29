class my_driver extends uvm_driver #(my_sequence_item);
  `uvm_component_utils(my_driver)

  virtual intf vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual intf)::get(this, "", "config_vif", vif))
      `uvm_fatal(get_full_name(), "vif does not exist")
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    forever begin
      my_sequence_item my_sequence_item_h;

      seq_item_port.get_next_item(my_sequence_item_h);
      
      create_assembly_program(my_sequence_item_h.data, my_sequence_item_h.key);
      restart_processor();

      // Wait for program execution to finish
      wait (vif.program_finished);
      // repeat (30000) @(posedge vif.clk);

      seq_item_port.item_done();
    end
  endtask

  task restart_processor();
    @(posedge vif.clk);

    vif.fetch_enable = 1'b0;
    vif.rst_n = 1'b1;

    // Reset
    #5 vif.rst_n = 1'b0;
    #5 vif.rst_n = 1'b1;

    // Enable fetch
    #5 vif.fetch_enable = 1'b1;

    // Must wait for at least 1 clk cycle after fetch_enable is asserted
    #(2 * CLK_PERIOD)
    
    @(posedge vif.clk);
  endtask

  // TODO: reformat the code
  task create_assembly_program(logic [127:0] DATA, logic [127:0] KEY);
    // bit [127:0] KEY = 128'h000102030405060708090a0b0c0d0e0f;
    // bit [127:0] DATA = 128'h00000001000000020000000300000004;
    bit [4:0] KEY_R[0:3] = {12, 13, 14, 15};
    bit [4:0] Data_R[0:3] = {7, 28, 29, 30};
    bit [31:0] LUI = 32'h00000037;
    bit [31:0] ADDI = 32'h00000013;
    int Prompt;
    int OutPut_file;
    byte indx = 127;
    string line;
    Prompt = $fopen("D:/College/GP/aes-coprocessor-uvm/firmware_temp.mem", "r");
    if (Prompt == 0) begin
      $display("Error: Could not open input file.");
      $finish;
    end

    OutPut_file = $fopen("D:/College/GP/aes-coprocessor-uvm/firmware_aes.mem", "w");
    if (OutPut_file == 0) begin
      $display("Error: Could not open temporary file.");
      $fclose(Prompt);
      $finish;
    end

    // Add ins

    for (int i = 0; i <= 3; i++) begin
      LUI[31-:20] = KEY[(indx)-:20];
      LUI[11-:5]  = KEY_R[i];
      $fwrite(OutPut_file, "%h\n", LUI);
      if (KEY[(indx-20)-:12] > 2047) begin
        ADDI[31-:12] = 2047;
        ADDI[11-:5]  = KEY_R[i];
        ADDI[19-:5]  = KEY_R[i];
        $fwrite(OutPut_file, "%h\n", ADDI);
        ADDI[31-:12] = KEY[(indx-20)-:12] - 2047;
        $fwrite(OutPut_file, "%h\n", ADDI);
      end else begin
        ADDI[31-:12] = KEY[(indx-20)-:12];
        ADDI[11-:5]  = KEY_R[i];
        ADDI[19-:5]  = KEY_R[i];
        $fwrite(OutPut_file, "%h\n", ADDI);
      end
      indx -= 32;
    end
    indx = 127;
    for (int i = 0; i <= 3; i++) begin
      LUI[31-:20] = DATA[(indx)-:20];
      LUI[11-:5]  = Data_R[i];
      $fwrite(OutPut_file, "%h\n", LUI);
      if (DATA[(indx-20)-:12] > 2047) begin
        ADDI[31-:12] = 2047;
        ADDI[11-:5]  = Data_R[i];
        ADDI[19-:5]  = Data_R[i];
        $fwrite(OutPut_file, "%h\n", ADDI);
        ADDI[31-:12] = DATA[(indx-20)-:12] - 2047;
        $fwrite(OutPut_file, "%h\n", ADDI);
      end else begin
        ADDI[31-:12] = DATA[(indx-20)-:12];
        ADDI[11-:5]  = Data_R[i];
        ADDI[19-:5]  = Data_R[i];
        $fwrite(OutPut_file, "%h\n", ADDI);
      end
      indx -= 32;
    end


    // copy inst
    while (!$feof(
        Prompt
    )) begin
      line = "";
      $fgets(line, Prompt);
      $fwrite(OutPut_file, "%s", line);
    end


    // Close the files
    $fclose(Prompt);
    $fclose(OutPut_file);
  endtask


endclass
