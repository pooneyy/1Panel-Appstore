FROM debian:bullseye-slim AS base
ENV TZ=Asia/Shanghai
RUN mkdir -p /app/pfg && \
    apt-get update && apt-get upgrade -y && \
    apt-get install -y wget unzip tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /app/pfg

FROM base AS agent
RUN wget -O pfg.zip https://gitee.com/tavenli/port-forward/releases/download/v1.3.7/forward-agent.linux64.v1.3.7.zip && \
    unzip pfg.zip && \
    rm -rf pfg.zip && \
    chmod +x /app/pfg/forward-agent/forward-agent
WORKDIR /app/pfg/forward-agent
CMD ["./forward-agent"]

FROM base AS server
RUN wget -O pfg.zip https://gitee.com/tavenli/port-forward/releases/download/v1.3.7/forward-server.linux64.v1.3.7.zip && \
    unzip pfg.zip && \
    rm -rf pfg.zip && \
    chmod +x /app/pfg/forward-server/start.sh && \
    chmod +x /app/pfg/forward-server/forward-server
WORKDIR /app/pfg/forward-server
CMD ["./forward-server"]
