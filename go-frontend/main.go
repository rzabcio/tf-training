package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func indexHandler(w http.ResponseWriter, r *http.Request) {
	if r.URL.Path != "/" {
		http.NotFound(w, r)
		return
	}
	fmt.Fprint(w, "Hello worldzie!")
}

func main() {
	http.HandleFunc("/", indexHandler)
	port := os.Getenv("PORT")

	if port == "" {
		port = "80"
		log.Printf("Defaulting listen to %s", port)
	}

	log.Printf("Listening on port %s", port)
	if err := http.ListenAndServe(":"+port, nil); err!=nil {
		log.Fatal(err)
	}
}
