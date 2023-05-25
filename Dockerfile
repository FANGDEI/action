FROM alpine:latest
WORKDIR /
COPY ./action /
EXPOSE 3000
CMD [ "./action" ]