module fifo_test(
        input clock,
        input reset_n,
        input empty,
        input full,
        input [31:0] din,
        output reg rd,
        output reg wr,
        output reg [31:0] dout        
);

reg waiting_for_fifo = 0;

localparam WAIT = 0,
           IDLE = 1,
           WAITING_FOR_FIFO = 2;

reg [7:0] state = IDLE;
//reg [7:0] return_state = IDLE;

always @(posedge clock) begin
    rd <= 0;
    wr <= 0;    


    if (!reset_n) begin
        rd <= 0;
        wr <= 0;
        dout <= 0;
        waiting_for_fifo <= 0;
    end
    else begin
        case (state)

        WAIT: begin
            state <= WAITING_FOR_FIFO;
        end

        IDLE: begin

            if(!empty && !full && !waiting_for_fifo) begin
                rd <= 1;
                dout <= 0;
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
            dout <= din + 2;
            wr <= 1;
            waiting_for_fifo <= 0;
            state <= IDLE;
            //return_state = IDLE;
        end


        endcase

    end

end

endmodule
