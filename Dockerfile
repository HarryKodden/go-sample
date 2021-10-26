FROM golang:1.15.7-buster

ENV APP_USER app
ENV APP_HOME /go/src/mathapp

ENV GO111MODULE=on
ENV GOFLAGS=-mod=vendor

ENV GID 1000
ENV UID 1000

RUN groupadd --gid $GID app && useradd -m -l --uid $UID --gid $GID $APP_USER
RUN mkdir -p $APP_HOME && chown -R $APP_USER:$APP_USER $APP_HOME

USER $APP_USER

WORKDIR $APP_HOME

ADD src .

WORKDIR $APP_HOME

RUN go mod init
RUN go mod download
RUN go mod vendor
RUN go mod verify
RUN go build -o mathapp

EXPOSE 8010

CMD ["./mathapp", "run"]