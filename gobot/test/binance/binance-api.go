package main

import (
	"fmt"
	"math"
	"math/rand"
	"runtime"
	"time"
)

// TheMoon hello, the moon
const TheMoon = 12.34

const (
	// Big thing
	Big = 1 << 100
	// Small thing
	Small = Big >> 99
)

var i, j int = 1, 2
var c, python, java bool = true, false, true

func needInt(x int) int {
	return x*10 + 1
}
func needFloat(x float64) float64 {
	return x * 0.1
}

func add(x, y int) int {
	return x + y
}

func swap(x, y string) (dy, dx string) {
	return y, x
}

func loop() {
	sum := 0
	for i := 0; i < 10; i++ {
		sum += i
	}
	fmt.Println(sum)
	sum = 1
	for sum < 1000 {
		sum += sum
	}
	fmt.Println(sum)
}

func sqrt(x float64) string {
	if x < 0 {
		return sqrt(-x) + "i"
	}
	return fmt.Sprint(math.Sqrt(x))
}

func switchit() {
	fmt.Print("Go runs on ")
	switch os := runtime.GOOS; os {
	case "darwin":
		fmt.Println("OSX")
	case "linux":
		fmt.Println("Linux")
	default:
		fmt.Println(os)
	}
}

func whenIsSaturday() {
	fmt.Println("When's Saturday?")
	today := time.Now().Weekday()
	switch time.Saturday {
	case today + 0:
		fmt.Println("Today.")
	case today + 1:
		fmt.Println("Tomorrow.")
	case today + 2:
		fmt.Println("In two days.")
	default:
		fmt.Println("Too far away.")
	}
}

func deferit() {
	fmt.Println("counting")
	for i := 0; i < 10; i++ {
		defer fmt.Println(i)
	}
	fmt.Println("done")
}

func main() {
	fmt.Println("My favourite number is", rand.Intn(10))
	fmt.Printf("Now you have %g problems.", math.Sqrt(7))
	fmt.Println(math.Pi)
	fmt.Println(add(42, 13))
	a, b := swap("hello", "world!")
	fmt.Println(a, b)
	var i int
	fmt.Println(i, c, python, java)
	c := 24.5
	fmt.Println(c)
	fmt.Println(needInt(Small))
	fmt.Println(needFloat(Small))
	fmt.Println(needFloat(Big))
	loop()
	fmt.Println(sqrt(2), sqrt(-4))
	switchit()
	whenIsSaturday()
	fmt.Println(time.Now())
	deferit()
}
