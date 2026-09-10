module wrapper_spi #(
    parameter toggle_count = 5, // input/(2*output) for clk divider
    parameter addr_width = 8,
    parameter data_width = 8,
    parameter mem_depth = 256
) (
    //inputs from cpu
    input clk, // 50Mhz T=20ns
    input rst_n, //active low
    input start, //signal comming from cpu or testbench that indicates to start the transmission and recieving
    input [9:0] tx_data, ///transmitted 2 bit opcode + 8 bit data
    //outputs to the cpu
    output [7:0] rx_data,//data sent to cpu or testbench
    output tx_interrupt, //1 when transmiting is finished
    output rx_interrupt //1 when it is ready to read the rx_data
);

//internal wires between master and slave&ram
    //slave--->master
        wire MISO__MISO;
    //master--->slave
        wire CS_n__SS_n;
        wire sclk_out__sclk;
        wire MOSI__MOSI;

    spi_master #(.toggle_count(toggle_count)) S_M(
    //inputs form cpu
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .tx_data(tx_data),
    //internal wires with slave&ram
        .MISO(MISO__MISO),
        .CS_n(CS_n__SS_n),
        .sclk_out(sclk_out__sclk),
        .MOSI(MOSI__MOSI),
    //outputs to the cpu
        .tx_interrupt(tx_interrupt),
        .rx_interrupt(rx_interrupt),
        .rx_data(rx_data)
    );

    wrapper_slave_ram #(
        .data_width(data_width),
        .mem_depth(mem_depth),
        .addr_width(addr_width)
    ) W_S_R(
    //inputs from cpu
        .rst_n(rst_n),
    //internal wires with master
        .sclk(sclk_out__sclk),
        .SS_n(CS_n__SS_n),
        .MOSI(MOSI__MOSI),
        .MISO(MISO__MISO)
    );
endmodule