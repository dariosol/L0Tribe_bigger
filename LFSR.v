module LFSR (
clock,
reset,
rnd, 
ready
);

parameter WIDTH = 32;
input clock,reset;
output [WIDTH-1:0] rnd;
output ready;

reg [WIDTH-1:0] myreg;
reg r_ready;
// nice looking max period polys selected from
// the internet
wire [WIDTH-1:0] poly =
        (WIDTH == 4) ? 4'hc :
        (WIDTH == 5) ? 5'h1b :
        (WIDTH == 6) ? 6'h33 :
        (WIDTH == 7) ? 7'h65 :
        (WIDTH == 8) ? 8'hc3 :
        (WIDTH == 9) ? 9'h167 :
        (WIDTH == 10) ? 10'h309 :
        (WIDTH == 11) ? 11'h4ec :
        (WIDTH == 12) ? 12'hac9 :
        (WIDTH == 13) ? 13'h124d :
        (WIDTH == 14) ? 14'h2367 :
        (WIDTH == 15) ? 15'h42f9 :
        (WIDTH == 16) ? 16'h847d :
        (WIDTH == 17) ? 17'h101f5 :
        (WIDTH == 18) ? 18'h202c9 :
        (WIDTH == 19) ? 19'h402fa :
        (WIDTH == 20) ? 20'h805c1 :
        (WIDTH == 21) ? 21'h1003cb :
        (WIDTH == 22) ? 22'h20029f :
        (WIDTH == 23) ? 23'h4003da :
        (WIDTH == 24) ? 24'h800a23 :
        (WIDTH == 25) ? 25'h10001a5 :
        (WIDTH == 26) ? 26'h2000155 :
        (WIDTH == 27) ? 27'h4000227 :
        (WIDTH == 28) ? 28'h80007db :
        (WIDTH == 29) ? 29'h100004f3 :
        (WIDTH == 30) ? 30'h200003ab :
        (WIDTH == 31) ? 31'h40000169 :
        (WIDTH == 32) ? 32'h800007c3 : 0;


wire [WIDTH-1:0] feedback;
assign feedback = {WIDTH{myreg[WIDTH-1]}} & poly;

// the inverter on the LSB causes 000... to be a 
// sequence member rather than the frozen state
always @(posedge clock or posedge reset) begin
  if (reset) begin 
     myreg <= 0;
	  r_ready<= 1'b0; 
  end
 
  else begin
    // myreg <= ((myreg ^ feedback) << 1) | !myreg[WIDTH-1];
	  myreg <= 32'hFE0FDCBA;//Little endian
	  r_ready <= 1'b1;
  end
end

assign rnd = myreg;
assign ready= r_ready;
endmodule

