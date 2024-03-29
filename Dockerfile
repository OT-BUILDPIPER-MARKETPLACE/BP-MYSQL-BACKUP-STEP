FROM alpine
RUN apk add --no-cache --upgrade bash
RUN apk add sed 
RUN apk add openssh 
RUN apk add jq
COPY build.sh .
COPY BP-BASE-SHELL-STEPS .
RUN chmod +x build.sh
ENV ACTIVITY_SUB_TASK_CODE BP-STRING-REPLACE-TASK
ENV SLEEP_DURATION 0s
ENV DATABASE_BACKUP_DIR ""
ENV DATABASE ""
ENV SSH_USERNAME ""
ENV SSH_IP_ADDRESS ""
ENV SSH_PORT ""
ENV SSH_PRIVATE_KEY_FILE ""
ENTRYPOINT [ "./build.sh" ]
