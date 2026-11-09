# Iterative DES ASIC RTL

A Verilog implementation of a 64-bit DES core with a shared, iterative
16-round Feistel datapath for encryption and decryption. The core accepts
the key and data over a 32-bit input port in two transfers.

This project refactors an existing DES reference design. The refactor separates the controller, key schedule,
datapath, and simulation sources, and implements the S-boxes and fixed
permutations using constant tables.

## ASIC implementation

The design targets TSMC 180 nm. The Synopsys flow uses Design Compiler
(DC) for synthesis, IC Compiler (ICC) for place and route, PrimeTime (PT)
for static timing analysis, and VCS for simulation. Post-layout simulation
passed in VCS.


## Sources and simulation

- Add all Verilog files under rtl/ as design sources. The synthesis top
  is DES_top.
- Add sim/DES_top_tb.v as a simulation source. The simulation top is
  DES_top_tb.
- Use the supplied testbench to exercise key setup, encryption, and
  decryption.
