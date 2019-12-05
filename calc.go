package calc

func Add(a int, b int) int
func Sub(a int, b int) int
func Inc(a int) int
func Dec(a int) int
func Sum([]int64) int64
func Sum32([]int32) int32
func VDotProdAVX512(a[] int32, b[] int32) int32
func VDotProdAVX2(a[] int32, b[] int32) int32
func Equal(a[]byte, b[]byte) bool

func VDotProd(a[] int32, b[] int32) int32 {
	var sum1 int32
	sum1 = 0
	for i := 0; i < len(a); i++ {
		sum1 += a[i] *  b[i]
	}
	return sum1
}
