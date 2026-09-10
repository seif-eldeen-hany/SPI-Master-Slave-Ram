module wrapper_spi_tb;
reg clk;
reg rst_n;
reg start;
reg [9:0] tx_data;

wire tx_interrupt;
wire rx_interrupt;
wire [7:0] rx_data;

wrapper_spi dut(
	.clk(clk),
	.rst_n(rst_n),
	.start(start),
	.tx_data(tx_data),
	.tx_interrupt(tx_interrupt),
	.rx_interrupt(rx_interrupt),
	.rx_data(rx_data)
	);

always #5 clk=~clk;

initial begin
	clk=0;
	rst_n=0;
	start=0;
	@(negedge clk);
	rst_n=1;
	start=1;

	//write data
	tx_data=10'b0011001101;
	repeat(100)begin
		@(negedge clk);
	end

	//write address
	tx_data=10'b0110110011;
	repeat(100) begin
		@(negedge clk);
	end


	//read address
	tx_data=10'b1011001101;
	repeat(100) begin
		@(negedge clk);
	end


	//read data
	tx_data=10'b1100110011;
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
