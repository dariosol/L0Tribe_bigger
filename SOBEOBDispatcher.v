module SOBEOBDispatcher(clk, BURST, reset, ECRST,BCRST);


   input clk, BURST, reset;

   output ECRST,BCRST;


   reg 	  ECRST;
   reg 	  BCRST;

   reg [1:0] state;


   parameter idle=0, sob=1, run=2, eob=3;


   always @(state)
     begin
	case (state)
	  idle:
	    begin
	       ECRST = 1'b0;
	       BCRST = 1'b0;
	    end
	  
	  sob:
	    begin
	       ECRST = 1'b1;
	       BCRST = 1'b1;
	    end
	  

	  run:
	    begin
	       ECRST = 1'b0;
	       BCRST = 1'b0;
	    end

	  eob:
	    begin
	       ECRST = 1'b1;
	       BCRST = 1'b0;
	    end

	  default:
	    begin
	       ECRST = 1'b0;
	       BCRST = 1'b0;
	    end

	endcase // case (state)
     end // always @ (state)

   always @(posedge clk or posedge reset)
     begin
	if (reset)
	  state = idle;

	else
	  case (state)
	    idle:
	      if(BURST)
	      state = sob;

	    sob:
		state = run;

	    run:
	      if(~BURST)
	      state = eob;

	    eob:
	      state = idle;

	  endcase // case (state)
     end // always @ (posedge clk or posedge reset)

endmodule // statem

