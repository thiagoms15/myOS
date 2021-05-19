# GRUB will only load our kernel if it complies with the Multiboot spec.

# Multiboot header must contain 3 fields
# magic    : containing the magic number 0x1BADB002, to identify the header.
# flags    : specify features of OS to bootloader
# checksum : the checksum field when added to the fields ‘magic’ and ‘flags’ must give zero.
.set MAGIC, 0x1badb002
.set FLAGS, (1<<0 | 1<<1) # aligned on page (4KB) and information on memory
.set CHECKSUM, - (MAGIC + FLAGS)

.section /multiboot
    .long MAGIC
    .long FLAGS
    .long CHECKSUM


.section .text
.extern KernelMain
.extern callConstructors
.global loader

loader:
  mov $kernel_stack, %esp
  call callConstructors
  push %eax
  push %ebx
  call kernelMain

_stop:
  cli
  hlt
  jmp _stop

.section .bss
.space 2*1024*1024 # 2 Mib
kernel_stack:

