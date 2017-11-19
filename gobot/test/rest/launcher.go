package main

import (
	"fmt"
	"html"
	"net/http"
)

func home(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello world3")
}

func test(w http.ResponseWriter, r *http.Request) {
	path := r.URL.Path
	fmt.Fprintf(w, "A test, %q", html.EscapeString(path))
}

func main() {
	http.HandleFunc("/", home)
	http.HandleFunc("/test", test)
	fmt.Println("Listening on 8081")

	s := &http.Server{
		Addr: ":8081",
	}
	s.ListenAndServe()
}
