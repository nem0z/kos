package main

import (
	"fmt"
	"time"
)

func main() {
	go func() {
		for {
			fmt.Println("Node is running...")
			time.Sleep(time.Second)
		}
	}()

	select {}
}
