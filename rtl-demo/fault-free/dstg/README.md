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

- `gen_dstg.py`  
  A Python script used for generating the Dynamic State Transition Graph (DSTG) based on simulation data. It processes the scan state documentation to create the DSTG representation.

- `dstgfiles`  
  Contains files related to the Dynamic State Transition Graph (DSTG), including output data and any related resources for DSTG analysis.
