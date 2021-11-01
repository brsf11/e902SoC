all:
	iverilog -o iverilog/e902SoC.vvp -Dverilog=1 -g2012 -f ./rtl/flist 
	vvp ./iverilog/e902SoC.vvp