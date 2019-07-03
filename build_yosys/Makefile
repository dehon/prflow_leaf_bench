# set these to point to your yosys binary and technology data

#symb_dir?=/scratch/safe/SymbiFlow/symbiflow-arch-defs
#YOSYS=$(symb_dir)/build/env/conda/bin/yosys
symb_dir?=/users/andre/symbiflow/symbiflow-arch-defs
YOSYS = /usr/local/bin/yosys

# set this to use or not use patch

YOSYS_MEMORY_PATCH = ../yosys_support/yosys_memory_patch.sh
#YOSYS_MEMORY_PATCH = ../yosys_support/noop.sh


## -- probably don't need to set things below here

MERGE_PORTS = ../yosys_support/merge_ports.perl

src=../verilog_source
XPM_MEMORY_TDPRAM=../yosys_support/xpm_memory_tdpram_yosys.v
SUMMARY = ../common/summary.perl
base=$(abspath .)


targets=$(notdir $(wildcard $(src)/*))
targets:=$(filter-out flow_calc_1 flow_calc_2,$(targets))

# flowc_calc_1 and flow_calc_2 require an IP block from Xilinx that we do not have

tmp_pref:=$(shell mktemp -u)

export symb_dir

all: $(addsuffix /out.eblif,$(targets)) 

.PRECIOUS: %.eblif  $(targets:=/out.eblif) 
.SECONDARY: %.eblif $(targets:=/out.eblif) 

$(targets): %: %/out.eblif

$(abspath $(targets)):
	@ mkdir $@


$(targets:=.clean): %.clean:
	- @ rm -rf $*

clean: $(targets:=.clean)

echo_ap_%:
	echo $(abspath $*)

echo_%:
	@ echo $($*)

-include $(targets:=/.deps)

.SECONDEXPANSION:

$(foreach d,$(wildcard $(src)/*/*.dat),$(notdir $(patsubst %/,%,$(dir $d)))/$(notdir $d)): %.dat: $(src)/%.dat | $$(abspath $$(dir %))
	@ cp $< $@

$(foreach d,$(wildcard $(src)/*/*.v),$(notdir $(patsubst %/,%,$(dir $d)))/$(notdir $d)): %.v: $(src)/%.v | $$(abspath $$(dir %))
	@ $(YOSYS_MEMORY_PATCH) $< $@

$(targets:=/out.eblif): %/out.eblif: $$(addprefix %/,$$(notdir $$(wildcard $(src)/%/*.dat))) $$(addprefix %/,$$(notdir $$(wildcard $(src)/%/*.v))) | $$(abspath %)
	@ echo $*
# temporary
#	cp $(XPM_MEMORY_TDPRAM) $*/
	- cd $* && OUT_EBLIF=out.pre_eblif \
	OUT_SYNTH_V=synth.vout \
	$(YOSYS) -E .deps -p "tcl ../synth.tcl" -l $(*).log *.v 
	grep "Number of cells:" $*/*.log | tail -1 > $*/num_cells
	grep "\$lut " $*/*.log | tail -1 > $*/num_luts
	grep "RAMB18E1" $*/*.log | tail -1 > $*/num_ramb18
	grep "RAMB18_TDP_RW" $*/*.log | tail -1 > $*/num_ramb18merged_ports
	grep "RAMB36E1" $*/*.log | tail -1 > $*/num_ramb36dedicated_ports
	grep "RAMB36_TDP_RW" $*/*.log | tail -1 > $*/num_ramb36merge_ports
	grep "M18x25" $*/*.log | tail -1 > $*/num_m18x25
	tail -5 $*/*.log | grep "CPU" > $*/yosys_runtime
	$(MERGE_PORTS) $*/out.pre_eblif $*/out.eblif
	$(SUMMARY) $*

