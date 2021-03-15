package main

import (
	"context"
	"fmt"
	"github.com/kelseyhightower/envconfig"
	"log"
	"net"
	"net/http"
	"os"
	"os/signal"
	"syscall"
)

type envConfig struct {
	Port string `envconfig:"PORT" default:"8080"`
}

func myip(w http.ResponseWriter, req *http.Request) {

	myip := req.Header.Get("X-Forwarded-For")

	if myip == "" {
		myip2, _, _ := net.SplitHostPort(req.RemoteAddr)
		myip = myip2
	}

	fmt.Fprintf(w, "%s", myip)
}

func main() {

	var env envConfig
	if err := envconfig.Process("", &env); err != nil {
		log.Printf("[ERROR] Failed to process env var: %s", err)
		return
	}

	http.HandleFunc("/", myip)

	s := http.Server{Addr: fmt.Sprint(":", env.Port)}
	go func() {
		log.Fatal(s.ListenAndServe())
	}()

	signalChan := make(chan os.Signal, 1)
	signal.Notify(signalChan, syscall.SIGINT, syscall.SIGTERM)
	<-signalChan
	log.Printf("Shutdown signal received, exiting...")

	s.Shutdown(context.Background())
}
