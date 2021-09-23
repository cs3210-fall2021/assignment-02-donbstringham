package main

import "fmt"
import "runtime"

func main() {
        runtime.GOMAXPROCS(runtime.NumCPU())
	fmt.Println("hello world")
}
