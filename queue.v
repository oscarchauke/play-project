module queue
#(
    parameter   DATA_WIDTH = 64,
                ADDRESS_WIDTH = 3,
                TOTAL_DATA = 2**ADDRESS_WIDTH
) (
    input       sclk, reset, read_en, write_en,
    input       [DATA_WIDTH-1:0] write_data,
    output  reg [DATA_WIDTH-1:0] read_data,
    output  reg full, empty
);

reg [DATA_WIDTH-1:0]    queue_mem  [TOTAL_DATA-1:0];
reg [ADDRESS_WIDTH-1:0] read_ptr, write_ptr;
reg [DATA_WIDTH-1:0]    queue_counter;

always @(queue_counter) begin
    empty = (queue_counter == 0);
    full = (queue_counter == TOTAL_DATA);
end

always @(posedge sclk) begin
    if(write_en & ~full)begin
        if(write_data == 0)begin
            queue_mem[write_ptr] <= (queue_mem[write_ptr-1] + queue_mem[write_ptr-2]) / 2;
        end else
            queue_mem[write_ptr] <= write_data;
    end

    if(read_en & ~empty)begin
        read_data <= queue_mem[read_ptr];
    end
end

always @(posedge sclk or posedge reset) begin
    if(reset)
        queue_counter <= 0;
    
    if(~full && write_en)
        queue_counter <= queue_counter + 1;

    if(~empty && read_en)
        queue_counter <= queue_counter - 1;
end

always @(posedge sclk or posedge reset) begin
    if(reset)begin
        write_ptr <= 0;
        read_ptr <= 0;
    end

    if(~full && write_en)
        write_ptr <= write_ptr + 1;
    
    if(~empty && read_en)
        read_ptr <= read_ptr + 1;
end
endmodule