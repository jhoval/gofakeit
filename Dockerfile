FROM golang:latest as builder

RUN mkdir /build
ADD . /build/

WORKDIR /build

ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=auto GOBIN=$GOPATH/bin

RUN go get && go build -ldflags="-w -s" -o main .

FROM alpine

RUN adduser -S -D -H -h /app app
USER app
COPY --from=builder /build/main /app/
WORKDIR /app

ENTRYPOINT ["./main"]