package main

import (
	"fmt"
	"net/http"
)

func PrintHelloWorld() {
	fmt.Println("Hello World")
}

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Hello World"))
	})
	http.ListenAndServe(":3000", nil)
}
