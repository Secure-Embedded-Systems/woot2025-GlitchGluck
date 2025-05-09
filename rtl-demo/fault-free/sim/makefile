
all:rtl-sim

compile:
	cd ../../software;\
	$(MAKE) clean;\
	$(MAKE)


rtl-sim: compile
	vlog -work work filelist.v;\
        vlog -work work tb_filelist.v;\
	vlog -work work ../../hdl/tb/wrapper.v;\
        vlog -work work tb.v;\
        vsim -c -do dofiles/dofile.do -voptargs=+acc=lprn -L work work.tb

clean:
	rm -r work *.vcd trans* *.txt *.json
