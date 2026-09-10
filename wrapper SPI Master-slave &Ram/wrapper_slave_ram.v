module wrapper_slave_ram #(
parameter addr_width=8,
parameter data_width=8,
parameter mem_depth=256
) (
    //inputs from cpu and master
    input rst_n,
    input sclk,
    input SS_n,
    input MOSI,
    //outputs to master
    output MISO 
);
    localparam [2:0] idle=3'b000;
    localparam [2:0] check=3'b001; 
    localparam [2:0] write=3'b010; 
    localparam [2:0] read_addr=3'b011;
    localparam [2:0] read_data=3'b100;

    wire [data_width-1:0] tx_data;
    wire tx_valid;
    wire [data_width+1:0] rx_data;
    wire rx_valid;

    spi_slave #(.data_width(data_width)) S_S(
        .sclk(sclk),
        .rst_n(rst_n),
        .SS_n(SS_n),
        .MOSI(MOSI),
        .tx_data(tx_data),
        .MISO(MISO),
        .rx_data(rx_data),
        .rx_valid(rx_valid),
        .tx_valid(tx_valid)
    );

    spi_ram #(
        .addr_width(addr_width),
        .data_width(data_width),
        .mem_depth(mem_depth)) 
        S_R(
        .sclk(sclk),
        .rst_n(rst_n),
        .tx_valid(tx_valid),
        .rx_valid(rx_valid),
        .tx_data(tx_data),
        .rx_data(rx_data)
    );
endmodule