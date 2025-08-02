FROM ghcr.io/plankanban/planka:2.0.0-rc.3

WORKDIR /app

COPY custom.css /app/public/assets/custom.css

RUN sed -i 's|<title>PLANKA</title>|<title>PLANKA by GDS</title>|' /app/public/index.html
RUN sed -i 's|<title>PLANKA</title>|<title>PLANKA by GDS</title>|' /app/views/index.html

RUN sed -i 's| </head>|<link rel="stylesheet" crossorigin href="/assets/custom.css"></head>|' /app/public/index.html
RUN sed -i 's| </head>|<link rel="stylesheet" crossorigin href="/assets/custom.css"></head>|' /app/views/index.html

COPY gds-dsit-gdad-cover.jpg /tmp/gds-dsit-gdad-cover.jpg

RUN for f in /app/public/assets/cover-*.jpg; do \
      cp /tmp/gds-dsit-gdad-cover.jpg "$f"; \
    done

VOLUME /app/public/favicons
VOLUME /app/public/user-avatars
VOLUME /app/public/background-images
VOLUME /app/private/attachments

EXPOSE 1337

HEALTHCHECK --interval=10s --timeout=2s --start-period=15s \
  CMD node ./healthcheck.js

CMD ["./start.sh"]
