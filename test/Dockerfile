ARG BASEIMAGE
FROM $BASEIMAGE

COPY run.sh /var/scripts/run.sh
RUN chmod -R 775 /var/scripts/

ENTRYPOINT [ "/var/scripts/run.sh" ]
