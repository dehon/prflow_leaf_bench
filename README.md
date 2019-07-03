# prflow_leaf_bench
Benchmarkset  of PRflow Leaf logic for Rosetta Benchmarks

To build you will need to edit build_yosys Makefile:
* set the location of your yosys (YOSYS) and your yosys support data (symb_dir)
* set YOSYS_MEMORY_PATCH to the noop.sh to test if the memory patch is not needed
  (otherwise leave with using yosys_memory_patch.sh)
  

Once those are set, cd to build_yosys
* to build everything, just run: make
* to build a specific case, run: make benchmark/out.eblif



