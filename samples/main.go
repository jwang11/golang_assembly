package main

import "golang_assembly"

func main() {
	println(calc.Add(8, 16))
	println(calc.Sub(16, 8))
	println(calc.Sub(8, 16))
	println(calc.Inc(24))
	println(calc.Dec(24))
	var a[16] int32
	var b[16] int32
	for i := 0; i < 16; i++ {
		a[i] = int32(i * i + 1);
		b[i] = int32(i + 1);
	}
	println(calc.VAdd32(a[:], b[:]))
    println(calc.Sum([]int64{1, 2, 3, 4, 5}))
	println(calc.Equal([]byte("hello"), []byte("hello")))
	println(calc.Equal([]byte("hell"), []byte("hello")))
	println(calc.Equal([]byte("hella"), []byte("hello")))
}
