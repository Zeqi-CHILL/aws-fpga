module powerwaster #(
    parameter N_PWELEMS = 1
    )(
    input  logic enable,
    output logic pw_out
    );


//====================================================================
// Signal declarations
//====================================================================
logic [N_PWELEMS-1:0] pw_outputs;

//====================================================================
// Combinational/sequential logic
//====================================================================
//--------------------------------------------------------------------
// Instantiate the RO based power waster elements
//--------------------------------------------------------------------
assign pw_out = ^pw_outputs;
genvar i;
generate
    for(i = 0; i < N_PWELEMS; i++) begin: ropw
        ropw_elem u_ropw (
            .enable(enable),
            .ro_out(pw_outputs[i])
            );
    end
endgenerate

endmodule


//====================================================================
// Implementation of an 1-stage RO based power waster element
//====================================================================
`timescale 1ns / 1ps
module ropw_elem (
    input  logic enable,
    output logic ro_out
    );

`ifdef SIM
logic and2_o;
always_comb and2_o <= #($urandom_range(3, 1)) enable & ro_out;
always_comb ro_out <= #($urandom_range(3, 1)) ~and2_o;
`else
not u_not(ro_out, (enable & ro_out));
`endif

endmodule
