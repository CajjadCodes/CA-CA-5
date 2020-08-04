module Controller(clk, rst, MemRead, HMbar, MMDataReady, MMRead, CacheWrite, DataSelect, DataReady);
input clk;
input rst;
input MemRead;
input HMbar;
input MMDataReady;
output MMRead;
output CacheWrite;
output DataSelect;
output DataReady;

	wire DataReadySel;
	StateMachine SM(
		.clk(clk),
		.rst(rst),
		.MemRead(MemRead),
		.HMbar(HMbar),
		.MMDataReady(MMDataReady),
		.MMRead(MMRead),
		.CacheWrite(CacheWrite),
		.DataSelect(DataSelect),
		.DataReadySel(DataReadySel)
	);

	assign MemRead_and_HMbar = MemRead & HMbar;
	assign DataReady = DataReadySel ? 1'b1 : MemRead_and_HMbar;

endmodule