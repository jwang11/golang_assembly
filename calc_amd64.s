TEXT ·Add(SB), $0-24
  MOVQ x+0(FP), BX
  MOVQ y+8(FP), BP
  ADDQ BP, BX
  MOVQ BX, ret+16(FP)
  RET

TEXT ·Sub(SB), $0-24
  MOVQ x+0(FP), BX
  MOVQ y+8(FP), BP
  SUBQ BP, BX
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
start:
  ADDQ (BX), SI
  ADDQ $8, BX
  DECQ CX
  JNZ  start
  MOVQ SI, ret+24(FP)
  RET

TEXT ·Sum32(SB), $0-32
  MOVQ $0, SI
  MOVQ sl+0(FP), BX // &sl[0], addr of the first elem
  MOVQ sl+8(FP), CX // len(sl)
start:
  ADDL (BX), SI
  ADDQ $4,  BX
  DECQ CX
  JNZ  start
  MOVL SI, ret+24(FP)
  RET

TEXT ·VAdd(SB), $88-56
  MOVQ p+0(FP), SI
  MOVQ q+24(FP), DI
  VMOVDQU32 (SI), Z1
  VMOVDQU32 (DI), Z2
  VPADDD Z1, Z2, Z3
  VMOVDQU32 Z3, d0-64(SP)

  LEAQ d0-64(SP), BX
  MOVQ BX, 0(SP)
  MOVQ len+8(FP), AX
  MOVQ AX, 8(SP)
  CALL ·Sum32(SB)
  MOVL 24(SP), AX
  MOVL AX, ret+48(FP)
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
