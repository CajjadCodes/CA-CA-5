module MemoryHierarchy(clk, rst, address, MemRead, data, DataReady, HMbar);
input clk;
input rst;
input [14:0] address;
input MemRead;
output [31:0] data;
output DataReady;
output HMbar;


	wire [127:0] MMDataBlock;
	wire [31:0] MMData, CacheData;
	wire CacheWrite, MMRead, MMDataReady, DataSelect;

	Cache cache(
		.clk(clk), 
		.rst(rst), 
		.adr(address), 
		.WriteDataBlock(MMDataBlock), 
		.Write(CacheWrite), 
		.ReadData(CacheData), 
		.HMbar(HMbar)
		);

	MainMemory main_mem(
		.clk(clk), 
		.rst(rst), 
		.address(address), 
		.read(MMRead), 
		.dataReady(MMDataReady), 
		.data(MMData), 
		.dataBlock(MMDataBlock)
		);

	Controller controller(
		.clk(clk), 
		.rst(rst), 
		.MemRead(MemRead), 
		.HMbar(HMbar), 
		.MMDataReady(MMDataReady), 
		.MMRead(MMRead), 
		.CacheWrite(CacheWrite), 
		.DataSelect(DataSelect), 
		.DataReady(DataReady)
		);

	Mux2to1_32bit data_mux(
		.inp0(CacheData),
		.inp1(MMData),
		.sel(DataSelect),
		.out(data)
		);

endmodule
