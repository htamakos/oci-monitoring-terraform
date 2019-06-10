#!/bin/sh

# Install Nginx
sudo yum install -y nginx
cat <<-'EOS' > /tmp/nginx.conf
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    include /etc/nginx/conf.d/*.conf;

    server {
        listen       80 default_server;
        listen       [::]:80 default_server;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        location / {
          proxy_pass    http://localhost:8080/app/;
        }

        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }
}
EOS
sudo mv /tmp/nginx.conf /etc/nginx/nginx.conf
sudo systemctl restart nginx

# Install OCI CLI
## for opc
bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh) --accept-all-defaults"

## for root
sudo bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh) --accept-all-defaults"

# Setup OCI CLI
## for opc
mkdir -p ~/.oci
cp /tmp/oci_config ~/.oci/config
cp /tmp/oci_api_key.pem ~/.oci/
chmod 600 ~/.oci/config
chmod 600 ~/.oci/oci_api_key.pem
## for root
sudo mkdir -p /root/.oci
sudo mv /tmp/oci_config /root/.oci/config
sudo mv /tmp/oci_api_key.pem /root/.oci/
sudo chmod 600 /root/.oci/config
sudo chmod 600 /root/.oci/oci_api_key.pem


# fluentd
curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent3.sh | sh
sudo sed -e "s/User=.*/User=root/" -e "s/Group=.*/User=root/" -i /lib/systemd/system/td-agent.service
sudo systemctl daemon-reload

cat <<'EOS' > /tmp/td-agent.conf
<source>
  @type tail
  path /var/log/nginx/access.log
  tag nginx.access
  pos_file /var/log/td-agent/nginx.access.pos
  format /^(?<remote>[^ ]*) (?<host>[^ ]*) (?<user>[^ ]*) \[(?<time>[^\]]*)\] "(?<method>\S+)(?: +(?<path>[^ ]*) +\S*)?" (?<code>[^ ]*) (?<size>[^ ]*)(?: "(?<referer>[^\"]*)" "(?<agent>[^\"]*)" "(?<forwarder>[^\"]*)")?/
  time_key time_local
</source>

<match nginx.access>
  @type exec
  command /opt/td-agent/embedded/bin/ruby /etc/td-agent/post_oci_stream.rb > /tmp/exec_oci.log
  <buffer>
    @type file
    path /tmp/buffer
    flush_interval 5s
  </buffer>
  <format>
    @type json
  </format>
</match>
EOS
sudo mv /tmp/td-agent.conf /etc/td-agent
sudo mv /tmp/post_oci_stream.rb /etc/td-agent

sudo systemctl restart td-agent.service

