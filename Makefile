.PHONY: build run clean test lint tidy

BINARY=ego
CMD=./cmd/ego

build:
	go build -o $(BINARY) $(CMD)

run: build
	./$(BINARY)

clean:
	rm -f $(BINARY)

test:
	go test ./...

lint:
	go vet ./...

tidy:
	go mod tidy
