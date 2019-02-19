`timescale 1 ns / 1 ps
module test;

logic enable;
logic pw_out;

powerwaster powerwaster_test(
.enable(enable),
.pw_out(pw_out)
);

initial begin
enable <= 0; #10;
enable <= 1; #10;
end

endmodule
