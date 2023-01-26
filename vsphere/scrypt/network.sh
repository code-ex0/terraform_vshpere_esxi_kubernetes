## edit config network of vm with netplan

cat <<EOF > /etc/netplan/01-netcfg.yaml
network:
  version: 2
  ethernets:
    ens192:
      dhcp4: false
      addresses: [192.168.1.31/24]
      gateway4: 192.168.1.1
      nameservers:
        addresses: [1.1.1.1, 1.1.0.0]
EOF
rm /etc/netplan/50-cloud-init.yaml
netplan apply