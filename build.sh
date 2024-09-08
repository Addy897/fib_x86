NAME="fib"
nasm -f elf -o "${NAME}.o" "${NAME}.s" &&  ld -m elf_i386 "${NAME}.o" -o $NAME
rm "${NAME}.o"
