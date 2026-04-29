module FifoRTL(
    clk,
    reset,
    in_data,
    in_valid,
    out_ready,
    out_data,
    out_valid,
    in_ready
);

    parameter DEPTH = 4;

    input clk;
    input reset;

    input [31:0] in_data;
    input in_valid;
    input out_ready;

    output [31:0] out_data;
    output out_valid;
    output in_ready;

    reg [31:0] out_data;
    reg out_valid;
    reg in_ready;

    reg [31:0] buffer [0:DEPTH-1];

    reg [3:0] wr_index;
    reg [3:0] rd_index;

    reg [DEPTH-1:0] new_wr_index;
    reg [DEPTH-1:0] new_rd_index;

    reg new_out_valid;
    reg new_in_ready;

    always @(in_ready or out_valid or out_ready or in_valid or in_data or rd_index) begin
        if (in_ready && in_valid) begin
            new_wr_index = (wr_index + 1) % 4;

            new_in_ready = 1'b1;
            new_out_valid = 1'b1;

            buffer[wr_index] = in_data;

            if (((wr_index + 1) % 4) == rd_index) begin
                new_in_ready = 1'b0;
            end
        end

        else if (out_valid && out_ready) begin
            out_data = buffer[rd_index];
			new_in_ready = 1'b1;


            if (((rd_index + 1) % 4) == wr_index) begin
                new_out_valid = 1'b0;
            end
            new_rd_index = (rd_index + 1) % 4;
        end

        else begin
			out_data = 0;
			new_wr_index = wr_index;
			new_rd_index = rd_index;
			new_in_ready = in_ready;
			new_out_valid = out_valid;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            wr_index = 0;
            rd_index = 0;

            in_ready = 1'b1;
            out_valid = 1'b0;
        end
        else begin
            wr_index = new_wr_index;
            rd_index = new_rd_index;

            in_ready = new_in_ready;
            out_valid = new_out_valid;
        end
    end

endmodule