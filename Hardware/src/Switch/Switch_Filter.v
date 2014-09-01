`timescale 1ns / 1ps
/*
 * File         : Switch_Filter.v
 * Project      : University of Utah, XUM Project MIPS32 core
 * Creator(s)   : Grant Ayers (ayers@cs.utah.edu)
 *
 * Modification History:
 *   Rev   Date         Initials  Description of Change
 *   1.0   18-Jun-2012  GEA       Initial design.
 *
 * Standards/Formatting:
 *   Verilog 2001, 4 soft tab, wide column.
 *
 * Description:
 *   A debouncer for 4 switches. 
 */
module Switch_Filter(
    input  clock,
    input  reset,
    input  [3:0] switch_in,
    output reg [3:0] switch_out
    );


    reg [5:0] c3, c2, c1, c0;

    always @(posedge clock) begin
        c0 <= (reset) ? 6'h20 : ((switch_in[0] & (c0 != 6'h3F)) ? c0 + 1'b1 : ((~switch_in[0] & (c0 != 6'h00)) ? c0 - 1'b1 : c0));
        c1 <= (reset) ? 6'h20 : ((switch_in[1] & (c1 != 6'h3F)) ? c1 + 1'b1 : ((~switch_in[1] & (c1 != 6'h00)) ? c1 - 1'b1 : c1));
        c2 <= (reset) ? 6'h20 : ((switch_in[2] & (c2 != 6'h3F)) ? c2 + 1'b1 : ((~switch_in[2] & (c2 != 6'h00)) ? c2 - 1'b1 : c2));
        c3 <= (reset) ? 6'h20 : ((switch_in[3] & (c3 != 6'h3F)) ? c3 + 1'b1 : ((~switch_in[3] & (c3 != 6'h00)) ? c3 - 1'b1 : c3));
    end

    always @(posedge clock) begin
        switch_out[0] <= (reset) ? 1'b0 : ((c0 == 6'h00) ? 1'b0 : ((c0 == 6'h3F) ? 1'b1 : switch_out[0]));
        switch_out[1] <= (reset) ? 1'b0 : ((c1 == 6'h00) ? 1'b0 : ((c1 == 6'h3F) ? 1'b1 : switch_out[1]));
        switch_out[2] <= (reset) ? 1'b0 : ((c2 == 6'h00) ? 1'b0 : ((c2 == 6'h3F) ? 1'b1 : switch_out[2]));
        switch_out[3] <= (reset) ? 1'b0 : ((c3 == 6'h00) ? 1'b0 : ((c3 == 6'h3F) ? 1'b1 : switch_out[3]));
    end

endmodule

