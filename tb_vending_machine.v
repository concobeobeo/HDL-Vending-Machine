module tb_vending_machine();

reg one, two, five, cr, w_sel, s_sel, reset, clock;
wire [3:0] crt;
wire [1:0] c1, c2, c5;
wire wo, so;


initial 
begin
fork
clock = 0;
cr = 0;
reset = 0;
w_sel = 0; s_sel = 0;
one = 0; two =0; five =0;
join
//	REGULAR CASES
//--------------
//	8K | WATER
#2 
w_sel = 1; 
s_sel = 0; 
one = 1; two = 1; five = 1;
#2
one = 0; two =0; five =0; 
#4 //RESET I/O 
w_sel = 0; 
s_sel = 0;
one = 0; two = 0; five = 0; 
cr = 0;
reset = 1; 
#2 
reset = 0;
#2 //DELAY 
//--------------
//	13K | SODA
one = 1; two = 1; five = 1;
#2 
one = 0; two = 0; five = 1; 
w_sel = 0; 
s_sel = 1;
#2 //RESET
five = 0;
#4 
w_sel =0; 
s_sel = 0;
cr = 0; 
one = 0; two = 0; five = 0; 
reset =1;
#2 
reset = 0;
#2//DELAY 
//--------------
//	COIN RETURN
#2 
cr = 1;
one = 1; two = 1; five = 1; 
#2 
cr = 0;
one = 0; two = 0; five = 0;
end

always
#1 clock =~clock;

vending_machine vend(.N(one), .D(two), .Q(five), 
		     .CR(cr), .w_Sel(w_sel), .s_Sel(s_sel), .Reset(reset), 
		     .clk(clock), .C1(c1), .C2(c2), .C5(c5), 
		     .WO(wo), .SO(so), .CR_OUT(crt));


endmodule 