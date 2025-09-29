interface intf ();
  logic clk;
  logic rst_n;
  logic fetch_enable;

  logic program_finished;
  logic [127:0] data;
  // logic [127:0] key;
  logic [127:0] result_enc;
  logic [127:0] result_dec;

  modport dut_if(
      input clk,
      input rst_n,
      input fetch_enable,

      output program_finished,
      output data,
      output result_enc,
      output result_dec
  );

endinterface
