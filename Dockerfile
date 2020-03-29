FROM consul:1.7.2
RUN set -uex; \
    mkdir /tmp/data \
    consul agent -server --bootstrap -data-dir /tmp/data & \ 
    let "timeout = $(date +%s) + 30"; \
    while [[ -z `curl -f -s http://localhost:8500/v1/status/leader | grep "[0-9]:[0-9]"` ]]; do\
      if [ $(date +%s) -gt $timeout ]; then echo "timeout"; exit 1; fi; \
      sleep 1; \
    done; \
    consul kv put foo bar;
