module TB();

	reg clk = 1, rst = 0;
	reg [14:0] address;
	reg MemRead;

	wire [31:0] data;
	wire DataReady, HMbar;

	reg [31:0] read_datas [0:8191];

	integer CycleNum = 0;
	always #23 clk = ~clk;
	always #46 CycleNum = CycleNum + 1;

	MemoryHierarchy memory_hierarchy(
		.clk(clk), 
		.rst(rst), 
		.address(address), 
		.MemRead(MemRead), 
		.data(data), 
		.DataReady(DataReady), 
		.HMbar(HMbar)
		);

	integer i;
	integer array_size = 8*1024;
	integer starting_address = 1024;
	integer total_hits = 0;
	integer total_miss = 0;
		
	initial begin
		#15
		rst = 1;
		#60
		rst = 0;
		#70
		MemRead = 1'b0;
		#60
		for (i = 0; i < array_size; i = i + 1) begin
			address = starting_address + i;
			#60
			MemRead = 1'b1;
			#20
			while (DataReady != 1'b1) begin #19; end
			read_datas[i] = data;
			if (HMbar) 
				total_hits = total_hits + 1;
			else
				total_miss = total_miss + 1;	
			#30
			MemRead = 1'b0;	
		end
		
		$display("Total Hits: %d", total_hits);
		$display("Total Misses: %d", total_miss);
		$display("Hit Rate: %d", 100*total_hits/(total_hits+total_miss),"%%");
		
		$stop;
	end


endmodule
