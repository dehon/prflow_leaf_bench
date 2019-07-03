#!/bin/sh
# This exists to fix this issue:
# https://github.com/YosysHQ/yosys/issues/710
# By tranforming it like shown here:
# https://github.com/YosysHQ/yosys/issues/335
 perl -0777 -pe 's/always @\(posedge clk\)\s*\nbegin\s*\n\s*if \(ce0\)\s*\n\s*begin\s*\n\s*if \(we0\)\s*\n\s*begin\s*\n\s*ram\[addr0\] <= d0;\s*\n\s*q0 <= d0;\s*\n\s*end\s*\n\s*else\s*\n\s*q0 <= ram\[addr0\];\s*\n\s*end\s*\n\s*end\s*\n/always @\(posedge clk\)\n     if \(ce0\)\n        if \(we0\)\n        begin\n          ram\[addr0\]<=d0; q0<=d0;\n        end\n\nalways @(posedge clk)\n    if \(ce0 & ~we0\)\n        q0<=ram\[addr0\];\n\n/g' < $1 |  perl -0777 -pe 's/always @\(posedge clk\)\s*\nbegin\s*\n\s*if \(ce1\)\s*\n\s*begin\s*\n\s*if \(we1\)\s*\n\s*begin\s*\n\s*ram\[addr1\] <= d1;\s*\n\s*q1 <= d1;\s*\n\s*end\s*\n\s*else\s*\n\s*q1 <= ram\[addr1\];\s*\n\s*end\s*\n\s*end\s*\n/always @\(posedge clk\)\n     if \(ce1\)\n        if \(we1\)\n        begin\n          ram\[addr1\]<=d1; q1<=d1;\n        end\n\nalways @(posedge clk)\n    if \(ce1 & ~we1\)\n        q1<=ram\[addr1\];\n\n/g' > $2

