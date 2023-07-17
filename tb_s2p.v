`timescale 1ps/1ps
`include "s2p.v"

module tb_s2p ();
  reg clk;
  reg serial_in;
  reg enable;
  wire [63:0] data_out;
  wire data_valid;
  
  reg [63:0] temp;

  s2p DUT_s2p(clk, serial_in, enable, data_out, data_valid);

  always #1 clk = ~clk;
  initial begin
    $dumpfile("s2p.vcd");
    $dumpvars(0, tb_s2p);

    clk = 0;
    #10;
    enable = 1;
    serial_in = 1;
    c2p(temp);
    enable = 0;
    #10;
    $finish;
  end

  task c2p;
    output [63:0] data;
    if(enable)begin
        data = data_out;
        #130;
    end else begin
        $display("--- Module not enabled ---");
    end
  endtask
endmodule