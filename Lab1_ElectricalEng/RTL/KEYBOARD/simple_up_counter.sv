// (c) Technion IIT, Department of Electrical Engineering  2021

// Implements a simple up-counter for demonstration purposes only


module simple_up_counter 
	(
   // Input, Output Ports
	input logic clk,
   input logic nextNumber, 
   input logic resetN,
   output logic [3:0] digit // counter output name to match pins
   );
	
	 
   always_ff @( posedge clk or negedge resetN )
   begin
      
      if ( !resetN ) begin // Asynchronic reset
			digit	<= 4'h1;
		end
      else 	if (nextNumber) begin			// Synchronic logic	
			digit	<= digit + 1'b1;
		end
    
	 end // always
	 
endmodule

