main:
    la x3, 0x00000004
    la x4, 0x80000000
    li x5, 0xAC
    sb x5, 0(x3)
    sb x5, 0(x4)
