// Generator class to create and send randomized transactions to the driver and scoreboard
class generator;
  
  transaction tr; // Transaction object to hold UART transaction data
  
  mailbox #(transaction) mbx; // Mailbox to send transactions to other components (e.g., driver)
  
  event done; // Event to signal completion of transaction generation
  
  int count = 0; // Number of transactions to generate, set externally
  
  event drvnext; // Event to synchronize with driver completion
  event sconext; // Event to synchronize with scoreboard completion
  
  // Constructor: Initializes mailbox and creates a new transaction object
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx; // Assign the provided mailbox
    tr = new(); // Instantiate a new transaction object
  endfunction
  
  // Main task to generate and send transactions
  task run();
    repeat(count) begin // Repeat for the specified number of transactions
      assert(tr.randomize) else $error("[GEN] :Randomization Failed"); // Randomize transaction fields, report error if randomization fails
      mbx.put(tr.copy); // Send a copy of the transaction to the mailbox
      $display("[GEN]: Oper : %0s Din : %0d", tr.oper.name(), tr.dintx); // Display operation type and input data
      @(drvnext); // Wait for driver to complete processing the transaction
      @(sconext); // Wait for scoreboard to complete processing the transaction
    end
    
    -> done; // Trigger done event to signal completion of all transactions
  endtask
  
endclass
