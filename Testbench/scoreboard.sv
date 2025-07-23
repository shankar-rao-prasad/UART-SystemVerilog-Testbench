// Scoreboard class to compare data from driver and monitor
class scoreboard;
  mailbox #(bit [7:0]) mbxds, mbxms; // Mailboxes for driver data (mbxds) and monitor data (mbxms)
  
  bit [7:0] ds; // Data received from driver (transmitted or received data)
  bit [7:0] ms; // Data received from monitor (observed TX or RX data)
  
  event sconext; // Event to signal generator that comparison is complete
  
  // Constructor: Initializes mailboxes for driver and monitor data
  function new(mailbox #(bit [7:0]) mbxds, mailbox #(bit [7:0]) mbxms);
    this.mbxds = mbxds; // Assign driver mailbox
    this.mbxms = mbxms; // Assign monitor mailbox
  endfunction
  
  // Main task to compare driver and monitor data
  task run();
    forever begin // Run continuously to process data
      mbxds.get(ds); // Get data from driver (dintx for write, datarx for read)
      mbxms.get(ms); // Get data from monitor (srx for TX, rrx for RX)
      
      $display("[SCO] : DRV : %0d MON : %0d", ds, ms); // Log driver and monitor data
      if(ds == ms) // Compare driver and monitor data
        $display("DATA MATCHED"); // Log success if data matches
      else
        $display("DATA MISMATCHED"); // Log failure if data does not match
      
      $display("----------------------------------------"); // Separator for readability
      
      ->sconext; // Trigger event to signal generator that comparison is complete
    end
  endtask
endclass
