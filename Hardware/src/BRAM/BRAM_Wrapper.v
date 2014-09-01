`timescale 1ns / 1ps
/*
 * File         : BRAM_Wrapper.v
 * Project      : University of Utah, XUM Project MIPS32 core
 * Creator(s)   : Grant Ayers (ayers@cs.utah.edu)
 *
 * Modification History:
 *   Rev   Date         Initials  Description of Change
 *   1.0   6-Jun-2012   GEA       Initial design.
 *
 * Standards/Formatting:
 *   Verilog 2001, 4 soft tab, wide column.
 *
 * Description:
 *   Provides access to Block Memory through a 4-way handshaking protocol,
 *   which allows for multi-cycle and variably-timed operations on the
 *   data bus.
 */
module BRAM_Wrapper(
    input  clock,
    input  reset,
    input         rea,
    input  [3:0]  wea,
    input  [13:0] addra,
    input  [31:0] dina,
    output [31:0] douta,
    output reg       dreadya,
    input         reb,
    input  [3:0]  web,
    input  [13:0] addrb,
    input  [31:0] dinb,
    output [31:0] doutb,
    output reg       dreadyb
    );

    /* Four-Way Memory Handshake Protocol:
          1. Read/Write request goes high.
          2. Ack goes high when data is available.
          3. Read/Write request goes low.
          4. Ack signal goes low.
                  ____
          R/W: __|    |____
                     ____
          Ack: _____|    |____
          
    */


    // Writes require one clock cycle, and reads require 2 or 3 clock cycles (registered output).
    // The following logic controls the Ready signal based on these latencies.
    reg [1:0] delay_A, delay_B;
    
    always @(posedge clock) begin
        //delay_A <= (reset | ~rea) ? 2'b00 : ((delay_A == 2'b10) ? delay_A : delay_A + 1'b1);
        //delay_B <= (reset | ~reb) ? 2'b00 : ((delay_B == 2'b10) ? delay_B : delay_B + 1'b1);
        delay_A <= (reset | ~rea) ? 2'b00 : ((delay_A == 2'b01) ? delay_A : delay_A + 1'b1);
        delay_B <= (reset | ~reb) ? 2'b00 : ((delay_B == 2'b01) ? delay_B : delay_B + 1'b1);
    end
    
    always @(posedge clock) begin
        //dreadya <= (reset) ? 1'b0 : ((wea != 4'b0000) || ((delay_A == 2'b10) && rea)) ? 1'b1 : 1'b0;
        //dreadyb <= (reset) ? 1'b0 : ((web != 4'b0000) || ((delay_B == 2'b10) && reb)) ? 1'b1 : 1'b0;
        dreadya <= (reset) ? 1'b0 : ((wea != 4'b0000) || ((delay_A == 2'b01) && rea)) ? 1'b1 : 1'b0;
        dreadyb <= (reset) ? 1'b0 : ((web != 4'b0000) || ((delay_B == 2'b01) && reb)) ? 1'b1 : 1'b0;
    end

    wire wea_any = (wea != 4'b0000);
    wire web_any = (web != 4'b0000);
    
    BRAM_64KB	BRAM_64KB_inst (
        .address_a (addra),     // input [13 : 0] addra
        .address_b (addrb),     // input [13 : 0] addrb
        .byteena_a (wea),       // input [3 : 0] wea
        .byteena_b (web),       // input [3 : 0] web
        .clock     (clock),     // input clock
        .data_a    (dina),      // input [31 : 0] dina
        .data_b    (dinb),      // input [31 : 0] dinb
        .wren_a    (wea_any),   // input write any a
        .wren_b    (web_any),   // input write any b
        .q_a       (douta),     // output [31 : 0] douta
        .q_b       (doutb)      // output [31 : 0] doutb
	);

endmodule

