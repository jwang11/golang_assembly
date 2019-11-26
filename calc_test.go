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
	
func TestVAdd(t *testing.T) {
	var a[16] int32
	var b[16] int32
	var sum1 int32
	sum1 = 0
	for i := 0; i < 16; i++ {
		a[i] = int32(i * i + 1);
		b[i] = int32(i + 1);
		sum1 += a[i] + b[i]
	}
    var sum2 int32
	sum2 = VAdd(a[:], b[:])
	if sum1 != sum2	{
		t.Errorf("VAdd should return %d, but %d", sum1, sum2)
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

