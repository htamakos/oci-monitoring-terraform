#!/bin/sh

# Security
sudo systemctl stop firewalld
sudo setenforce 0

# Graphana Install
sudo yum install -y https://dl.grafana.com/oss/release/grafana-6.2.2-1.x86_64.rpm
sudo yum install -y initscripts fontconfig
sudo systemctl status grafana-server
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Setup OCI Data Source
sudo grafana-cli plugins install oci-datasource
if [ -f /tmp/oci_datasource.yaml ]; then
  sudo mv /tmp/oci_datasource.yaml /etc/grafana/provisioning/datasources/oci.yaml 
fi
sudo systemctl restart grafana-server
