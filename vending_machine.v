//------------------------
//COMPUTER STRUCTURE	  |
//LAB 3: VENDING MACHINE  |      |
//------------------------

//CONTROLLER MODULE 
module controller(
//1000, 2000, 5000, water, soda, coin_return
in1, in2, in5, cr, w_sel, s_sel, clock, reset, 
//change, change_output, coin_return_output, water dispense, soda dispense
change, c_out, cr_out, w_out, s_out);


//define I/O
input in1, in2, in5, w_sel, s_sel, clock, reset, cr;
output c_out, change, cr_out, w_out, s_out;

//define connection type 	 
wire in1, in2, in5, clock, reset, cr;
wire s_sel, w_sel;
reg [3:0] count = 4'b0000; 
reg [3:0] c_out, cr_out;
reg w_out, s_out, change;

initial
begin
change = 0;
count = 4'b0000;
c_out = 4'b0000;
s_out = 0;
w_out = 0;
cr_out = 4'b0000;
end

//Main 
always @ (posedge clock && reset != 1)
begin
	//this if statement makes w_out and s_out signal exist in 1 clock cycle
	if (w_out||s_out)
	begin		
		w_out = 0;
		s_out = 0;
	end
	//coin inserted
	if ((in1 || in2 || in5) != 0)
	begin
		//INSERTED COINS 
		if (in1 == 1'b1)
			begin
				//Return refused coin to CR OUTPUT
				if ((count+1) > 4'b1001)
					c_out = 1;
				else 
					count = count + 4'b0001;
			end	
		if (in2 == 1'b1)
			begin 
				if ((count+1) > 4'b1001)
					c_out = 2;
			 	else 
					count = count + 4'b0010;
			end
		if (in5 == 1'b1)
			begin 
				if ((count+1) > 4'b1001)
					c_out = 5;
				else 
					count = count + 4'b0101;
			end
	end
	else // change enable when no coin inserted anymore and change output signal
	begin
		if (c_out!=0)
		change =1 ;
	end 
	//CR pressed
	if (cr == 1)
	begin
		cr_out = count;
		count = 0;
	end
	//drink selected
	if (w_sel || s_sel)
	begin
		if (count >= 7)
		begin
			//WATER SELECTED
			if (w_sel == 1)
			begin 
				c_out = count - 7;
				w_out = 1'b1;
			end
			//SODA SELECTED
			if (s_sel == 1)
			begin
				c_out = count - 9;
				s_out = 1'b1;
			end
			//if changed, reset counter.
			if (change) count = 0; 
		end
	end
end

//RESET ALL OUTPUT TO ZERO
always @(posedge reset) 
begin
	change = 0;
	count = 4'b0000;
	c_out = 4'b0000;
	s_out = 0;
	w_out = 0;
	cr_out = 4'b0000;
end
endmodule

//CHANGER MODULE 
module changer(CO, c1, c2, c5, clk, reset, enable);
input CO, reset, clk, enable; //CO: change output from controller
output c1, c2, c5; //number of coin is changed 

wire [3:0] CO;
reg [1:0] c1 = 0, c2 = 0, c5 = 0;
always @(posedge reset)
begin
	c1 = 0; c2 = 0; c5 = 0;
end 
always @(posedge enable)
begin
	if (reset != 1)
	begin
		c5 = CO/5;
		c2 = (CO - (c5*5))/2;
		c1 = CO - c5*5 - c2*2;
	end
end
endmodule

//TOP MODULE 
module vending_machine(
N, D, Q, CR, w_Sel, s_Sel, Reset, clk, 
C1, C2, C5, WO, SO, CR_OUT);

input N, D, Q, CR, w_Sel, s_Sel, Reset, clk;
output C1, C2, C5, WO, SO, CR_OUT;

wire [3:0] ctrl_chgr;
wire [3:0] CR_OUT;
wire [1:0] C1, C2, C5;
wire chage_to_anable;

//connect modules
controller	controller(.in1(N), .in2(D), .in5(Q), .cr(CR), 
			   .w_sel(w_Sel), .s_sel(s_Sel), 
			   .clock(clk), .reset(Reset), 
			   .change(change_to_enable),.c_out(ctrl_chgr), 
			   .cr_out(CR_OUT), .w_out(WO), .s_out(SO));

changer		changer(ctrl_chgr, C1, C2, C5, clk, Reset, change_to_enable);

endmodule 
