`include "transaction.sv" // Include transaction class definition for data handling
`include "generator.sv"  // Include generator class for creating test stimuli
`include "driver.sv"     // Include driver class for driving signals to DUT
`include "monitor.sv"    // Include monitor class for observing DUT outputs
`include "scoreb.sv"     // Include scoreboard class for comparing expected vs. actual results
`include "envi.sv" // INCLUDE ALL THE EVENT MAILBOX & CLASS

module tb; // Testbench module definition
    
  uart_if vif(); // Instantiate UART interface to connect testbench to DUT
  
  // Instantiate the DUT (Design Under Test) with parameters: 1MHz clock frequency, 9600 baud rate
  uart_top #(1000000, 9600) dut (vif.clk, vif.rst, vif.rx, vif.dintx, vif.newd, vif.tx, vif.doutrx, vif.donetx, vif.donerx);
  
   
  initial begin // Initialize clock signal
    vif.clk <= 0; // Set clock to 0 at start
  end
    
  always #10 vif.clk <= ~vif.clk; // Generate 50MHz clock (20ns period) by toggling every 10ns
     assign vif.rx =vif.tx;
  environment env; // Declare environment object to manage test components (generator, driver, monitor, scoreboard)
    
  initial begin // Main testbench control block
    env = new(vif); // Create environment instance, passing the interface
    env.gen.count = 3; // Set generator to produce 5 transactions
    env.run(); // Start the environment to execute the test
  end
      
  initial begin // Waveform dump setup
    $dumpfile("dump.vcd"); // Specify VCD file for waveform output
    $dumpvars; // Dump all variables for debugging
  end
   
  // Connect DUT's internal UART clocks to interface signals
  assign vif.uclktx = dut.utx.uclk; // Assign transmit clock from DUT to interface
  assign vif.uclkrx = dut.rtx.uclk; // Assign receive clock from DUT to interface

    
endmodule
