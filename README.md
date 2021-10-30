K3S Riotkit Cluster
===================

Creates a K3S single-node or multi-node cluster managed fully by ArgoCD.
Requires write access to GIT repository.

Architecture
------------

**Provided by K3S:**
- CoreDNS + Flannel: Networking
- Embedded service load balancer

**Of choice:**
- Cluster management: ArgoCD connected with a single "cluster-wide" GIT repository. Components synchronized on-click
- Gateway: Traefik + Let's Encrypt
- Infracheck: Health checks
- Telegraf: Metrics monitoring to external, centralized Telegraf instance
- Hashicorp Vault: Secrets management

Security
--------

Kubernetes API is private, accessible only on `localhost:6443`. ArgoCD is accessible on a public domain behind basic auth.

**Target security considerations**

1. Expose `Kubernetes Dashboard` and `ArgoCD` on separate HTTPS port
2. Set up a webservice that will allow authorizing cluster admin via web panel to open ports for its IP address for
   a fixed period of time e.g. 30 minutes or 24 hours
