# 🔵 ZabbixNetworkMonitoring
### Mise en place d'une Infrastructure de Supervision Centralisée du réseau et du parc informatique avec Zabbix

> **Stage L2 — Réseaux, Systèmes & Sécurité** | SUP de CO Dakar — School of Engineering and Technology | 2025–2026
> **Présenté par :** Mamadou Aliou Barry | **Maître de stage :** M. Momar Khouma (Responsable Informatique)

---

## 🎯 Contexte et objectif

La DSI de SUP DE CO Dakar ne disposait d'aucun outil de monitoring automatisé. La détection des pannes reposait uniquement sur les signalements manuels des utilisateurs, entraînant des délais d'intervention non maîtrisés et une absence totale de métriques historiques.

Ce projet déploie **Zabbix 6.0.48 LTS** pour surveiller en temps réel :
- Les équipements **Cisco** (Routeur R4 + Switch SW-1) via **SNMPv2c**
- Les hôtes **Windows 10** et **Linux Server** via **Zabbix Agent 2**
- Avec alertes automatiques en temps réel via **Discord Webhook**

L'ensemble est simulé sous **EVE-NG** avant déploiement en production.

---

## 🏗️ Topologie réseau

```
                        ┌─────────────────────┐
                        │     Routeur R4       │
                        │  Eth0/0 → WAN/EVE-NG │
                        │  Eth0/1.10 → 192.168.10.1 (VLAN 10 Finance)
                        │  Eth0/1.20 → 192.168.20.1 (VLAN 20 IT)
                        │  SNMPv2c ✅           │
                        └────────┬────────────┘
                                 │ Trunk 802.1Q (VLAN 10 + 20)
                        ┌────────▼────────────┐
                        │     Switch SW-1      │
                        │  SVI VLAN20 → 192.168.20.254
                        │  Gi0/0 → Trunk R4    │
                        │  SNMPv2c ✅           │
                        └──┬──────┬──────┬────┘
                           │      │      │
              ┌────────────┘      │      └──────────────┐
              │                   │                      │
   ┌──────────▼───┐    ┌──────────▼───┐    ┌───────────▼──┐
   │ Zabbix Server│    │ VM Windows   │    │ VM Linux     │
   │ 192.168.20.10│    │ Finance      │    │ Server       │
   │ VLAN 20 IT   │    │ 192.168.10.13│    │ 192.168.20.14│
   │ Ubuntu 22.04 │    │ VLAN 10      │    │ VLAN 20      │
   └──────────────┘    │ Agent ZBX ✅ │    │ Agent ZBX ✅ │
                        └──────────────┘    └──────────────┘
```

---

## ✅ Résultats obtenus

| Indicateur | Résultat |
|---|---|
| Hôtes supervisés | 5 (R4, SW-1, Windows Finance, Linux Server, Zabbix auto) |
| Visibilité du parc | **100%** — tous les indicateurs SNMP et ZBX au vert |
| Délai de détection | **< 30 secondes** (16 s CPU, ~78 s coupure trunk) |
| Éléments collectés | **410 items** actifs en temps réel |
| Triggers configurés | **224** (220 en état OK) |
| Alertes Discord | Opérationnelles — Zabbix Bot notifie en temps réel |

---

## 🛠️ Stack technologique

| Technologie | Version | Usage |
|---|---|---|
| **EVE-NG** | Community | Émulation de la topologie réseau complète |
| **Cisco IOS — R4** | 15.x | Router-on-a-Stick 802.1Q, SNMPv2c, NAT |
| **Cisco IOS — SW-1** | 15.x | VLANs 10 & 20, Trunk 802.1Q, SNMPv2c |
| **Zabbix Server** | 6.0.48 LTS | Supervision centralisée, dashboards, triggers |
| **Ubuntu Server** | 22.04 LTS | OS du serveur Zabbix |
| **MySQL** | 8.0 | Base de données Zabbix |
| **Zabbix Agent 2** | 7.4.13 | Supervision Windows 10 & Linux Server |
| **Discord Webhook** | — | Alertes en temps réel (Zabbix Bot) |
| **Trello** | — | Gestion de projet (To Do / In Progress / Done) |

---

## 📁 Structure du dépôt

```
ZabbixNetworkMonitoring/
├── README.md              ← Vous êtes ici
├── configs/               ← Configurations Cisco IOS (R4 & SW-1)
├── screenshots/           ← Captures d'écran (EVE-NG, Zabbix, Discord)
└── rapport/               ← Rapport final de stage (.pdf)
```

---

## 🔑 Problème majeur résolu — Blocage SNMP via NAT

L'interface `Ethernet0/0` de R4 étant configurée avec `ip nat outside`, les réponses SNMP partaient avec l'IP traduite par le NAT, rendant la collecte Zabbix impossible.

**Solution :** configurer Zabbix pour joindre R4 via `Ethernet0/1.10` (`192.168.10.1`) — interface `ip nat inside`, accessible depuis le VLAN 20 via le routage inter-VLAN de R4 lui-même.

---

## 🧪 Scénarios de simulation validés

| Scénario | Délai de détection | Alerte Discord |
|---|---|---|
| Charge CPU > 85% sur Windows Finance | **16 secondes** | ✅ Reçue |
| Coupure interface Trunk Gi0/0 sur SW-1 | **~78 secondes** | ✅ Reçue |
| Arrêt simultané Windows + Linux Agent | < 3 minutes | ✅ Reçue |

---

## 📚 Guide d'exploitation

Voir [guide_exploitation.md](./rapport/guide_exploitation.md) pour les procédures d'administration courantes de la plateforme Zabbix.

---

*Stage L2 RSS — SUP de CO Dakar (SET) | Année académique 2025–2026*
