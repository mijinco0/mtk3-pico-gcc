################################################################################
# micro T-Kernel 3.0 BSP makefile
#     Target Board: Raspberry Pi Pico
################################################################################

EXE_FILE := mtk3pico

GCC := arm-none-eabi-gcc
AS := arm-none-eabi-gcc
LINK := arm-none-eabi-gcc
SIZE := arm-none-eabi-size
E2U := tools/elf2uf2
ifneq ($(wildcard $(E2U)), $(E2U))
E2U :=
endif

CFLAGS := -mcpu=cortex-m0plus -mthumb -ffreestanding\
    -std=gnu11 \
    -O0 -g3 \
    -MMD -MP \
    -mfloat-abi=soft \

ASFLAGS := -mcpu=cortex-m0plus -mthumb -ffreestanding\
    -x assembler-with-cpp \
    -O0 -g3 \
    -MMD -MP \

LFLAGS := -mcpu=cortex-m0plus -mthumb -ffreestanding \
    -nostartfiles \
    -O0 -g3 \
    -mfloat-abi=soft \

LNKFILE := "../etc/linker/pico_rp2040/tkernel_map.ld"

include mtkernel_3/lib/libtm/sysdepend/pico_rp2040/subdir.mk
include mtkernel_3/lib/libtm/sysdepend/no_device/subdir.mk
include mtkernel_3/lib/libtk/sysdepend/cpu/rp2040/subdir.mk
include mtkernel_3/lib/libtk/sysdepend/cpu/core/armv6m/subdir.mk
include mtkernel_3/lib/libbsp/sysdepend/cpu/rp2040/subdir.mk
include mtkernel_3/kernel/sysdepend/pico_rp2040/subdir.mk
include mtkernel_3/kernel/sysdepend/cpu/rp2040/subdir.mk
include mtkernel_3/kernel/sysdepend/cpu/core/armv6m/subdir.mk
