module byter (
    input   clk,
    input   enable,
    input   [63:0] data_in,
    output  reg [7:0] byte_out,
    output  reg data_valid
);

reg [3:0] byte_counter;

initial begin
    byte_counter = 0;
end

always @(posedge clk) begin
    if(enable)begin
        case (byte_counter)
            0:  byte_out <= data_in[7:0];
            1:  byte_out <= data_in[15:8];
            2:  byte_out <= data_in[23:16];
            3:  byte_out <= data_in[31:24];
            4:  byte_out <= data_in[39:32];
            5:  byte_out <= data_in[47:40];
            6:  byte_out <= data_in[55:48];
            7:  byte_out <= data_in[63:56];
            default: byte_out <= 0;
        endcase
        byte_counter <= byte_counter + 1;
        if (byte_counter == 8)begin
            data_valid <= 0;
            byte_counter <= 0;
        end else begin
            data_valid <= 1;
        end
    end
end

endmodule
