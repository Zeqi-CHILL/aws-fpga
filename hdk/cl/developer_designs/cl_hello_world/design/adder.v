module adder(clock,reset,data_in1,data_in2,data_out);

input wire clock;
input wire reset;
input wire [3:0] data_in1;
input wire [3:0] data_in2;
output reg [4:0] data_out;

always @(posedge clock)
	begin
		data_out <= data_in1 + data_in2;
	end

always @(posedge clock)
	begin
	if(reset==1'b1)
		begin
			data_out <=4'b0;
		end
	end
endmodule
