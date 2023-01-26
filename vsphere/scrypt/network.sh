## edit config network of vm with netplan

cat <<EOF > /etc/netplan/01-netcfg.yaml
network:
  version: 2
  ethernets:
    ens192:
      dhcp4: false
      addresses: [{{IP_ADDRESS}}/{{NETMASK}}]
      gateway4: {{GATEWAY}}
      nameservers:
        addresses: [{{DNS}}]
EOF
if [ -f /etc/netplan/50-cloud-init.yaml ]; then
  rm /etc/netplan/50-cloud-init.yaml
fi
netplan apply