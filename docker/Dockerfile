FROM ghcr.io/plankanban/planka:2.0.0-rc.3

WORKDIR /app

RUN sed -i 's|<title>PLANKA</title>|<title>PLANKA by GDS</title>|' public/index.html
RUN sed -i 's/#21212180/none/g' public/assets/index-*.css
RUN sed -i 's/Powered by PLANKA/Powered by PLANKA, managed by GDS/g' public/assets/index-*.js

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
