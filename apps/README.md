# Applications

- [Applications](#applications)
  - [Docker](#docker)
  - [Automation \& Orchestration](#automation--orchestration)
  - [Databases](#databases)
  - [Wiki \& Knowledge Base](#wiki--knowledge-base)
  - [Distributed messaging](#distributed-messaging)
  - [Observability \& Monitoring](#observability--monitoring)
  - [Service Discovery \& Service Mesh](#service-discovery--service-mesh)
  - [Networks](#networks)
  - [File Sharing / Storage](#file-sharing--storage)
  - [Dashboards](#dashboards)
  - [Password Management](#password-management)
  - [Publishing, Writing, Blogging, Hosting](#publishing-writing-blogging-hosting)
  - [Internet of Things / Smart Home / IT Automation](#internet-of-things--smart-home--it-automation)
  - [Asset Management](#asset-management)
  - [Backups \& Syncing](#backups--syncing)
  - [Source Code Management](#source-code-management)
  - [Gateway \& Reverse Proxies](#gateway--reverse-proxies)
  - [Chat and ChatOps](#chat-and-chatops)
  - [Secret Management](#secret-management)
  - [Sharing](#sharing)
  - [Virtual Private Network (VPN)](#virtual-private-network-vpn)
  - [SSL](#ssl)
  - [Tools \& Helpers](#tools--helpers)
  - [Resources](#resources)

## Docker

- [Portainer](portainer.md) - GUI for kubernates and docker
- [Watchtower](watchtower.md) - A container-based solution for automating Docker container base image updates
- [Wait-for Script(Tools)](wait-for.md) - Wait-for script

## Automation & Orchestration

*Tools for automation, orchestration, deployment, provisioning and configuration management.*

- Ansible - Simple IT automation platform that makes your applications and systems easier to deploy.
- Salt - Automate the management and configuration of any infrastructure or application at scale.
- Chef - Automate infrastructure and applications.
- Terraform - use Infrastructure as Code to provision and manage any cloud, infrastructure, or service.
- Score - Open Source developer-centric and platform-agnostic workload specification.

## Databases

- Relational (SQL)
  - [PostgreSQL](postgresql.md) - Open source object-relational database
  - [MariaDB](mariadb.md) - One of the most popular open source relational databases
  - MySQL - Open-source relational database management system.
- Non-relational (NoSQL)
  - MongoDb - General purpose, document-based, distributed database built for modern applications.
  - [Mongo Express](mongo-express.md) - Web-based MongoDB admin interface written with Node.js, Express and Bootstrap3
  - [InfluxDB](influxdb.md) - InfluxDB is an open source time series database for recording metrics, events, and analytics.
  - Elasticsearch - Distributed, RESTful search and analytics engine capable of addressing a growing number of use cases.
  - Apache HBase - Distributed, versioned, non-relational database.
  - Rethinkdb - Open-source database for the realtime web
  - Key-Value
    - Redis - In-memory data structure store, used as a database, cache and message broker.
    - Leveldb - Fast key-value storage library.
    - Couchbase - Distributed multi-model NoSQL document-oriented database that is optimized for interactive applications.

## Wiki & Knowledge Base

- [Wiki.js](wiki-js.md) - Powerful and extensible open source Wiki software
- [OpenKM](openkm-ce.md) - Knowledge management
- Bookstack - BookStack is a free and open-source wiki software aimed for a simple, self-hosted, and easy-to-use platform.
- Answer - An open-source knowledge-based community software. You can use it quickly to build Q&A community for your products, customers, teams, and more.

## Distributed messaging

- [RabbitMQ](rabbitmq.md) - A webinar on high availability and data safety in messaging
- Kafka - Building real-time data pipelines and streaming apps.
- Activemq - Multi-Protocol messaging.

## Observability & Monitoring

- [Grafana](grafana.md) - The open source analytics & monitoring solution for every database
- [Prometheus](prometheus.md) - An open-source monitoring system
- Logs Management
  - [Seq](seq.md) - The self-hosted search, analysis, and alerting server
  - Logstash - Collect, parse, transform logs.
  - Kibana - Explore, visualize, discover data.
  - Graylog - Free and open source log management.
- Status
  - [Uptime Kuma](uptime-kuma.md) - Uptime Kuma is an easy-to-use self-hosted monitoring tool.
  - Instatus - Quick and beautiful status page.
  - StatusPal - Communicate incidents and maintenance effectively with a beautiful hosted status page.
  - Cachet - Beautiful and powerful open source status page system.

## Service Discovery & Service Mesh

- Consul - Connect and secure any service.
- Serf - Decentralized cluster membership, failure detection, and orchestration.
- Zookeeper - Centralized service for configuration, naming, providing distributed synchronization, and more.

## Networks

- [Pi-hole](pihole.md) - In addition to blocking advertisements, Pi-hole has an informative Web interface that shows stats on all the domains being queried on your network

## File Sharing / Storage

- [NextCloud](nextcloud.md) - The most popular on-premises content collaboration platform you can download
- Seafile - File hosting and sharing solution primary for teams and organizations.
- MinIO - MinIO is an object storage server, compatible with Amazon S3 cloud storage service, mainly used for storing unstructured data (such as photos, videos, log files, etc.).

## Dashboards

- [Heimdall](heimdall.md) - An elegant solution to organize all your web applications
- Dashy - Feature-rich homepage for your homelab, with easy YAML configuration.

## Password Management

- [Passbolt CE](passbolt.md) - Password management tools
- Vaultwarden - Lightweight Bitwarden server API implementation written in Rust. Unlocks paid Bitwarden features such as 2FA.
- Bitwarden Unified - Official Bitwarden deployment option (beta) targeting selfhosters by providing a resource-efficient, single Docker image with multiple database support.

## Publishing, Writing, Blogging, Hosting

- [Ghost](ghost.md) - Ghost is a free and open source blogging platform written in JavaScript and distributed under the MIT License, designed to simplify the process of online publishing for individual bloggers as well as online publications.
- WordPress - WordPress is a free and open-source content management system written in hypertext
- Overleaf - Overleaf is a collaborative cloud-based LaTeX editor used for writing, editing and publishing scientific documents.
- Answer - An open-source knowledge-based community software. You can use it quickly to build Q&A community for your products, customers, teams, and more.

## Internet of Things / Smart Home / IT Automation

- Home Assistant - Open source home automation that puts local control and privacy first. Powered by a worldwide community of tinkerers and DIY enthusiasts. Perfect to run on a Raspberry Pi or a local server.
- UpSnap - A simple wake on lan app written with SvelteKit, Go, PocketBase and nmap.

## Asset Management

- Domainmod - DomainMOD is an open source application used to manage your domains and other internet assets in a central location.
- Snipe-IT - Snipe-IT is a free, open source IT asset management system written in PHP.

## Backups & Syncing

- Duplicati - Duplicati is a backup client that securely stores encrypted, incremental, compressed remote backups of local files on cloud storage services and remote file servers.
- Duplicacy - A lock-free deduplication cloud backup tool.
- Syncthing - Syncthing is a continuous file synchronization program. It synchronizes files between two or more computers.

## Source Code Management

- Gitlab - Entire DevOps lifecycle in one application.
- Gitea - A painless self-hosted Git service.

## Gateway & Reverse Proxies

*API Gateway, Service Proxy and Service Management tools.*

- Traefik - Reverse proxy and load balancer for HTTP and TCP-based applications.
- Envoy - Cloud-native high-performance edge/middle/service proxy.
- API Umbrella - Proxy that sits in front of your APIs, API management platform.
- Gloo - Feature-rich, Kubernetes-native ingress controller, and next-generation API gateway.
- Nginx Proxy Manager - Nginx Proxy Manager is an easy way to accomplish reverse proxying hosts with SSL termination.
- Caddy - The Caddy web server is an extensible, cross-platform, open-source web server written in Go. Caddy obtains and renews TLS certificates for your sites automatically.

## Chat and ChatOps

- Rocket - Open source team communication.
- Mattermost - Messaging platform that enables secure team collaboration.
- ChatOps
  - CloudBot - Simple, fast, expandable, open-source Python IRC Bot.
  - Hubot - A customizable life embetterment robot.

## Secret Management

*Security as code, sensitive credentials and secrets need to be managed, security, maintained and rotated using automation.*

- Vault - Manage secrets and protect sensitive data.
- Sops - Simple and flexible tool for managing secrets.
- Keybase - End-to-end encrypted chat and cloud storage system.
- Git Secret - A bash-tool to store your private data inside a git repository.

## Sharing

*A collection of tools to help with sharing knowledge and telling the story.*

- Gitbook - Modern documentation format and toolchain using Git and Markdown.
- Docusaurus - Easy to maintain open source documentation websites.
- Docsify - A magical documentation site generator.
- MkDocs - Project documentation with Markdown.

## Virtual Private Network (VPN)

- OpenVPN - Flexible VPN solutions to secure your data communications, whether it's for Internet privacy.
- Pritunl - Enterprise Distributed OpenVPN and IPsec Server.
- WireGuard - WireGuard by Linuxserver.io is an extremely simple yet fast and modern VPN that utilizes state-of-the-art cryptography.
- IPSec VPN Server - Docker image to run an IPsec VPN server, with IPsec/L2TP, Cisco IPsec and IKEv2.
- Firezone - Self-hosted secure remote access gateway that supports the WireGuard protocol. It offers a Web GUI, 1-line install script, multi-factor auth (MFA), and SSO.

## SSL

*Tools for automating the management of SSL certificates.*

- Certbot - Automate using Let’s Encrypt certificates on manually-managed websites to enable HTTPS.
- Let’s Encrypt - Free, automated, and open Certificate Authority.
- Cert Manager - K8S add-on to automate the management and issuance of TLS certificates from various issuing sources.

## Tools & Helpers

- IT-Tools - Collection of handy online tools for developers, with great UX.
- Network-Multitool - Multi-arch multitool for container network troubleshooting.
- Monkeytype - The most customizable typing website with a minimalistic design and a ton of features. Test yourself in various modes, track your progress and improve your speed.

## Resources

- [Awesome Docker Compose Examples](https://github.com/Haxxnet/Compose-Examples/)
- [Awesome DevOps](https://github.com/wmariuss/awesome-devops)
