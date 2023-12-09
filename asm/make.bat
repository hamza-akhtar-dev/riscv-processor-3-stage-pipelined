rmdir /s /q build
mkdir build

riscv64-unknown-elf-as -c -o build/assembly.o ./assembly.s -march=rv32im -mabi=ilp32
riscv64-unknown-elf-gcc -o build/main.elf build/assembly.o -T linker.ld -nostdlib -march=rv32i -mabi=ilp32
riscv64-unknown-elf-objcopy -O binary --only-section=.data* --only-section=.text* build/main.elf build/main.bin
python maketxt.py build/main.bin > build/main.txt
riscv64-unknown-elf-objdump -S -s build/main.elf > build/main.dus