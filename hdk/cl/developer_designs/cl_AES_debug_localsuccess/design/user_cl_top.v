
/*
*  Author: Jakub Szefer <jakub.szefer@yale.edu>
*  Date: 2018-11-03
*
*  No license is specified for this code, do not redistribute.
*
*/

module user_cl_top (
    input wire clock,  //clock
    input wire reset_n, //reset_n

    // data inputs from input FIFO 
    input wire                  data_empty, //empty
    output reg                  data_rd, //rd
    input [DATA_WIDTH-1:0]      data_din,//din

    // data outputs to output FIFO
    input wire                  data_full, //full
    output reg                  data_wr,//wr
    output reg [DATA_WIDTH-1:0] data_dout //dout

    /********** For this test, there is no control FIFO. Control FIFO can be added later. ***********/

    // control inputs (assuming FIFO interface for now
    // but there should never be more than one input at a time,
    // this is mostly for clock-domain crossing).
    /*input wire                  ctrl_empty,
    output reg                  ctrl_rd,
    input [DATA_WIDTH-1:0]      ctrl_din,

    // control outputs (assuing FIFO interface for now
    // but there should never be more than one output at a time,
    // this is mostly for clock-domain crossing).
    input wire                  ctrl_full,
    output reg                  ctrl_wr,
    output reg [DATA_WIDTH-1:0] ctrl_dout */ 
);

// Parameters

parameter DATA_WIDTH = 32;

// Add logic here...



reg waiting_for_fifo = 0;

localparam WAIT = 0,
           IDLE = 1,
           WAITING_FOR_FIFO = 2;
reg [7:0] state = IDLE;
//reg [7:0] return_state = IDLE;

always @(posedge clock) begin
    data_rd <= 0;
    data_wr <= 0;    
    if (!reset_n) begin
        data_rd <= 0;
        data_wr <= 0;
        data_dout <= 0;
        waiting_for_fifo <= 0;
    end
    else begin
        case (state)

        WAIT: begin
            state <= WAITING_FOR_FIFO;
        end

        IDLE: begin

            if(!data_empty && !data_full && !waiting_for_fifo) begin
                data_rd <= 1;
                data_dout <= 0;
                waiting_for_fifo <= 1;
                state <= WAIT;
                //return_state = WAITING_FOR_FIFO;
            end
            else begin
                state <= IDLE;
                //return_state = IDLE;
            end
        end

        WAITING_FOR_FIFO : begin
            data_dout <= data_din + 2;
            data_wr <= 1;
            waiting_for_fifo <= 0;
            state <= IDLE;
            //return_state = IDLE;
        end
        endcase
    end
end



endmodule

