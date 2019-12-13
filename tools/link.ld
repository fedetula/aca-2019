ENTRY(_start)

SECTIONS
{
    . = 0x0;
    .text : { *(.text) }
    . = ALIGN(0x16000);
    .data : { *(.data) }
}
