.PHONY: build
build:
	go build -v ./websrv.go
.PHONY: run_go
run_go:
	go run -v ./websrv.go
.PHONY: run_py
run_py:
	python3 ./websrv.py
target: run_go run_py
.DEFAULT_GOAL := build