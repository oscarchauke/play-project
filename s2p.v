module s2p #(
parameter   DATA_WIDTH = 64,
            ADDRESS_WIDTH = 3,
            TOTAL_DATA = 2**ADDRESS_WIDTH
)(
    input clk, serial_in,
    input enable,
    output reg [DATA_WIDTH-1:0] data_out,
    output reg data_valid
);

reg [6:0] bit_count;
reg [DATA_WIDTH-1:0] shift_reg;

initial begin
    bit_count <= 0;
    shift_reg <= 0;
end

always @(posedge clk) begin
    if(enable)begin
        shift_reg[bit_count] <= serial_in;
        bit_count <= bit_count + 1;
        data_valid <= 0;

        if (bit_count == 64) begin
            data_out = shift_reg;
            data_valid <= 1;
            shift_reg <= 0;
            bit_count <= 0;
        end
    end
end

endmodule