FROM nuts2k/alpine-glibc
ARG SNELL_URL=https://dl.nssurge.com/snell/snell-server-v4.0.1-linux-amd64.zip
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
        SNELL_URL=https://dl.nssurge.com/snell/snell-server-v4.0.1-linux-aarch.zip; \
    fi
LABEL maintainer="nuts2k" \
         org.label-schema.name="snell-server"
 ENV LANG=C.UTF-8
 ENV PORT=8388
 ENV PSK=
 ENV OBFS=http
 COPY Entrypoint.sh /usr/bin/
 RUN wget --no-check-certificate -O snell.zip $SNELL_URL && \
     unzip snell.zip && \
     rm -f snell.zip && \
     chmod +x snell-server && \
     mv snell-server /usr/bin/ && \
     chmod +x /usr/bin/Entrypoint.sh
 ENTRYPOINT ["Entrypoint.sh"]
