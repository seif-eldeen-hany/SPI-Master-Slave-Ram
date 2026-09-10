module spi_ram (sclk,rst_n,tx_valid,rx_valid,tx_data,rx_data);
parameter addr_width=8;
parameter data_width=8;
parameter mem_depth=256;
    
input sclk,rst_n,rx_valid;
input [data_width+1:0] rx_data;
output reg tx_valid;
output reg [data_width-1:0] tx_data;

reg [data_width-1:0] read_adr;
reg [data_width-1:0] write_adr;
reg [data_width-1:0] mem_array [0:mem_depth-1];
reg tx_valid_unstretched;
integer i;

always @(posedge sclk or negedge rst_n) begin
    if (~rst_n) begin
        for(i=0 ; i<mem_depth ; i=i+1) begin
        	mem_array[i] <= 0;
    	end
        tx_data <= 0;
        tx_valid_unstretched<= 0; 
        write_adr <= 0;
        read_adr <= 0;
    end

    else begin
       tx_valid_unstretched <= 0;
        if (rx_valid) begin 
            case (rx_data [data_width+1:data_width])
            2'b00: write_adr <= rx_data [data_width-1:0];
            2'b01: begin
                mem_array [write_adr] <= rx_data [data_width-1:0];
            end
            2'b10: read_adr <= rx_data [data_width-1:0];
            2'b11: begin
                tx_data <= mem_array [read_adr];
                tx_valid_unstretched <= 1;
            end
            endcase
    	end
    end
end
always @(negedge sclk or negedge rst_n) begin
    if (~rst_n) begin
        tx_valid <= 0;
    end
    else 
    tx_valid <= tx_valid_unstretched;
end
endmodule