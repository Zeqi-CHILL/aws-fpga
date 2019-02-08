`timescale 1ns/1ns

module adder_tb();

reg clock;
reg reset;
reg [3:0] data_in1;
reg [3:0] data_in2;
wire [4:0] data_out;

parameter data1=16'b0000111100110101;
parameter data2=16'b1010110011110000;
parameter CYCLE=20;

adder adder_test(
.clock(clock),
.reset(reset),
.data_in1(data_in1),
.data_in2(data_in2),
.data_out(data_out)
);

always #(CYCLE/2)
begin
	clock = ~clock;
end

initial 
begin
	$dumpfile("adder_test.vcd");
	$dumpvars(0,adder_test);
	clock= 1'b0;
	reset= 1'b1;
	
	#CYCLE
	reset= 1'b0;
	data_in1 <= data1[15:12];
	data_in2 <= data2[15:12];

	#CYCLE
	data_in1 <= data1[11:8];
	data_in2 <= data2[11:8];

	#CYCLE
	data_in1 <= data1[7:4];
	data_in2 <= data2[7:4];

	#CYCLE
	data_in1 <= data1[3:0];
	data_in2 <= data2[3:0];

	#CYCLE;
	reset=1'b1;
	#CYCLE;
	$finish;
end

endmodule

