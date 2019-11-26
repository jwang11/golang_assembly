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
  MOVQ sl+0(FP), BX // &sl[0]
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
  MOVQ sl+0(FP), BX // &sl[0]
  MOVQ sl+8(FP), CX // len(sl)
start:
  ADDL (BX), SI
  ADDQ $4,  BX
  DECQ CX
  JNZ  start
  MOVL SI, ret+24(FP)
  RET

TEXT ·VAdd32AVX512(SB), $96-56
  MOVQ p+0(FP), SI
  MOVQ q+24(FP), DI
  MOVQ len+8(FP), CX // length
  VPXORD Z4, Z4, Z4

start:
  VMOVDQU32 (SI), Z1
  VMOVDQU32 (DI), Z2
  VPADDD Z1, Z2, Z3
  VPADDD Z3, Z4, Z4
  ADDQ $64, SI
  ADDQ $64, DI
  SUBQ $16, CX
  JNZ start
  VMOVDQU32 Z4, d0-64(SP)

  LEAQ d0-64(SP), BX
  MOVQ BX, 0(SP)
  MOVQ $16, AX //array length
  MOVQ AX, 8(SP)
  CALL ·Sum32(SB)
  MOVL 24(SP), AX
  MOVL AX, ret+48(FP)
  RET

TEXT ·VAdd32AVX2(SB), $64-56
  MOVQ p+0(FP), SI
  MOVQ q+24(FP), DI
  MOVQ len+8(FP), CX // length
  VPXORD Y4, Y4, Y4

start:
  VMOVDQU32 (SI), Y1
  VMOVDQU32 (DI), Y2
  VPADDD Y1, Y2, Y3
  VPADDD Y3, Y4, Y4
  ADDQ $32, SI
  ADDQ $32, DI
  SUBQ $8, CX
  JNZ start
  VMOVDQU32 Y4, d0-32(SP)

  LEAQ d0-32(SP), BX
  MOVQ BX, 0(SP)
  MOVQ $8, AX //array length
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
