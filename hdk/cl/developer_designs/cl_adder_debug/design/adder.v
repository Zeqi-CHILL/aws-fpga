module adder(clock,reset,add_in1,add_in2,add_out);

input wire clock;
input wire reset;
input wire [3:0] add_in1;
input wire [3:0] add_in2;
output reg [4:0] add_out;

always @(posedge clock)
	begin
		add_out <= add_in1 + add_in2;
	end
/*
always @(posedge clock)
	begin
	if(!reset)
		begin
			add_out <=5'b00111;
		end
	end
*/
endmodule
