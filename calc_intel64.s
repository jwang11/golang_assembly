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
  MOVQ av+0(FP), BX // address of vector
  MOVQ lv+8(FP), CX // len of vector
start:
  ADDQ (BX), SI
  ADDQ $8, BX
  DECQ CX
  JNZ  start
  MOVQ SI, ret+24(FP)
  RET

TEXT ·Sum32(SB), $0-32
  MOVQ $0, SI
  MOVQ av+0(FP), BX // address of vector
  MOVQ lv+8(FP), CX // len of vector
start:
  ADDL (BX), SI
  ADDQ $4,  BX
  DECQ CX
  JNZ  start
  MOVL SI, ret+24(FP)
  RET

// func VDotProdAVX512(a[] int32, b[] int32) int32 
// $96 denotes the size in bytes of the stack-frame.
// $56 specifies the size of the arguments passed in by the caller.
TEXT ·VDotProdAVX512(SB), $96-56
// Move the address of a, address of b, and array length to registers
// SI, DI, and CX respectively. For simplicity, we assume the length of
// array a and b are equal and addresses have a 64-byte alignment.
  MOVQ a+0(FP), SI		// address of a 
  MOVQ b+24(FP), DI		// address of b
  MOVQ len+8(FP), CX 	// array length

// Z4 is an accumulator that sums all vector multiplication results.
// Compute Z3 = Z1 * Z2 and Z4 = Z4 + Z3 using the VMOVDQU32, VPMULLD
// and VPADDD instructions. If the array length is greater than 16, 
// loop execution until we reach the end of array. Store Z4 to the stack
// frame address, vr, which is 64 bytes (512 bits) long
  VPXORD Z4, Z4, Z4
start:
  VMOVDQU32 (SI), Z1
  VMOVDQU32 (DI), Z2
  VPMULLD Z1, Z2, Z3
  VPADDD Z3, Z4, Z4
  ADDQ $64, SI
  ADDQ $64, DI
  SUBQ $16, CX
  JNZ start
  VMOVDQU32 Z4, d0-64(SP)// vector result to stack		

// Convert the vector result to a scalar result by summing the INT32 elements
// and return the result.
  LEAQ d0-64(SP), BX
  MOVQ BX, 0(SP)
  MOVQ $16, AX 		// array length
  MOVQ AX, 8(SP)
  CALL ·Sum32(SB)	// invoke Sum32 to get scalar value
  MOVL 24(SP), AX
  MOVL AX, ret+48(FP)	// final result 
  RET

TEXT ·VDotProdAVX2(SB), $64-56
  MOVQ a+0(FP), SI		// address of a
  MOVQ b+24(FP), DI		// address of b
  MOVQ len+8(FP), CX	// array length
  VPXORD Y4, Y4, Y4

start:
  VMOVDQU32 (SI), Y1
  VMOVDQU32 (DI), Y2
  VPMULLD Y1, Y2, Y3
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
