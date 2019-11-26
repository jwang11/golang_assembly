package main

import "golang_assembly"

func main() {
	println(calc.Add(8, 16))
	println(calc.Inc(24))
	var a[16] int
	var b[16] int
	for i := 0; i < 16; i++ {
		a[i] = i * i + 1;
		b[i] = i + 1;
	}
	println(calc.AAdd(a[:], b[:]))
    println(calc.Sum([]int64{1, 2, 3, 4, 5}))
	println(calc.Equal([]byte("hello"), []byte("hello")))
	println(calc.Equal([]byte("hell"), []byte("hello")))
	println(calc.Equal([]byte("hella"), []byte("hello")))
}
