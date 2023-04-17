// 32X32 Multiplier FSM
module mult32x32_fsm (
    input logic clk,              // Clock
    input logic reset,            // Reset
    input logic start,            // Start signal
    output logic busy,            // Multiplier busy indication
    output logic [1:0] a_sel,     // Select one byte from A
    output logic b_sel,           // Select one 2-byte word from B
    output logic [2:0] shift_sel, // Select output from shifters
    output logic upd_prod,        // Update the product register
    output logic clr_prod         // Clear the product register
);

// Put your code here
typedef enum {idle_st, null_st, A_st, B_st, C_st, D_st, E_st, F_st, G_st} sm_type;
sm_type current_state;
sm_type next_state;

always_ff @(posedge clk, posedge reset) begin
    if (reset == 1'b1) begin
        current_state <= idle_st; 
	end
	else begin
	    current_state <= next_state;
	end
end

always_comb begin
	next_state = current_state;
	a_sel = 2'b0;
	b_sel = 1'b0;
	upd_prod = 1'b0;
	clr_prod = 1'b0;
	shift_sel = 3'b000;
	busy = 1'b0;
	case (current_state)
	    idle_st: begin
		    if (start == 1'b1) begin   
			    next_state = null_st;
				a_sel = 2'b0;
				b_sel = 1'b0;
				upd_prod = 1'b0;
				clr_prod = 1'b1;
				shift_sel = 3'b000;
				busy = 1'b0;
			end
			else if(start == 1'b0) begin
			    next_state = idle_st;
				a_sel = 2'b0;
				b_sel = 1'b0;
				upd_prod = 1'b0;
				clr_prod = 1'b0;
				shift_sel = 3'b000;
				busy = 1'b0;
			end
		end
		null_st: begin
			    next_state = A_st;
				a_sel = 2'b00;
				b_sel = 1'b0;
				upd_prod = 1'b1;
				clr_prod = 1'b0;
				shift_sel = 3'b000;
				busy = 1'b1;
		end
		A_st: begin
		        next_state = B_st;
				a_sel = 2'b01;
				b_sel = 1'b0;
				upd_prod = 1'b1;
				clr_prod = 1'b0;
				shift_sel = 3'b001;
				busy = 1'b1;
		end
		B_st: begin
		        next_state = C_st;
				a_sel = 2'b10;
				b_sel = 1'b0;
				upd_prod = 1'b1;
				clr_prod = 1'b0;
				shift_sel = 3'b010;
				busy = 1'b1;
		end
		C_st: begin
		        next_state = D_st;
				a_sel = 2'b11;
				b_sel = 1'b0;
				upd_prod = 1'b1;
				clr_prod = 1'b0;
				shift_sel = 3'b011;
				busy = 1'b1;
		end
		D_st: begin
		        next_state = E_st;
				a_sel = 2'b00;
				b_sel = 1'b1;
				upd_prod = 1'b1;
				clr_prod = 1'b0;
				shift_sel = 3'b010;
				busy = 1'b1;
		end
		E_st: begin
		        next_state = F_st;
				a_sel = 2'b01;
				b_sel = 1'b1;
				upd_prod = 1'b1;
				clr_prod = 1'b0;
				shift_sel = 3'b011;
				busy = 1'b1;
		end
		F_st: begin
		        next_state = G_st;
				a_sel = 2'b10;
				b_sel = 1'b1;
				upd_prod = 1'b1;
				clr_prod = 1'b0;
				shift_sel = 3'b100;
				busy = 1'b1;
		end
		G_st: begin
		        next_state = idle_st;
				a_sel = 2'b11;
				b_sel = 1'b1;
				upd_prod = 1'b1;
				clr_prod = 1'b0;
				shift_sel = 3'b101;
				busy = 1'b1;
		end
	endcase
end			

// End of your code

endmodule
