module testbench;

// I defined two separate seed variables, one for rand8 and one for 
// refrand8, to help me track errors more easily.

reg  [15:0]  seed2;
reg  [15:0]  seed1;

// r is the output of rand8

wire [15:0] r;

// s is the output of refrand8

wire [15:0] s;

// those variables count the correct and the incorrect outputs

integer correct = 0;
integer failed = 0;

// initialize seed to 1

initial begin
 seed1 = 8'b00000001;
 seed2 = 8'b00000001;
end

// instantiate the rand8 and refrand8 modules

rand8 a(r,seed1);
refrand8 b(s, seed2);

// update seed every one tick

always #1 seed1 = r;
always #1 seed2 = s;

// at each update, check if the outputs of both modules match,
// if not, display the input for which the output was incorrect.

always @(seed1)
begin
  if(seed1 == seed2)
  begin
    correct = correct + 1;
  end
  else
  begin
     failed = failed + 1;
    $display("incorrect output for %d", seed1);
   end
end

// run the simulation for 255 ticks.
// display how many outputs were correct/incorrect

initial
  begin
     #1 seed1 = r;
     #1 seed2 = s;
     #254 $display("All cases tested; %d correct, %d failed", correct, failed); $finish; 
  end

endmodule

// this module is based on the demorand8 module that’s provided in the assignment page.

module refrand8(r, seed);
input [15:0] seed;
output [15:0] r;

assign  r = ((13 * seed) + 1) % 256;

endmodule


module rand8(r, seed);

input [15:0] seed;
output [15:0] r;
wire [2:0] carryout;
wire [15:0] S;
wire [15:0] R;
wire [15:0] D;

// build three instances of the adder

// the inputs of the first instance are
// seed shifted by 3 bits and seed shifted 
// by 2 bits.

adder8 a0(0,{seed[12:0],seed[15:13]}, {seed[13:0],seed[15:14]},S, carryout[0]);

// the inputs of the second instance of the adder
// are the sum produced from the first instance (i.e seed << 3 + seed << 2)
// and seed

adder8  a1(carryout[0],S,seed,R,carryout[1]);

// this adder increments the result by one

adder8  a2(carryout[1],R,8'b00000001,D,carryout[2]);

// the output of this module is only the lower 8 bits

assign r = D[7:0];

endmodule


module adder8 (carryin,X,Y,S,carryout);

// this is a ripple-carry adder

   parameter n = 16;
   input carryin;
   input [n-1:0] X,Y;
   output [n-1:0] S;
   output carryout;
   reg [n-1:0] S;
   reg carryout;
   reg [n:0] C;
   integer k;

   // it uses a for loop to process each bit.
   // the loop is controlled by the parameter n so that it can be easily extended.

   always @(X or Y or carryin)
      begin
         C[0] = carryin;
         for(k = 0; k < n; k = k+1)
         begin
            S[k] = X[k] ^ Y[k] ^ C[k];
            C[k+1] = (X[k] & Y[k]) |  (X[k] & C[k]) |  (Y[k] & C[k]);
         end
         carryout = C[n];
      end

endmodule