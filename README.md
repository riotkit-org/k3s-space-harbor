K3S Riotkit Cluster
===================

DANGER: This project is highly in WORK IN PROGRESS state. Subscribe this repository for releases if you want to be notified.

Creates a K3S single-node or multi-node cluster managed fully by ArgoCD.
Requires write access to GIT repository.

Architecture
------------

**Provided by K3S:**
- CoreDNS + Flannel: Networking
- Embedded service load balancer
- ETCD

**Of choice:**
- Cluster management: ArgoCD connected with a single "cluster-wide" GIT repository. Components synchronized on-click
- Gateway: Traefik + Let's Encrypt
- Infracheck: Health checks provided via HTTPS endpoint for external monitoring service (e.g. UptimeRobot)
- Metrics: Passing to centralized Telegraf instance
- Secrets management: https://github.com/bitnami-labs/sealed-secrets
- SMTP relay: https://artifacthub.io/packages/helm/docker-postfix/mail
- Backup: Bahub (todo)

Any of above components can be disabled in Ansible vars.
Cluster uses `etcd` instead of `sqlite3` due to lack of backup possibilities in `sqlite3` variant.

Security
--------

Kubernetes API is private, accessible only on `localhost:6443`. ArgoCD is accessible on a public domain behind basic auth.

**Target security considerations**

1. Expose `Kubernetes Dashboard` and `ArgoCD` on separate HTTPS port
2. Set up a webservice that will allow authorizing cluster admin via web panel to open ports for its IP address for
   a fixed period of time e.g. 30 minutes or 24 hours

Using Sealed Secrets mechanism
------------------------------

After installing ArgoCD and synchronizing "sealed-secrets" application Ansible will store "sealed-secrets.cert.pem" file in `artifacts` local project directory.
Use `kubeseal` cli locally using this secret, or on the server using certificate at path `/etc/rancher/k3s/sealed-secrets.cert.pem`.

```bash
cat configmap.yaml | kubeseal --cert /etc/rancher/k3s/sealed-secrets.cert.pem
```

Upgrading
---------

### Compute node

```bash
ansible-playbook ./playbook.yaml -i inventory/hosts.cfg -t cluster --limit k3s-node -e force_k3s_upgrade=true
```

### Primary node

```bash
ansible-playbook ./playbook.yaml -i inventory/hosts.cfg -t k3s --limit k3s-primary -e force_k3s_upgrade=true
```
