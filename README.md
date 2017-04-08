# Random-Number-Generator-Circuit
Abstract- This paper explains the algorithms that are used to implement the 8-bit random number generator. 
The equation we used to calculate the random numbers is seed = ((seed*13) +1) % 256. The sub-expression ((seed*13) +1) 
is equivalent to (seed << 3) + (seed << 2) + seed + 1. This can be done using three adders and two shift units. 
Since, 256 is a power of 2, our output will be the lower 8 bits of the sum. The adder I chose to use is the ripple-carry adder.
To shift the numbers, I used the rotation technique that was described in class. For instance, if seed is a 16-bit vector 
that has to be shifted right by 3 bits, this is done by concatenating the first 13 bits with the 
last 3 bits, i.e. {seed [12:0], seed [15:13]}.
The adder module uses a for loop to iterate through each bit in the operands. The loop is controlled by the parameter n 
so that it can be easily extended into larger adders. For every bit, it calculates the sum using the equation: 
S[k] = X[k] ^ Y[k] ^ C[k]
The carryout is computed using the equation: 
C[k+1] = (X[k] & Y[k]) |  (X[k] & C[k]) |  (Y[k] & C[k])

The test-bench module defines the 16-bit vector seed and feeds it as input to the rand8 module. It stores the output of 
rand8 in seed every one tick. The simulation stops after 256 ticks.

