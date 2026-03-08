package main

import (
	"fmt"
	"time"
)

func main() {
	go func() {
		for {
			fmt.Println("Gateway is running...")
			time.Sleep(time.Second)
		}
	}()

	select {}
}
