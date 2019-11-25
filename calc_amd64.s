TEXT ·Add(SB), $0-24
  MOVQ x+0(FP), BX
  MOVQ y+8(FP), BP
  ADDQ BP, BX
  MOVQ BX, ret+16(FP)
  RET

TEXT ·Inc(SB), $0-16
  MOVQ x+0(FP), AX
  INCQ AX
  MOVQ AX, ret+8(FP)
  RET

TEXT ·Dec(SB), $0-16
  MOVQ x+0(FP), AX
  DECQ AX
  MOVQ AX, ret+8(FP)
  RET

TEXT ·Sum(SB), $0-32
    MOVQ $0, SI
    MOVQ sl+0(FP), BX // &sl[0], addr of the first elem
    MOVQ sl+8(FP), CX // len(sl)
    INCQ CX           // CX++, 因为要循环 len 次

start:
    DECQ CX
    JZ   done
    ADDQ (BX), SI
    ADDQ $8, BX
    JMP  start

done:
    MOVQ SI, ret+24(FP)
    RET

TEXT ·AAdd(SB), $0-56
  MOVQ p+0(FP), SI
  MOVQ q+24(FP), DI
  VMOVUPS (SI), Z1
  VMOVUPS (DI), Z2
  VPADDD Z1, Z2, Z3
  MOVQ $16, AX
  MOVQ AX, ret+48(FP)
  RET

TEXT ·Equal(SB),7,$0
        MOVL    len+8(FP), BX
        MOVL    len1+32(FP), CX
        MOVL    $0, AX
        CMPL    BX, CX
        JNE     eqret
        MOVQ    p+0(FP), SI
        MOVQ    q+24(FP), DI
        CLD
        REP; CMPSB
        MOVL    $1, DX
        CMOVLEQ DX, AX
eqret:
        MOVB    AX, ret+48(FP)
        RET
