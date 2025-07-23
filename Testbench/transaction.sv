// Transaction class defines the data structure for UART transactions
class transaction;
  
  // Define an enumerated type for operation type (write or read)
  typedef enum bit  {write = 1'b0, read = 1'b1} oper_type;
  
  // Random cyclic variable for selecting operation type (write or read)
  randc oper_type oper;
  
  // UART receive signal (input to DUT)
  bit rx;
  
  // Random 8-bit data input for UART transmission
  rand bit [7:0] dintx;
  
  // Control signal to indicate new data is available
  bit newd;
  
  // UART transmit signal (output from DUT)
  bit tx;
  
  // 8-bit data output from UART receiver
  bit [7:0] doutrx;
  
  // Signal indicating transmission is complete
  bit donetx;
  
  // Signal indicating reception is complete
  bit donerx;
  
  // Function to create a deep copy of the transaction object
  function transaction copy();
    copy = new(); // Create a new transaction object
    copy.rx = this.rx; // Copy receive signal
    copy.dintx = this.dintx; // Copy input data
    copy.newd = this.newd; // Copy new data signal
    copy.tx = this.tx; // Copy transmit signal
    copy.doutrx = this.doutrx; // Copy output data
    copy.donetx = this.donetx; // Copy transmit done signal
    copy.donerx = this.donerx; // Copy receive done signal
    copy.oper = this.oper; // Copy operation type
  endfunction
  
endclass
