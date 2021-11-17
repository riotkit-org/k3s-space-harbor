K3S Riotkit Cluster
===================

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

Signing certificate for Sealed Secrets mechanism
------------------------------------------------

After installing ArgoCD and synchronizing "sealed-secrets" application you need to get a certificate that should be used for signing.

```bash
# execute on primary cluster node shell
curl http://$(kubectl get service/sealed-secrets -n vault -o jsonpath='{.spec.clusterIP}'):8080/v1/cert.pem
```
