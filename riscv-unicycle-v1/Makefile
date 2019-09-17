AS = riscv64-unknown-elf-as
OBJCOPY = riscv64-unknown-elf-objcopy
MEM = fibonacci.mem

%.o: %.S 
	@echo compiling $< ...
	$(AS) -march=rv32i -o $@ $< 

%.hex: %.o
	$(OBJCOPY) -O verilog $< $@

%.mem: %.hex
	python ../resources/hex2mem.py $< $@ 

default: $(MEM)

.PHONY: clean

clean:
	rm -f *.o *.mem *.hex *.elf
