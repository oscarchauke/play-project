`timescale 1ps/1ps
`include "queue.v"

module tb_queue #(
parameter   DATA_WIDTH = 64,
            ADDRESS_WIDTH = 3,
            TOTAL_DATA = 2**ADDRESS_WIDTH
)();

reg                         sclk, reset, write_en, read_en;
reg     [DATA_WIDTH-1:0]    data_in, tempdata;
wire    [DATA_WIDTH-1:0]    data_out;

queue DUT_queue(sclk, reset, read_en, write_en, data_in, data_out, full, empty);

always
   #5 sclk = ~sclk;
initial begin
    $dumpfile("queue.vcd");
    $dumpvars(0, tb_queue);

    sclk = 0;
    reset = 1;
    tempdata = 0;
    data_in = 0;

    #15 reset = 0;

    push(1);
    push(256);
    push(3325);
    push(0);
    pop(tempdata);
    pop(tempdata);
    pop(tempdata);
    pop(tempdata);
    pop(tempdata);
    $finish;
    
end

task push;
    input [DATA_WIDTH-1:0] data;
    if(full)
        $display("---Cannot push: Buffer Full---");
    else begin
        data_in = data;
        write_en = 1;
        @(posedge sclk);
        #1 write_en = 0;
        $display("Pushed ", data);
    end
endtask

task pop;
    output [DATA_WIDTH-1:0] data;
    if(empty)
        $display("---Cannot Pop: Buffer Empty---");
    else begin
        read_en = 1;
        @(posedge sclk);
        #1 read_en = 0;
        data = data_out;
        $display("-------------------------------Poped ", data);
    end
endtask
endmodule