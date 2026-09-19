#!/bin/bash
# =============================================================
# check_snmp.sh — Test de collecte SNMP depuis le serveur Zabbix
# Projet : ZabbixNetworkMonitoring | SUP de CO Dakar (SET)
# Auteur : Mamadou Aliou Barry | Stage L2 RSS 2026
# =============================================================

# --- Couleurs ---
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# --- Configuration ---
COMMUNITY="public"
SNMP_VERSION="2c"

# Équipements à tester
HOSTS=(
    "192.168.10.1:Routeur R4 (Eth0/1.10)"
    "192.168.10.2:Switch SW-1 (SVI VLAN10)"
)

# OIDs à vérifier
OID_SYSNAME="1.3.6.1.2.1.1.5.0"        # sysName
OID_SYSDESC="1.3.6.1.2.1.1.1.0"        # sysDescr
OID_UPTIME="1.3.6.1.2.1.1.3.0"         # sysUpTime

echo ""
echo "============================================================"
echo "   🔵 TEST SNMP — Infrastructure de Supervision Zabbix"
echo "   Projet ZabbixNetworkMonitoring | SUP de CO Dakar"
echo "============================================================"
echo ""

for entry in "${HOSTS[@]}"; do
    IP="${entry%%:*}"
    NAME="${entry##*:}"

    echo -e "${YELLOW}▶ Test de l'équipement : $NAME ($IP)${NC}"
    echo "  Community : $COMMUNITY | Version : SNMPv$SNMP_VERSION"
    echo "  ---"

    # Test sysName
    SYSNAME=$(snmpget -v$SNMP_VERSION -c $COMMUNITY -t 3 -r 1 $IP $OID_SYSNAME 2>&1)
    if echo "$SYSNAME" | grep -q "STRING"; then
        echo -e "  ${GREEN}✅ sysName     : $(echo $SYSNAME | awk -F': ' '{print $2}')${NC}"
    else
        echo -e "  ${RED}❌ sysName     : ECHEC — Vérifier SNMP ou IP${NC}"
    fi

    # Test sysDescr
    SYSDESC=$(snmpget -v$SNMP_VERSION -c $COMMUNITY -t 3 -r 1 $IP $OID_SYSDESC 2>&1)
    if echo "$SYSDESC" | grep -q "STRING"; then
        echo -e "  ${GREEN}✅ sysDescr    : $(echo $SYSDESC | awk -F'"' '{print $2}' | cut -c1-60)...${NC}"
    else
        echo -e "  ${RED}❌ sysDescr    : ECHEC${NC}"
    fi

    # Test uptime
    UPTIME=$(snmpget -v$SNMP_VERSION -c $COMMUNITY -t 3 -r 1 $IP $OID_UPTIME 2>&1)
    if echo "$UPTIME" | grep -q "Timeticks"; then
        echo -e "  ${GREEN}✅ sysUpTime   : $(echo $UPTIME | awk -F'(' '{print $2}' | awk -F')' '{print $2}')${NC}"
    else
        echo -e "  ${RED}❌ sysUpTime   : ECHEC${NC}"
    fi

    echo ""
done

echo "============================================================"
echo "   📋 Résumé : Pour un test complet, lancer snmpwalk :"
echo "   snmpwalk -v2c -c public 192.168.10.1 | head -30"
echo "   snmpwalk -v2c -c public 192.168.10.2 | head -30"
echo "============================================================"
echo ""
