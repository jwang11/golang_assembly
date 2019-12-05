package calc

import (
	"testing"
)

func TestAdd(t *testing.T) {
	var sum1 int = 18 + 9
	var sum2 int = Add(18, 9)
	if sum1 != sum2	{
		t.Errorf("Add should return %d, but %d", sum1, sum2)
	}
}

func TestSub(t *testing.T) {
	var diff1 int = 18 - 9
	var diff2 int = Sub(18, 9)
	if diff1 != diff2	{
		t.Errorf("Sub should return %d, but %d", diff1, diff2)
	}
	diff1 = 9 - 18
	diff2 = Sub(9, 18)
	if diff1 != diff2	{
		t.Errorf("Sub should return %d, but %d", diff1, diff2)
	}
}

func TestSum(t *testing.T) {
	a := []int64{1, 2, 3, 4, 5}
	var sum1, sum2 int64 = 0, 0
	for _, x := range a {
		sum1 += x
	}
    sum2 = Sum(a)
	if sum1 != sum2	{
		t.Errorf("Sum should return %d, but %d", sum1, sum2)
	}
}

func TestSum32(t *testing.T) {
	a := []int32{1, 2, 3, 4, 5}
	var sum1, sum2 int32 = 0, 0
	for _, x := range a {
		sum1 += x
	}
    sum2 = Sum32(a)
	if sum1 != sum2	{
		t.Errorf("Sum32 should return %d, but %d", sum1, sum2)
	}
}
	
func TestVDotProdAVX512(t *testing.T) {
	var a[512] int32
	var b[512] int32
	var sum1 int32
	sum1 = 0
	for i := 0; i < 512; i++ {
		a[i] = int32(i + 1);
		b[i] = int32(2 * i);
		sum1 += a[i] *  b[i]
	}
    var sum2 int32
	sum2 = VDotProdAVX512(a[:], b[:])
	if sum1 != sum2	{
		t.Errorf("VDotProdAVX512 should return %d, but %d", sum1, sum2)
	}
}

func TestVDotProdAVX2(t *testing.T) {
	var a[512] int32
	var b[512] int32
	var sum1 int32
	sum1 = 0
	for i := 0; i < 512; i++ {
		a[i] = int32(i + 1);
		b[i] = int32(2 * i);
		sum1 += a[i] * b[i]
	}
    var sum2 int32
	sum2 = VDotProdAVX2(a[:], b[:])
	if sum1 != sum2	{
		t.Errorf("VDotProdAVX2 should return %d, but %d", sum1, sum2)
	}
}


func TestEqual(t *testing.T) {
	if !Equal([]byte("hello"), []byte("hello")) {
		t.Errorf("Equal should return true, but false")
	}
	if Equal([]byte("hella"), []byte("hello")) {
		t.Errorf("Equal should return true, but false")
	}
	if Equal([]byte("helloa"), []byte("hello")) {
		t.Errorf("Equal should return true, but false")
	}
}

func BenchmarkVDotProd(b *testing.B) {
	var d1[1024] int32
	var d2[1024] int32
	for i := 0; i < 1024; i++ {
		d1[i] = int32(i + 1);
		d2[i] = int32(2 * i);
	}

    var sum2 int32 = 0
	b.SetBytes(1024)
	b.ResetTimer()
    for i := 0; i < b.N; i++ {
		sum2 += VDotProd(d1[:], d2[:]) % 1024
    }
}

func BenchmarkVDotProdAVX512(b *testing.B) {
	var d1[1024] int32
	var d2[1024] int32
	for i := 0; i < 1024; i++ {
		d1[i] = int32(i + 1);
		d2[i] = int32(2 * i);
	}

    var sum2 int32 = 0
	b.SetBytes(1024)
	b.ResetTimer()
    for i := 0; i < b.N; i++ {
		sum2 += VDotProdAVX512(d1[:], d2[:]) % 1024
    }
}

func BenchmarkVDotProdAVX2(b *testing.B) {
	var d1[1024] int32
	var d2[1024] int32
	for i := 0; i < 1024; i++ {
		d1[i] = int32(i + 1);
		d2[i] = int32(2 * i);
	}

    var sum2 int32 = 0
	b.SetBytes(1024)
	b.ResetTimer()
    for i := 0; i < b.N; i++ {
		sum2 += VDotProdAVX2(d1[:], d2[:]) % 1024
    }
}
