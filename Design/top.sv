`include "tx.sv"
`include "rx.sv"


module uart_top
#(
parameter clk_freq = 1000000,
parameter baud_rate = 9600
)
(
  input clk,rst, 
  input rx,
  input [7:0] dintx,
  input newd,
  output tx, 
  output [7:0] doutrx,
  output donetx,
  output donerx
    );
    
uarttx 
#(clk_freq, baud_rate) 
utx   
(clk, rst, newd, dintx, tx, donetx);   
 
uartrx 
#(clk_freq, baud_rate)
rtx
(clk, rst, rx, donerx, doutrx);    
    
    
endmodule

interface uart_if;
  logic clk;
  logic uclktx;
  logic uclkrx;
  logic rst;
  logic rx;
  logic [7:0] dintx;
  logic newd;
  logic tx;
  logic [7:0] doutrx;
  logic donetx;
  logic donerx;
  
endinterface
