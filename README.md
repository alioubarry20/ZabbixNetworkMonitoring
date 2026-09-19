# 🔵 ZabbixNetworkMonitoring
## Infrastructure de Supervision Centralisée — EVE-NG + Cisco + Zabbix

> **Stage L2 Réseaux, Systèmes & Sécurité** | SUP de CO Dakar — School of Engineering and Technology | 2026
> **Auteur :** Mamadou Aliou Barry | **Maître de stage :** Mr Momar Khouma Ndiaye

---

## 🎯 Objectif du projet

Mise en place d'une **infrastructure de supervision réseau centralisée** permettant au service informatique de Sup de Co Dakar de passer d'une gestion **réactive** à une gestion **proactive** des équipements. Le projet déploie **Zabbix 6.x** pour surveiller en temps réel les équipements Cisco (via **SNMPv2c**) et les hôtes Windows/Linux (via **Zabbix Agent**), le tout simulé sous **EVE-NG**.

---

## 🏗️ Architecture en un coup d'œil

```
  ┌─────────────────────────────────────────────────────────┐
  │                    EVE-NG (Hyperviseur)                  │
  │                                                          │
  │  VLAN 10 – Administration (192.168.10.0/24)              │
  │  ┌──────────────┐   ┌─────────────────────┐             │
  │  │  Zabbix      │   │   PC-Admin           │             │
  │  │  Server      │   │   192.168.10.10      │             │
  │  │  .50/24      │   └──────────────────────┘             │
  │  └──────┬───────┘           │                            │
  │         │ SNMP + Agent      │                            │
  │  ┌──────▼───────────────────▼──────────────────────┐    │
  │  │          Switch SW-1 (Cisco)                      │    │
  │  │          192.168.10.2 | SNMPv2c ✅               │    │
  │  │          Trunk 802.1Q (VLAN 10 + 20)              │    │
  │  └──────────────────────┬───────────────────────────┘    │
  │                         │                                 │
  │  ┌──────────────────────▼───────────────────────────┐    │
  │  │          Routeur R4 (Cisco)                       │    │
  │  │          Eth0/1.10 → 192.168.10.1 (VLAN 10)      │    │
  │  │          Eth0/1.20 → 192.168.20.1 (VLAN 20)      │    │
  │  │          Eth0/0    → NAT Outside → Internet       │    │
  │  │          SNMPv2c ✅                               │    │
  │  └──────────────────────────────────────────────────┘    │
  │                                                           │
  │  VLAN 20 – Informatique (192.168.20.0/24)                │
  │  ┌──────────────┐   ┌──────────────────────┐            │
  │  │  PC-Info-1   │   │  PC-Info-2           │            │
  │  │  .20.10/24   │   │  Zabbix Agent ✅     │            │
  │  └──────────────┘   └──────────────────────┘            │
  └─────────────────────────────────────────────────────────┘
```

📄 **Documentation complète :** [ARCHITECTURE.md](./ARCHITECTURE.md)

---

## ✅ Résultats obtenus

| Indicateur | Résultat |
|---|---|
| Équipements supervisés | R4 (SNMP), SW-1 (SNMP), Hôtes Windows/Linux (Agent) |
| Visibilité du parc | **100%** — toutes les pastilles au vert |
| Délai de détection d'incident | **< 30 secondes** |
| Métriques collectées | CPU, RAM, bande passante, disponibilité interfaces |
| Dashboards configurés | Tableau de bord global + graphiques par équipement |
| Alertes (Triggers) | 5 triggers configurés (Disaster / High / Warning) |

---

## 🛠️ Stack technologique

| Technologie | Version | Usage |
|---|---|---|
| **EVE-NG** | Community | Émulation réseau (R4, SW-1, hôtes) |
| **Cisco IOS** | 15.x | Routage inter-VLAN, SNMP, NAT, ACL |
| **Zabbix Server** | 6.x | Serveur de supervision centralisé |
| **Ubuntu Server** | 22.04 LTS | OS du serveur Zabbix |
| **Zabbix Agent 2** | 6.x | Supervision des hôtes Windows/Linux |
| **SNMPv2c** | — | Collecte des métriques Cisco |
| **MobaXterm / PuTTY** | — | Accès CLI aux équipements Cisco |
| **Trello** | — | Gestion de projet |

---

## 📁 Structure du dépôt

```
ZabbixNetworkMonitoring/
├── README.md                     ← Vous êtes ici
├── ARCHITECTURE.md               ← Schémas + configs détaillées
├── GIT_GUIDE.md                  ← Guide Git/GitHub du projet
├── .gitignore
├── configs/cisco/                ← Configurations running-config R4 & SW-1
├── zabbix/templates/             ← Templates Zabbix exportés (.xml)
├── zabbix/dashboards/            ← Dashboards exportés (.json)
├── docs/captures/                ← Captures d'écran du projet
└── scripts/                      ← Scripts utilitaires (check_snmp.sh)
```

---

## 🚀 Démarrage rapide

### Prérequis
- EVE-NG Community installé sur un serveur Linux
- Images Cisco IOS (`.bin`) pour Dynamips importées dans EVE-NG
- Ubuntu Server 22.04 pour le nœud Zabbix

### 1. Cloner le dépôt
```bash
git clone https://github.com/alioubarry20/ZabbixNetworkMonitoring.git
cd ZabbixNetworkMonitoring
```

### 2. Importer les configurations Cisco
```bash
# Copier les configs sur les équipements via console EVE-NG
# Voir configs/cisco/R4_running-config.txt et SW-1_running-config.txt
```

### 3. Importer le template Zabbix
```
Administration → Templates → Import → zabbix/templates/zbx_template_cisco_ios.xml
```

### 4. Tester la collecte SNMP
```bash
# Depuis le serveur Zabbix (Linux)
snmpwalk -v2c -c public 192.168.10.1
snmpwalk -v2c -c public 192.168.10.2
```

---

## 📸 Captures d'écran

| # | Description | Fichier |
|---|---|---|
| 01 | Topologie EVE-NG complète | `docs/captures/01_eve-ng_topologie.png` |
| 02 | Config SNMP R4 (CLI) | `docs/captures/02_config_snmp_r4.png` |
| 03 | Dashboard Zabbix global | `docs/captures/03_zabbix_dashboard_global.png` |
| 04 | Hôte R4 — SNMP vert ✅ | `docs/captures/04_zabbix_host_r4_snmp_ok.png` |
| 05 | Graphique bande passante | `docs/captures/05_zabbix_graph_bandwidth_r4.png` |
| 06 | Trigger — Test injoignabilité | `docs/captures/06_zabbix_trigger_unreachable.png` |
| 07 | Agent Zabbix Windows | `docs/captures/07_zabbix_agent_windows.png` |
| 08 | MobaXterm — CLI Cisco réel | `docs/captures/08_mobaxterm_cisco_cli.png` |

> 📌 **Pour ajouter tes captures :** glisse tes fichiers `.png` dans `docs/captures/` en respectant la numérotation, puis `git add . && git commit -m "docs: ajout captures écran projet"`

---

## 📚 Documentation

- [📐 Architecture détaillée](./ARCHITECTURE.md) — Schémas Mermaid, plan IP, configs Cisco, résolution NAT
- [📘 Guide Git/GitHub](./GIT_GUIDE.md) — Workflow, branches, commits conventionnels
- [🔧 Guide d'exploitation Zabbix](./docs/guide_exploitation.md) *(à venir)*

---

## 🔑 Problème majeur résolu

**SNMP bloqué par le NAT sur Ethernet0/0 de R4** → Résolu en configurant Zabbix pour joindre R4 via l'interface interne `Ethernet0/1.10` (`192.168.10.1`, `ip nat inside`) plutôt que l'interface WAN NAT outside. Voir [Section 7 de ARCHITECTURE.md](./ARCHITECTURE.md#7-résolution-du-problème-nat--snmp).

---

*Stage L2 — Réseaux, Systèmes & Sécurité | SUP de CO Dakar (SET) | Juillet – Septembre 2026*
