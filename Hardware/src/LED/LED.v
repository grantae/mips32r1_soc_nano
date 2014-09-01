`timescale 1ns / 1ps
/*
 * File         : LED.v
 * Project      : University of Utah, XUM Project MIPS32 core
 * Creator(s)   : Grant Ayers (ayers@cs.utah.edu)
 *
 * Modification History:
 *   Rev   Date         Initials  Description of Change
 *   1.0   13-Jul-2012  GEA       Initial design.
 *
 * Standards/Formatting:
 *   Verilog 2001, 4 soft tab, wide column.
 *
 * Description:
 *   A read/write interface between a 4-way handshaking data bus and
 *   8 LEDs.
 *
 *   An optional mode allows the LEDs to show current interrupts
 *   instead of bus data.
 */
module LED(
    input  clock,
    input  reset,
    input  [8:0] dataIn,
    input  [7:0] IP,
    input  Write,
    input  Read,
    output [8:0] dataOut,
    output reg Ack,
    output [7:0] LED
    );

    reg  [7:0] data;
    reg  useInterrupts;
    
    always @(posedge clock) begin
        data <= (reset) ? 8'b0 : ((Write) ? dataIn[7:0] : data);
        useInterrupts <= (reset) ? 1'b0 : ((Write) ? dataIn[8] : useInterrupts);
    end
    
    always @(posedge clock) begin
        Ack <= (reset) ? 1'b0 : (Write | Read);
    end
    
    assign LED = (useInterrupts) ? IP[7:0] : data[7:0];
    assign dataOut = {useInterrupts, data[7:0]};

endmodule

