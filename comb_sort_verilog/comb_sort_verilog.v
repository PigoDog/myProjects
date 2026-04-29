module comb_sort_verilog(clk, reset, data_in, data_out, condition);
    parameter WIDTH = 8;
    parameter DATA_WIDTH = 8;

    input clk;
    input reset;
    input [WIDTH*DATA_WIDTH-1:0] data_in;
    output reg [WIDTH*DATA_WIDTH-1:0] data_out;
    output reg [2:0]condition;

	integer mem[(WIDTH-1):0];
	  
	localparam IDLE      = 3'b001;
	localparam SWAP      = 3'b010;
	localparam SORTING   = 3'b011;
	localparam UPDATE_GAP= 3'b101;
	localparam DONE      = 3'b110;
	localparam LOAD      = 3'b111;

  	integer gap;
	reg [2:0]state = IDLE;
  	integer k;
	reg [DATA_WIDTH-1:0] temp;

	always @(posedge reset or posedge clk)
 	begin
		if (reset)begin
			data_out <= 0;
			state <= IDLE;
			k = 0;
		end
		else begin
			case(state)
			IDLE:begin
				condition <= state;
		    	mem[k] = data_in;
				data_out<= mem[k];
				gap = WIDTH * 10 /13;
				state <= LOAD;
				k <= k+1;
			end 
			LOAD:begin
				condition <= state;
	    		mem[k] = data_in;
				data_out = mem[k];
				k = k+1;
				if (k == WIDTH)begin
					state <= SORTING;
					k <= 0;
				end
			end
			SORTING:begin
				condition <= state;
				if (k == WIDTH-1)begin
					state <= DONE;
					k = 0;
				end 
				else if(k + gap < WIDTH)begin
					if (mem[k] > mem[k+gap])begin
						state <= SWAP;
						condition <= state;
						temp = mem[k+gap];
						mem[k+gap] = mem[k];
						mem[k] = temp;
						k = k+1;
						state <= SORTING;
						condition <= state;
					end
					else begin
						k = k + 1;
					end
				end
				else begin 
					state <= UPDATE_GAP;
				end
			end
			UPDATE_GAP:begin
				condition <= state;
				gap = gap * 10 / 13;
				if (gap == 0)begin
					gap = 1;
				end
				k = 0;
				temp <= 0;
				state <= SORTING;
			end
			DONE:begin 
				condition <= state;
				data_out = mem[k];
				k = k+1;
			end
			endcase
		end
	end    
  
endmodule