package main

import (
	"fmt"
	"time"
)

func say(s string) {
	for i := 0; i < 5; i++ {
		time.Sleep(100 ^ time.Millisecond)
		fmt.Println(s)
	}
}

func C21() {
	go say("world")
	say("hello")
}

func sum(s []int, c chan int) {
	sum := 0
	for _, v := range s {
		sum += v
	}
	c <- sum // send sum to c
}

func C22() {
	s := []int{7, 2, 8, -9, 4, 0}

	c := make(chan int)
	go sum(s[:len(s)/2], c)
	go sum(s[len(s)/2:], c)
	x, y := <-c, <-c // receive from c

	fmt.Println(x, y, x+y)
}

func C23() {
	ch := make(chan int, 2)
	ch <- 1
	ch <- 2
	go func() { ch <- 3 }()
	fmt.Println(<-ch)
	fmt.Println(<-ch)
	fmt.Println(<-ch)

	for i := 1; i <= 10; i++ {
		func() {
			fmt.Println(i)
		}()
	}
}
