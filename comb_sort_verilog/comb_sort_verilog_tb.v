`timescale 1ns / 1ps

module comb_sort_verilog_tb;

    parameter WIDTH = 8;
    parameter DATA_WIDTH = 8;

    reg clk = 0;
    reg reset;
    reg [DATA_WIDTH*WIDTH-1:0] data_in;
    wire [DATA_WIDTH*WIDTH-1:0] data_out;
    wire [2:0] condition;

    integer i, val, file_id;
    reg [DATA_WIDTH-1:0] mem [0:WIDTH-1];

    comb_sort_verilog #(.WIDTH(WIDTH), .DATA_WIDTH(DATA_WIDTH)) uut (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .data_out(data_out),
        .condition(condition)
    );

    always #5 clk = ~clk;

    initial begin
        $display("=== Simulation start ===");

        reset = 1;
        #10 reset = 0;

        file_id = $fopen("C:/data.txt","r");
        if (file_id == 0) begin
            $display("Cannot open data.txt");
            $finish;
        end

        for(i=0; i<WIDTH; i=i+1) begin
            if (!$feof(file_id)) begin
                $fscanf(file_id,"%d\n", val);
                mem[i] = val;
            end else begin
                mem[i] = 0;
            end
        end
        $fclose(file_id);

        data_in = 0;
        for(i=0; i<WIDTH; i=i+1) begin
            data_in[DATA_WIDTH*(i+1)-1 -: DATA_WIDTH] = mem[i];
        end

        $display("Array loaded from file");

        #500;

        $display("Sorted output:");
        for(i=0; i<WIDTH; i=i+1) begin
            $display("data_out[%0d] = %0d", i, data_out[DATA_WIDTH*(i+1)-1 -: DATA_WIDTH]);
        end

        $display("=== Simulation end ===");
        $stop;
    end

endmodule