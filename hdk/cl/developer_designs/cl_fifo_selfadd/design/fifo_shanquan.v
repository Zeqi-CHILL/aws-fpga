 /*
 #
 # This file is for controling TestEquity Model 115A Temperature Chamber.
 #
 # Copyright (C) Shanquan Tian, CASLAB @ Yale
 # Authors: Shanquan Tian <shanquan.tian@yale.edu>
 #
 # This program is free software; you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation; either version 3 of the License, or
 # (at your option) any later version.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
 # along with this program; if not, write to the Free Software Foundation,
 # Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 #

// FIFO

*/



module FIFO_Shanquan # (parameter abits = 4, dbits = 64)(
    input clock,
    input reset,
    input wr,
    input rd,
    input [dbits-1:0] din,
    output empty,
    output full,
    output [dbits-1:0] dout,
    output [7:0] size // debug
);

reg [dbits-1:0] out;
reg [dbits-1:0] regarray[2**abits-1:0]; //number of words in fifo = 2^(number of address bits)
reg [abits-1:0] wr_reg, wr_next, wr_succ; //points to the register that needs to be written to
reg [abits-1:0] rd_reg, rd_next, rd_succ; //points to the register that needs to be read from
reg full_reg, empty_reg, empty_next;
reg full_next;
assign full = full_reg;
assign empty = empty_reg;
assign dout = out;

wire wr_en;
assign wr_en = wr & ~full; //only write if write signal is high and fifo is not full
 
//always block for write operation
always @ (posedge clock)
 begin
  if(wr_en)
   regarray[wr_reg] <= din;  //at wr_reg location of regarray store what is given at din
 end


//always block for read operation
always @ (posedge clock)
 begin
  if(rd)
   out <= regarray[rd_reg];
 end


reg [7:0] size_reg = 0;
assign size = size_reg;

always @( posedge clock) begin
  //if(clock == 0) begin
    size_reg <= (wr_next - rd_next) % (2**abits);
  //end
end
 
always @ (posedge clock or posedge reset)
 begin
  if (reset)
    begin
    wr_reg <= 0;
    rd_reg <= 0;
    full_reg <= 1'b0;
    empty_reg <= 1'b1;
    end
  else
    begin
    wr_reg <= wr_next; //created the next registers to avoid the error of mixing blocking and non blocking assignment to the same signal
    rd_reg <= rd_next;
    full_reg <= full_next;
    empty_reg <= empty_next;
    /*if((wr_reg - rd_reg) % (2**abits + 1) == 2**abits) begin
      full_reg <= 1'b1;   //its full now
    end*/
   end
 end

always @(*)
 begin
  wr_succ = (wr_reg + 1)%(2**abits); //assigned to new value as wr_next cannot be tested for in same always block
  rd_succ = (rd_reg + 1)%(2**abits); //assigned to new value as rd_next cannot be tested for in same always block
  wr_next = wr_reg;  //defaults state stays the same
  rd_next = rd_reg;  //defaults state stays the same
  full_next = full_reg;  //defaults state stays the same
  empty_next = empty_reg;  //defaults state stays the same
   
   case({wr,rd})
    //2'b00: //do nothing LOL..
     
    2'b01: begin  //read
      if(~empty) begin //if fifo is not empty continue
        rd_next = rd_succ;
        full_next = 1'b0;
        if(rd_succ == wr_reg) begin//all data has been read
          empty_next = 1'b1;  //its empty again
        end
      end
    end
     
    2'b10: //write
     begin
      if(~full) //if fifo is not full continue
       begin
        wr_next = wr_succ;
        empty_next = 1'b0;
        if(wr_succ == rd_reg) begin //all registers have been written to
          full_next = 1'b1;   //its full now
        end 
       end
     end
      
    2'b11: //read and write
     begin
      wr_next = wr_succ;
      rd_next = rd_succ;
     end
     //no empty or full flag will be checked for or asserted in this state since data is being written to and read from together it can  not get full in this state.
    endcase
    
 
 end
 

endmodule
