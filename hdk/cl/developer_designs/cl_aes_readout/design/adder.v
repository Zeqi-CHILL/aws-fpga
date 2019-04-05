module adder(clock,reset,add_in1,add_in2,add_out,d_vld);

input wire clock;
input wire reset;
input wire [3:0] add_in1;
input wire [3:0] add_in2;
output reg [4:0] add_out;
output reg d_vld= 1'b0;
integer i=0;

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

always @(*)
begin
		for (i=0;i<30;i++)
		begin
			if (i==30) begin
			d_vld = 1'b1;
			end
		end
end
endmodule
