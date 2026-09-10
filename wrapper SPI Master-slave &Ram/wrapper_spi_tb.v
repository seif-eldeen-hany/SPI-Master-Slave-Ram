`timescale 1ns/1ps
module wrapper_spi_tb;
//parameters
    parameter toggle_count = 5; // input/(2*output) for clk divider
    parameter DATA_WIDTH = 8;
    parameter MEM_DEPTH = 256;
    parameter ADDR_WIDTH = 8;

//inputs 

    reg clk; // 50Mhz T=20ns
    reg rst_n; //active low
    reg start; //signal comming from cpu or testbench that indicates to start the transmission and recieving
    reg [9:0] tx_data; ///transmitted 2 bit opcode + 8 bit data

//outputs
    wire tx_interrupt; //1 when transmiting is finished
    wire rx_interrupt; //1 when it is ready to read the rx_data
    wire [7:0] rx_data; //data sent to cpu or testbench

wrapper_spi #(
    .toggle_count(toggle_count),
    .DATA_WIDTH(DATA_WIDTH),
    .MEM_DEPTH(MEM_DEPTH),
    .ADDR_WIDTH(ADDR_WIDTH)
) W_S(
    //inputs from cpu
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .tx_data(tx_data),
    //outputs to the cpu
    .tx_interrupt(tx_interrupt),
    .rx_interrupt(rx_interrupt),
    .rx_data(rx_data)
);

initial begin
    clk = 1'b0;
    forever #10 clk = ~clk; //50Mhz clock
end

initial begin
	clk=0;
	rstn=0;
	start=0;
	counter=0;
	repeat(100) @(negedge clk);
	rstn=1;
	start=1;

	//write address
	tx_data=10'b0011001101;
	repeat(100) @(negedge clk);


	//write data
	tx_data=10'b0111001000;
	repeat(100) @(negedge clk);


	//read address
	tx_data=10'b1011001101;
	repeat(100) @(negedge clk);



	//read data
	tx_data=10'b1111001000;
	repeat(100) @(negedge clk);

	//write address
	tx_data=10'b0010110011;
	repeat(100) begin
		@(negedge clk);
	end

	
	repeat(100) begin
		@(posedge clk);
	end
	repeat(100) begin
		@(negedge clk);
	end
	$stop;
end

endmodule