ARG APP_HOME="."
ARG APP_NAME="APP"
ARG APP_PORT=8888

FROM golang:latest

ARG APP_HOME
ARG APP_NAME
ARG APP_PORT

ENV APP_NAME=$APP_NAME
ENV GO111MODULE on
ENV GOFLAGS -mod=vendor

WORKDIR $GOPATH/src/$APP_NAME

COPY . .

WORKDIR $GOPATH/src/$APP_NAME/$APP_HOME

RUN go mod init
RUN go mod download
RUN go mod vendor
RUN go mod verify
RUN go build -o /usr/local/bin/$APP_NAME

EXPOSE $APP_PORT

CMD ["sh", "-c", "$APP_NAME"]