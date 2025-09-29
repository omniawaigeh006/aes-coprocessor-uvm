module top ();
  import uvm_pkg::*;
  import my_pkg::*;

  intf my_intf ();
  dut #(.CLK_PERIOD(CLK_PERIOD)) my_dut (my_intf);

  initial begin
    uvm_config_db#(virtual intf)::set(null, "uvm_test_top", "config_vif", my_intf);
    run_test("my_test");
  end

endmodule
