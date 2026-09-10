module RAM (sclk , rst_n , rx_data , tx_data , rx_valid , tx_valid);

    parameter DATA_WIDTH = 8 ;
    parameter MEM_DEPTH = 256 ;
    parameter ADDR_WIDTH = 8 ;

    input sclk , rst_n , rx_valid ;
    input [9:0] rx_data ;
    output reg tx_valid ;
    output reg [7:0] tx_data ;

    localparam OP_WRITE_ADDR = 2'b00 ;
    localparam OP_WRITE_DATA = 2'b01 ;
    localparam OP_READ_ADDR = 2'b10 ;
    localparam OP_READ_DATA = 2'b11 ;
 
    reg [DATA_WIDTH:0] mem_array [0:MEM_DEPTH-1] ;
    reg [DATA_WIDTH-1:0] write_addr ;
    reg [DATA_WIDTH-1:0] read_addr ;

    integer i ;

always @(posedge sclk , negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0 ; i < MEM_DEPTH ; i = i + 1 ) begin
            mem_array[i] <= 0 ;
        end
        tx_data <= 0 ;
        tx_valid <= 0 ;
        write_addr <= 0 ;
        read_addr <= 0 ;
    end

    else begin
        tx_valid <= 0 ;
        if (rx_valid) begin
            case (rx_data [9:8])
               OP_WRITE_ADDR : write_addr <= rx_data [DATA_WIDTH-1:0] ;
               OP_WRITE_DATA : mem_array[write_addr] <= rx_data [DATA_WIDTH-1:0]
               OP_READ_ADDR : read_addr <= rx_data [DATA_WIDTH-1:0] ;
               OP_READ_DATA : begin
                tx_data <= mem_array[read_addr] ;
                tx_valid <= 1 ;
               end
                default: tx_data <= 0 ;
            endcase
        end
    end
end    
endmodule