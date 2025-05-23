## File Descriptions 

- `valuetree_decl.v`  
  Declares the ID number for each word-level register.

- `valuetree_Q_id.v`  
  Documents the ID number for each word-level register, providing a unique identifier for each register.

- `valuetree_Q.v`  
  At each negative edge of the clock, this file documents the value of each word-level register, capturing the state at each cycle.

- `fwritescan.v`  
  Verilog module that writes scan-chain data to output files in binary format during simulation. It facilitates accurate capture and management of internal scan-chain bit states, enabling detailed analysis and supporting physical fault injection experiments that utilize scan techniques.
