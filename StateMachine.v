module StateMachine(clk, rst, MemRead, HMbar, MMDataReady, MMRead, CacheWrite, DataSelect, DataReadySel);
input clk;
input rst;
input MemRead;
input HMbar;
input MMDataReady;
output reg MMRead;
output reg CacheWrite;
output reg DataSelect;
output reg DataReadySel;

	reg [1:0]ps, ns;
	parameter [1:0]CACHE_READ = 2'b00, WAIT_FOR_MAIN_MEMORY = 2'b01, WRITE_TO_CACHE_AND_SEND_DATA = 2'b10;

	always@(ps or MemRead or HMbar or MMDataReady) begin
		ns = CACHE_READ;
		case(ps)
			CACHE_READ : ns = (MemRead & ~HMbar) ? WAIT_FOR_MAIN_MEMORY : CACHE_READ;
			WAIT_FOR_MAIN_MEMORY : ns = MMDataReady ? WRITE_TO_CACHE_AND_SEND_DATA : WAIT_FOR_MAIN_MEMORY;
			WRITE_TO_CACHE_AND_SEND_DATA : ns = CACHE_READ;
			default : ns = CACHE_READ;
		endcase
	end

	always@(ps) begin
		{MMRead, CacheWrite, DataSelect, DataReadySel} = 4'b0000;
		case(ps)
			//no change for CACHE_READ
			WAIT_FOR_MAIN_MEMORY : {MMRead, DataSelect} = 2'b11;
			WRITE_TO_CACHE_AND_SEND_DATA : {CacheWrite, DataSelect, DataReadySel} = 3'b111;
			default : {MMRead, CacheWrite, DataSelect, DataReadySel} = 4'b0000;
		endcase
	end

	always@(posedge clk or posedge rst) begin
		if (rst) ps <= CACHE_READ;
		else ps <= ns;
	end

endmodule
