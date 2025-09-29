package my_pkg;
  localparam int CLK_PERIOD = 10;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "my_sequence_item.sv"
  typedef uvm_sequencer #(my_sequence_item) my_sequencer;
  `include "my_sequence.sv"
  `include "my_driver.sv"
  `include "my_monitor.sv"
  `include "my_scoreboard.sv"
  `include "my_subscriber.sv"
  `include "my_agent.sv"
  `include "my_env.sv"
  `include "my_test.sv"
  
endpackage
