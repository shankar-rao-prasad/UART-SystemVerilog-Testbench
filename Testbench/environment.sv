// Environment class to coordinate testbench components
class environment;
 
  generator gen; // Generator instance to create transactions
  driver drv; // Driver instance to drive transactions to DUT
  monitor mon; // Monitor instance to observe DUT signals
  scoreboard sco; // Scoreboard instance to compare driver and monitor data
  
  event nextgd; // Event for generator-driver synchronization
  event nextgs; // Event for generator-scoreboard synchronization
  
  mailbox #(transaction) mbxgd; // Mailbox for generator-to-driver transactions
  mailbox #(bit [7:0]) mbxds; // Mailbox for driver-to-scoreboard data
  mailbox #(bit [7:0]) mbxms; // Mailbox for monitor-to-scoreboard data
  
  virtual uart_if vif; // Virtual interface to connect components to DUT
  
  // Constructor: Initializes components, mailboxes, and interface connections
  function new(virtual uart_if vif);
    mbxgd = new(); // Create generator-driver mailbox
    mbxms = new(); // Create monitor-scoreboard mailbox
    mbxds = new(); // Create driver-scoreboard mailbox
    
    gen = new(mbxgd); // Instantiate generator with generator-driver mailbox
    drv = new(mbxds, mbxgd); // Instantiate driver with driver-scoreboard and generator-driver mailboxes
    mon = new(mbxms); // Instantiate monitor with monitor-scoreboard mailbox
    sco = new(mbxds, mbxms); // Instantiate scoreboard with driver-scoreboard and monitor-scoreboard mailboxes
    
    this.vif = vif; // Assign interface to environment
    drv.vif = this.vif; // Connect driver to interface
    mon.vif = this.vif; // Connect monitor to interface
    
    gen.sconext = nextgs; // Connect generator's sconext to environment's nextgs
    sco.sconext = nextgs; // Connect scoreboard's sconext to environment's nextgs
    gen.drvnext = nextgd; // Connect generator's drvnext to environment's nextgd
    drv.drvnext = nextgd; // Connect driver's drvnext to environment's nextgd
  endfunction
  
  // Pre-test task: Performs reset before starting test
  task pre_test();
    drv.reset(); // Call driver's reset task to initialize DUT
  endtask
  
  // Test task: Runs all components concurrently
  task test();
    fork
      gen.run(); // Start generator to create transactions
      drv.run(); // Start driver to drive transactions
      mon.run(); // Start monitor to observe DUT signals
      sco.run(); // Start scoreboard to compare data
    join_any // Continue when any thread completes
  endtask
  
  // Post-test task: Waits for test completion and terminates simulation
  task post_test();
    wait(gen.done.triggered); // Wait for generator to signal completion
    $finish(); // Terminate simulation
  endtask
  
  // Main task to orchestrate the test sequence
  task run();
    pre_test(); // Run reset
    test(); // Run concurrent test components
    post_test(); // Wait for completion and finish
  endtask
endclass
