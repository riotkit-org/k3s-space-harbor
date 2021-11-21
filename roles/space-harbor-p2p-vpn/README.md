Space Harbor P2P-VPN
====================

Creates a self-healing, high performance, low latency VPN between primary node and compute nodes, designed for Kubernetes cluster usage.
Shares vars with `riotkit/space-harbor` Ansible role, designed to be used together.


Getting started
---------------

1. **Setup inventory**

The following are only examples, please adjust values to you needs basing on the comment/instruction.

`inventory/group_vars/all.yaml`

```yaml
net_cluster_cidr: "10.42.0.0/16"   # Network which keeps Kubernetes API access IP
net_services_cidr: "10.43.0.0/16"  # ClusterIP services network
vpn_primary_ip: "10.161.0.1"       # Desired VPN IP address of a primary Kubernetes node
primary_node_public_ip: "1.2.3.4"  # Public IP address of a primary Kubernetes node
```

`inventory/group_vars/k3s-node.yaml`

```yaml
node_type: "compute"
```

`inventory/group_vars/k3s-primary.yml`

```yaml
node_type: "primary"
```

`inventory/hosts.cfg`

```yaml
[k3s-primary]
1.2.3.4 ansible_ssh_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa_ovh

[k3s-node]
localhost ansible_ssh_port=2222 ansible_ssh_user=ubuntu ansible_ssh_private_key_file="~/VirtualBox VMs/k3s-node/.vagrant/machines/default/virtualbox/private_key"
```

2. **Install on primary node**

```bash
ansible-playbook ./playbook.yaml -i inventory/hosts.cfg --limit k3s-primary
```

3. **Connect compute nodes**

**Notice:** This playbook will use artifact produced in previous step. Repeating previous step will reproduce the same artifact without impacting your VPN.

```bash
ansible-playbook ./playbook.yaml -i inventory/hosts.cfg --limit k3s-node
```
