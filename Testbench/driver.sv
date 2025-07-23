// Driver class to drive UART transactions to the DUT via the interface
class driver;
  
  virtual uart_if vif; // Virtual interface to connect to the DUT's UART signals
  
  transaction tr; // Transaction object to hold UART transaction data
  
  mailbox #(transaction) mbx; // Mailbox to receive transactions from the generator
  mailbox #(bit [7:0]) mbxds; // Mailbox to send transmitted or received data to the scoreboard
  
  event drvnext; // Event to signal completion of a transaction to the generator
  
  bit [7:0] din; // Temporary storage for input data (not used in the provided code)
  
  bit wr = 0; // Write operation flag (not used in the provided code)
  bit [7:0] datarx; // Stores received data during read operations
  
  // Constructor: Initializes mailboxes for transactions and data
  function new(mailbox #(bit [7:0]) mbxds, mailbox #(transaction) mbx);
    this.mbx = mbx; // Assign transaction mailbox
    this.mbxds = mbxds; // Assign data mailbox
  endfunction
  
  // Reset task: Initializes DUT signals and applies reset
  task reset();
    vif.rst <= 1'b1; // Assert reset
    vif.dintx <= 0; // Clear input data
    vif.newd <= 0; // Clear new data signal
    vif.rx <= 1'b1; // Set RX to idle state (high)
    repeat(5) @(posedge vif.uclktx); // Wait for 5 transmit clock cycles
    vif.rst <= 1'b0; // Deassert reset
    @(posedge vif.uclktx); // Wait for one more clock cycle
    $display("[DRV] : RESET DONE"); // Log reset completion
    $display("----------------------------------------"); // Separator for readability
  endtask
  
  // Main task to drive UART transactions
  task run();
    forever begin // Run continuously to process transactions
      mbx.get(tr); // Get a transaction from the generator via mailbox
      
      if(tr.oper == 1'b0)   begin // Write operation (data transmission)
        @(posedge vif.uclktx); // Wait for transmit clock edge
        vif.rst <= 1'b0; // Ensure reset is deasserted
        vif.newd <= 1'b1; // Assert new data signal to start transmission
        vif.rx <= 1'b1; // Keep RX idle
        vif.dintx = tr.dintx; // Drive input data to DUT
        @(posedge vif.uclktx); // Wait for next clock edge
        vif.newd <= 1'b0; // Deassert new data signal
        mbxds.put(tr.dintx); // Send transmitted data to scoreboard
        $display("[DRV]: Data Sent : %0d", tr.dintx); // Log transmitted data
        wait(vif.donetx == 1'b1); // Wait for transmission completion
        ->drvnext; // Signal generator that transaction is complete
      end
      
      else if (tr.oper == 1'b1) begin // Read operation (data reception)
        @(posedge vif.uclkrx); // Wait for receive clock edge
        vif.rst <= 1'b0; // Ensure reset is deasserted
        vif.rx <= 1'b0; // Start bit (low) for UART reception
        vif.newd <= 1'b0; // Ensure no new data signal
        @(posedge vif.uclkrx); // Wait for next clock edge
        for(int i=0; i<=7; i++) begin // Loop to receive 8 data bits
          @(posedge vif.uclkrx); // Wait for each receive clock edge
         //vif.rx <= $urandom; // Drive random data bit to RX
          datarx[i] = vif.rx; // Capture received bit
        end
        mbxds.put(datarx); // Send received data to scoreboard
        $display("[DRV]: Data RCVD : %0d", datarx); // Log received data
        wait(vif.donerx == 1'b1); // Wait for reception completion
        vif.rx <= 1'b1; // Return RX to idle state
        ->drvnext; // Signal generator that transaction is complete
      end
    end
  endtask
  
endclass
