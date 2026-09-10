module spi_ram (sclk , rst_n , rx_data , tx_data , rx_valid , tx_valid);

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
 
    reg [DATA_WIDTH-1:0] mem_array [0:MEM_DEPTH-1] ;
    reg [DATA_WIDTH-1:0] write_addr ;
    reg [DATA_WIDTH-1:0] read_addr ;
    reg [3:0] tx_count ;
    reg send_data_flag;

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
        tx_count <= 0 ;
        send_data_flag<= 0 ;

        /*else if (SS_n) begin
            tx_count <= 0 ;
        end*/
    end
    else begin
        if (rx_valid) begin
            case (rx_data [9:8])
                OP_WRITE_ADDR : write_addr <= rx_data [ADDR_WIDTH-1:0] ;
                OP_WRITE_DATA : mem_array[write_addr] <= rx_data [DATA_WIDTH-1:0] ;
                OP_READ_ADDR : read_addr <= rx_data [ADDR_WIDTH-1:0] ;
                OP_READ_DATA : begin
                tx_data <= mem_array[read_addr] ;
                send_data_flag<= 1 ;
               end
                default: tx_data <= 0 ;
            endcase
        end
        if(send_data_flag)begin
            if(tx_count<8)begin
                tx_count <= tx_count + 1 ;
                tx_valid <= 1 ;
            end
            else begin
                send_data_flag <= 0 ;
                tx_valid <= 0 ;
                tx_count <= 0 ;     
            end
        end
    end
end    
endmodule