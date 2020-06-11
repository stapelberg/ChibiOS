/*
    ChibiOS - Copyright (C) 2006..2018 Giovanni Di Sirio

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

ENTRY(Reset_Handler)

SECTIONS
{
/*

The Teensy 4.1 has an ARM Cortex M7 with 160+16 interrupts, so we need to align
256, the nearest power of two, as per:
http://infocenter.arm.com/help/topic/com.arm.doc.dui0646c/DUI0646C_cortex_m7_dgug.pdf section 4.3.4:

When setting TBLOFF, you must align the offset to the number of exception
entries in the vector table. The minimum alignment is 32 words, enough for up to
16 interrupts. For more interrupts, adjust the alignment by rounding up to the
next power of two. For example, if you require 21 interrupts, the alignment must
be on a 64-word boundary because the required table size is 37 words, and the
next power of two is 64.

Note: Table alignment requirements mean that bits[6:0] of the table offset are
always zero.

*/
    .vectors : ALIGN(256)
    {
        KEEP(*(.vectors))
    } > VECTORS_FLASH AT > VECTORS_FLASH_LMA

    .xtors : ALIGN(4)
    {
        __init_array_base__ = .;
        KEEP(*(SORT(.init_array.*)))
        KEEP(*(.init_array))
        __init_array_end__ = .;
        __fini_array_base__ = .;
        KEEP(*(.fini_array))
        KEEP(*(SORT(.fini_array.*)))
        __fini_array_end__ = .;
    } > XTORS_FLASH AT > XTORS_FLASH_LMA

    .text : ALIGN_WITH_INPUT
    {
        __text_base__ = .;
        *(.text)
        *(.text.*)
        *(.glue_7t)
        *(.glue_7)
        *(.gcc*)
        __text_end__ = .;
    } > TEXT_FLASH AT > TEXT_FLASH_LMA

    .rodata : ALIGN(4)
    {
        __rodata_base__ = .;
        *(.rodata)
        *(.rodata.*)
        . = ALIGN(4);
        __rodata_end__ = .;
    } > RODATA_FLASH AT > RODATA_FLASH_LMA

    .ARM.extab :
    {
        *(.ARM.extab* .gnu.linkonce.armextab.*)
    } > VARIOUS_FLASH AT > VARIOUS_FLASH_LMA

    .ARM.exidx : {
        __exidx_base__ = .;
        __exidx_start = .;
        *(.ARM.exidx* .gnu.linkonce.armexidx.*)
        __exidx_end__ = .;
        __exidx_end = .;
     } > VARIOUS_FLASH AT > VARIOUS_FLASH_LMA

    .eh_frame_hdr :
    {
        *(.eh_frame_hdr)
    } > VARIOUS_FLASH AT > VARIOUS_FLASH_LMA

    .eh_frame : ONLY_IF_RO
    {
        *(.eh_frame)
    } > VARIOUS_FLASH AT > VARIOUS_FLASH_LMA
}
