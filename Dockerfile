FROM golang:latest

ARG CFSSL_VER="v1.4.1"

RUN go get -d github.com/cloudflare/cfssl/cmd/cfssl && \
    go get -d github.com/cloudflare/cfssl/cmd/cfssljson && \
    cd /go/src/github.com/cloudflare/cfssl && \
    git fetch origin refs/tags/${CFSSL_VER} && \
    git checkout refs/tags/${CFSSL_VER} && \
    go build -o /usr/local/bin/cfssl github.com/cloudflare/cfssl/cmd/cfssl && \
    go build -o /usr/local/bin/cfssljson github.com/cloudflare/cfssl/cmd/cfssljson && \
    go get bitbucket.org/liamstask/goose/cmd/goose && \
    goose -path $GOPATH/src/github.com/cloudflare/cfssl/certdb/sqlite up && \
    mkdir /etc/cfssl && \
    cp certstore_development.db /etc/cfssl/certs.db
WORKDIR /etc/cfssl
COPY ./ca-config.json .
COPY ./db-config.json .
COPY ./ca-csr.json .
COPY ./proxy.json .
RUN cfssl genkey -config ca-config.json -initca ca-csr.json | cfssljson -bare example-ca
RUN cfssl gencert -remote="localhost:8888" ca.demo.internal proxy.json
VOLUME [ "/etc/cfssl" ]
EXPOSE 8888
ENTRYPOINT ["cfssl"]

