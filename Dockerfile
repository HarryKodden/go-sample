ARG APP_NAME="myapp"
ARG APP_USER="myusr"
ARG GID=1000
ARG UID=1000

FROM golang:latest as builder

ARG APP_NAME
ARG APP_USER
ARG GID
ARG UID

ENV APP_HOME /go/src/${APP_NAME}
ENV GO111MODULE on
ENV GOFLAGS -mod=vendor

RUN groupadd --gid $GID $APP_USER && useradd -m -l --uid $UID --gid $GID $APP_USER
RUN mkdir -p $APP_HOME && chown -R $APP_USER:$APP_USER $APP_HOME

USER $APP_USER

WORKDIR $APP_HOME

ADD src .

WORKDIR $APP_HOME

RUN go mod init
RUN go mod download
RUN go mod vendor
RUN go mod verify
RUN go build -o $APP_NAME

FROM debian:buster

ARG APP_NAME
ARG APP_USER

ENV APP_NAME=${APP_NAME}
ENV APP_HOME /go/src/${APP_NAME}

RUN groupadd $APP_USER && useradd -m -g $APP_USER -l $APP_USER
RUN mkdir -p $APP_HOME

WORKDIR $APP_HOME

COPY src/conf/ conf/
COPY src/views/ views/
COPY --chown=0:0 --from=builder $APP_HOME/$APP_NAME /usr/local/bin/$APP_NAME

EXPOSE 8010

USER $APP_USER

CMD ["sh", "-c", "$APP_NAME"]