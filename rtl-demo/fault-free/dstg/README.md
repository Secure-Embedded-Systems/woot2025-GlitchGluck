## File Descriptions 

We use Python3 to generate the DSTGs.

We use Dotty to visualize the DSTGs. To install Dotty, run the following commands on Ubuntu:

```bash
sudo apt-get update
sudo apt-get install graphviz
```

Once installed, you can visualize a `.dot` file by running:

```bash
dotty example.dot
```

### Input
- `valuedata_Q.json`  
  Contains scan state data for each word-level register, documented per cycle, reflecting the values of registers at different points during the simulation.

### Script

- `gen_dstg.py`  
  A Python script used for generating the Dynamic State Transition Graph (DSTG) based on simulation data. It processes the scan state documentation to create the DSTG representation.

### Output

- `dstgfiles`  
  Contains the generated Dynamic State Transition Graphs (DSTGs).

