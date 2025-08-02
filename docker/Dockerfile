FROM ghcr.io/plankanban/planka:2.0.0-rc.3

WORKDIR /app

COPY custom.css /app/public/assets/custom.css
COPY pre-run.sh /app/pre-run.sh
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

CMD ["/app/pre-run.sh && /app/start.sh"]
