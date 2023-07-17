`timescale 1ps/1ps
`include "byter.v"

module tb_byter ();
    reg clk;
    reg enable;
    reg [63:0] data_in;
    wire [7:0] byte_out;
    wire data_ready;

    byter byter_dut(clk, enable ,data_in, byte_out, data_ready);

    always #1 clk = ~clk;

    initial begin
        $dumpfile("byter.vcd");
        $dumpvars(0, tb_byter);

        clk = 0;
        enable = 1;
        c2b(958923234673456104);
        enable = 0;
        #5;
        enable = 1;
        c2b(95892349073456104);
        enable = 0;
        #15;
        $finish;
    end

    task c2b;
        input [63:0] data;
        if(enable)begin
            data_in = data;
            #18;
        end else begin
            $display("--- Module not enabled ---");
        end
    endtask
endmodule