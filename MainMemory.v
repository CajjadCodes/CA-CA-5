module MainMemory(clk, rst, address, read, dataReady, data, dataBlock);
input clk;
input rst;
input [14:0] address;
input read;
output reg dataReady;
output reg [31:0] data;
output reg [127:0] dataBlock;

	reg signed [31:0] main_memory [0:32767];

	always @(posedge read) begin
		dataReady = 1'b0;
		#10000
		data = main_memory[address];
		dataBlock = {main_memory[address[14:2]]};
		dataReady = 1'b1;
	end

	integer i;
	initial begin
		for (i = 0; i < 32767; i = i + 1) begin
			main_memory[i] = $random;

		end
	end


endmodule 