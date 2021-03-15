FROM gcr.io/distroless/base

COPY myip /myip

USER nobody

ENTRYPOINT ["/myip"]
EXPOSE 8080
