GOPKG ?=	moul.io/event

GENERATE_STEPS += pb.generate

all: test install

include rules.mk

.PHONY: pb.generate
pb.generate: event.pb.go store/store.pb.go

.PHONY: pb.clean
pb.clean:
	rm -f $(wildcard *.pb.go */*.pb.go)

%.pb.go: %.proto
	go mod vendor
	protoc \
	  -I vendor:. \
	  --grpc-gateway_out=logtostderr=true:"$(GOPATH)/src" \
	  --gogofaster_out=plugins=grpc:"$(GOPATH)/src" \
	  "$(dir $<)"/*.proto
	goimports -w $@
