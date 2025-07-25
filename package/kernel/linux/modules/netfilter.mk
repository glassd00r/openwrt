
#
# Copyright (C) 2006-2023 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

NF_MENU:=Netfilter Extensions
NF_KMOD:=1
include $(INCLUDE_DIR)/netfilter.mk


define KernelPackage/nf-reject
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter IPv4 reject support
  KCONFIG:= \
	CONFIG_NETFILTER=y \
	CONFIG_NETFILTER_ADVANCED=y \
	$(KCONFIG_NF_REJECT)
  FILES:=$(foreach mod,$(NF_REJECT-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NF_REJECT-m)))
endef

$(eval $(call KernelPackage,nf-reject))


define KernelPackage/nf-reject6
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter IPv6 reject support
  KCONFIG:= \
	CONFIG_NETFILTER=y \
	CONFIG_NETFILTER_ADVANCED=y \
	$(KCONFIG_NF_REJECT6)
  DEPENDS:=@IPV6
  FILES:=$(foreach mod,$(NF_REJECT6-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NF_REJECT6-m)))
endef

$(eval $(call KernelPackage,nf-reject6))

define KernelPackage/nf-conncount
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter conncount support
  KCONFIG:=$(KCONFIG_NF_CONNCOUNT)
  HIDDEN:=1
  DEPENDS:=+kmod-nf-conntrack
  FILES:=$(foreach mod,$(NF_CONNCOUNT-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NF_CONNCOUNT-m)))
endef

$(eval $(call KernelPackage,nf-conncount))

define KernelPackage/nf-ipt
  SUBMENU:=$(NF_MENU)
  TITLE:=Iptables core
  KCONFIG:=$(KCONFIG_NF_IPT)
  FILES:=$(foreach mod,$(NF_IPT-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NF_IPT-m)))
endef

$(eval $(call KernelPackage,nf-ipt))


define KernelPackage/nf-ipt6
  SUBMENU:=$(NF_MENU)
  TITLE:=Ip6tables core
  KCONFIG:=$(KCONFIG_NF_IPT6)
  FILES:=$(foreach mod,$(NF_IPT6-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NF_IPT6-m)))
  DEPENDS:=+kmod-nf-ipt +kmod-nf-log6
endef

$(eval $(call KernelPackage,nf-ipt6))



define KernelPackage/ipt-core
  SUBMENU:=$(NF_MENU)
  TITLE:=Iptables core
  KCONFIG:=$(KCONFIG_IPT_CORE)
  FILES:=$(foreach mod,$(IPT_CORE-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(IPT_CORE-m)))
  DEPENDS:=+kmod-nf-reject +kmod-nf-ipt +kmod-nf-log
endef

define KernelPackage/ipt-core/description
 Netfilter core kernel modules
 Includes:
 - comment
 - limit
 - LOG
 - mac
 - multiport
 - REJECT
 - TCPMSS
endef

$(eval $(call KernelPackage,ipt-core))


define KernelPackage/nf-conntrack
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter connection tracking
  KCONFIG:= \
        CONFIG_NETFILTER=y \
        CONFIG_NETFILTER_ADVANCED=y \
        CONFIG_NF_CONNTRACK_MARK=y \
        CONFIG_NF_CONNTRACK_ZONES=y \
	$(KCONFIG_NF_CONNTRACK)
  FILES:=$(foreach mod,$(NF_CONNTRACK-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NF_CONNTRACK-m)))
endef

define KernelPackage/nf-conntrack/install
	$(INSTALL_DIR) $(1)/etc/sysctl.d
	$(INSTALL_DATA) ./files/sysctl-nf-conntrack.conf $(1)/etc/sysctl.d/11-nf-conntrack.conf
endef

$(eval $(call KernelPackage,nf-conntrack))


define KernelPackage/nf-conntrack6
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter IPv6 connection tracking
  KCONFIG:=$(KCONFIG_NF_CONNTRACK6)
  DEPENDS:=@IPV6 +kmod-nf-conntrack
  FILES:=$(foreach mod,$(NF_CONNTRACK6-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NF_CONNTRACK6-m)))
endef

$(eval $(call KernelPackage,nf-conntrack6))


define KernelPackage/nf-dup-inet
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter nf_tables dup in ip/ip6/inet family support
  HIDDEN:=1
  DEPENDS:=+kmod-nf-conntrack +IPV6:kmod-nf-conntrack6
  KCONFIG:= \
	CONFIG_NF_DUP_IPV4 \
	CONFIG_NF_DUP_IPV6
  FILES:= \
	$(LINUX_DIR)/net/ipv4/netfilter/nf_dup_ipv4.ko \
	$(LINUX_DIR)/net/ipv6/netfilter/nf_dup_ipv6.ko
endef

$(eval $(call KernelPackage,nf-dup-inet))


define KernelPackage/nf-log
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter Logging
  KCONFIG:=$(KCONFIG_NF_LOG)
  FILES:=$(foreach mod,$(NF_LOG-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NF_LOG-m)))
endef

$(eval $(call KernelPackage,nf-log))


define KernelPackage/nf-log6
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter IPV6 Logging
  KCONFIG:=$(KCONFIG_NF_LOG6)
  DEPENDS:=@IPV6 +kmod-nf-log
  FILES:=$(foreach mod,$(NF_LOG6-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NF_LOG6-m)))
endef

$(eval $(call KernelPackage,nf-log6))


define KernelPackage/nf-nat
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter NAT
  KCONFIG:=$(KCONFIG_NF_NAT)
  DEPENDS:=+kmod-nf-conntrack
  FILES:=$(foreach mod,$(NF_NAT-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NF_NAT-m)))
endef

$(eval $(call KernelPackage,nf-nat))


define KernelPackage/nf-nat6
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter IPV6-NAT
  KCONFIG:=$(KCONFIG_NF_NAT6)
  DEPENDS:=@IPV6 +kmod-nf-conntrack6 +kmod-nf-nat
  FILES:=$(foreach mod,$(NF_NAT6-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NF_NAT6-m)))
endef

$(eval $(call KernelPackage,nf-nat6))


define KernelPackage/nf-flow
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter flowtable support
  KCONFIG:= \
	CONFIG_NETFILTER_INGRESS=y \
	CONFIG_NF_FLOW_TABLE \
	CONFIG_NF_FLOW_TABLE_HW
  DEPENDS:=+kmod-nf-conntrack
  FILES:= $(LINUX_DIR)/net/netfilter/nf_flow_table.ko
  AUTOLOAD:=$(call AutoProbe,nf_flow_table nf_flow_table_hw)
endef

$(eval $(call KernelPackage,nf-flow))


define KernelPackage/nf-flow-netlink
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter flowtable netlink support
  KCONFIG:= \
	CONFIG_NF_FLOW_TABLE_NETLINK
  DEPENDS:=+kmod-nf-flow +kmod-nfnetlink
  FILES:= \
	$(LINUX_DIR)/net/netfilter/nf_flow_table_netlink.ko
  AUTOLOAD:=$(call AutoProbe,nf_flow_table_netlink)
endef

$(eval $(call KernelPackage,nf-flow-netlink))


define KernelPackage/nf-socket
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter socket lookup support
  KCONFIG:= $(KCONFIG_NF_SOCKET)
  FILES:=$(foreach mod,$(NF_SOCKET-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NF_SOCKET-m)))
endef

$(eval $(call KernelPackage,nf-socket))


define KernelPackage/nf-tproxy
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter tproxy support
  KCONFIG:= $(KCONFIG_NF_TPROXY)
  FILES:=$(foreach mod,$(NF_TPROXY-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NF_TPROXY-m)))
endef

$(eval $(call KernelPackage,nf-tproxy))


define AddDepends/ipt
  SUBMENU:=$(NF_MENU)
  DEPENDS+= +kmod-ipt-core $(1)
endef


define KernelPackage/ipt-conntrack
  TITLE:=Basic connection tracking modules
  KCONFIG:=$(KCONFIG_IPT_CONNTRACK)
  FILES:=$(foreach mod,$(IPT_CONNTRACK-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(IPT_CONNTRACK-m)))
  $(call AddDepends/ipt,+kmod-nf-conntrack)
endef

define KernelPackage/ipt-conntrack/description
 Netfilter (IPv4) kernel modules for connection tracking
 Includes:
 - conntrack
 - defrag
 - iptables_raw
 - NOTRACK
 - state
endef

$(eval $(call KernelPackage,ipt-conntrack))


define KernelPackage/ipt-conntrack-extra
  TITLE:=Extra connection tracking modules
  DEPENDS:=+kmod-nf-conncount
  KCONFIG:=$(KCONFIG_IPT_CONNTRACK_EXTRA)
  FILES:=$(foreach mod,$(IPT_CONNTRACK_EXTRA-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(IPT_CONNTRACK_EXTRA-m)))
  $(call AddDepends/ipt,+kmod-ipt-conntrack)
endef

define KernelPackage/ipt-conntrack-extra/description
 Netfilter (IPv4) extra kernel modules for connection tracking
 Includes:
 - connbytes
 - connmark/CONNMARK
 - conntrack
 - helper
 - recent
endef

$(eval $(call KernelPackage,ipt-conntrack-extra))

define KernelPackage/ipt-conntrack-label
  TITLE:=Module for handling connection tracking labels
  KCONFIG:=$(KCONFIG_IPT_CONNTRACK_LABEL)
  FILES:=$(foreach mod,$(IPT_CONNTRACK_LABEL-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(IPT_CONNTRACK_LABEL-m)))
  $(call AddDepends/ipt,+kmod-ipt-conntrack)
endef

define KernelPackage/ipt-conntrack-label/description
 Netfilter (IPv4) module for handling connection tracking labels
 Includes:
 - connlabel
endef

$(eval $(call KernelPackage,ipt-conntrack-label))

define KernelPackage/ipt-filter
  TITLE:=Modules for packet content inspection
  KCONFIG:=$(KCONFIG_IPT_FILTER)
  FILES:=$(foreach mod,$(IPT_FILTER-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(IPT_FILTER-m)))
  $(call AddDepends/ipt,+kmod-lib-textsearch +kmod-ipt-conntrack)
endef

define KernelPackage/ipt-filter/description
 Netfilter (IPv4) kernel modules for packet content inspection
 Includes:
 - string
 - bpf
endef

$(eval $(call KernelPackage,ipt-filter))


define KernelPackage/ipt-offload
  TITLE:=Netfilter routing/NAT offload support
  KCONFIG:=$(KCONFIG_IPT_FLOW)
  FILES:=$(foreach mod,$(IPT_FLOW-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(IPT_FLOW-m)))
  $(call AddDepends/ipt,+kmod-nf-flow)
endef

$(eval $(call KernelPackage,ipt-offload))


define KernelPackage/ipt-ipopt
  TITLE:=Modules for matching/changing IP packet options
  KCONFIG:=$(KCONFIG_IPT_IPOPT)
  FILES:=$(foreach mod,$(IPT_IPOPT-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(IPT_IPOPT-m)))
  $(call AddDepends/ipt)
endef

define KernelPackage/ipt-ipopt/description
 Netfilter (IPv4) modules for matching/changing IP packet options
 Includes:
 - CLASSIFY
 - dscp/DSCP
 - ecn/ECN
 - hl/HL
 - length
 - mark/MARK
 - statistic
 - tcpmss
 - time
 - ttl/TTL
 - unclean
endef

$(eval $(call KernelPackage,ipt-ipopt))


define KernelPackage/ipt-ipsec
  TITLE:=Modules for matching IPSec packets
  KCONFIG:=$(KCONFIG_IPT_IPSEC)
  FILES:=$(foreach mod,$(IPT_IPSEC-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(IPT_IPSEC-m)))
  $(call AddDepends/ipt)
endef

define KernelPackage/ipt-ipsec/description
 Netfilter (IPv4) modules for matching IPSec packets
 Includes:
 - ah
 - esp
 - policy
endef

$(eval $(call KernelPackage,ipt-ipsec))

IPSET_MODULES:= \
	ipset/ip_set \
	ipset/ip_set_bitmap_ip \
	ipset/ip_set_bitmap_ipmac \
	ipset/ip_set_bitmap_port \
	ipset/ip_set_hash_ip \
	ipset/ip_set_hash_ipmac \
	ipset/ip_set_hash_ipmark \
	ipset/ip_set_hash_ipport \
	ipset/ip_set_hash_ipportip \
	ipset/ip_set_hash_ipportnet \
	ipset/ip_set_hash_mac \
	ipset/ip_set_hash_netportnet \
	ipset/ip_set_hash_net \
	ipset/ip_set_hash_netnet \
	ipset/ip_set_hash_netport \
	ipset/ip_set_hash_netiface \
	ipset/ip_set_list_set \
	xt_set

define KernelPackage/ipt-ipset
  SUBMENU:=Netfilter Extensions
  TITLE:=IPset netfilter modules
  DEPENDS+= +kmod-ipt-core +kmod-nfnetlink
  KCONFIG:= \
	CONFIG_IP_SET \
	CONFIG_IP_SET_MAX=256 \
	CONFIG_NETFILTER_XT_SET \
	CONFIG_IP_SET_BITMAP_IP \
	CONFIG_IP_SET_BITMAP_IPMAC \
	CONFIG_IP_SET_BITMAP_PORT \
	CONFIG_IP_SET_HASH_IP \
	CONFIG_IP_SET_HASH_IPMAC \
	CONFIG_IP_SET_HASH_IPMARK \
	CONFIG_IP_SET_HASH_IPPORT \
	CONFIG_IP_SET_HASH_IPPORTIP \
	CONFIG_IP_SET_HASH_IPPORTNET \
	CONFIG_IP_SET_HASH_MAC \
	CONFIG_IP_SET_HASH_NET \
	CONFIG_IP_SET_HASH_NETNET \
	CONFIG_IP_SET_HASH_NETIFACE \
	CONFIG_IP_SET_HASH_NETPORT \
	CONFIG_IP_SET_HASH_NETPORTNET \
	CONFIG_IP_SET_LIST_SET \
	CONFIG_NET_EMATCH_IPSET=n
  FILES:=$(foreach mod,$(IPSET_MODULES),$(LINUX_DIR)/net/netfilter/$(mod).ko)
  AUTOLOAD:=$(call AutoLoad,49,$(notdir $(IPSET_MODULES)))
endef
$(eval $(call KernelPackage,ipt-ipset))


IPVS_MODULES:= \
	ipvs/ip_vs \
	ipvs/ip_vs_lc \
	ipvs/ip_vs_wlc \
	ipvs/ip_vs_rr \
	ipvs/ip_vs_wrr \
	ipvs/ip_vs_lblc \
	ipvs/ip_vs_lblcr \
	ipvs/ip_vs_dh \
	ipvs/ip_vs_sh \
	ipvs/ip_vs_fo \
	ipvs/ip_vs_ovf \
	ipvs/ip_vs_nq \
	ipvs/ip_vs_sed \
	xt_ipvs

define KernelPackage/nf-ipvs
  SUBMENU:=Netfilter Extensions
  TITLE:=IP Virtual Server modules
  DEPENDS:=@IPV6 +kmod-lib-crc32c +kmod-ipt-conntrack +kmod-nf-conntrack
  KCONFIG:= \
	CONFIG_IP_VS \
	CONFIG_IP_VS_IPV6=y \
	CONFIG_IP_VS_DEBUG=n \
	CONFIG_IP_VS_PROTO_TCP=y \
	CONFIG_IP_VS_PROTO_UDP=y \
	CONFIG_IP_VS_PROTO_AH_ESP=y \
	CONFIG_IP_VS_PROTO_ESP=y \
	CONFIG_IP_VS_PROTO_AH=y \
	CONFIG_IP_VS_PROTO_SCTP=y \
	CONFIG_IP_VS_TAB_BITS=12 \
	CONFIG_IP_VS_RR \
	CONFIG_IP_VS_WRR \
	CONFIG_IP_VS_LC \
	CONFIG_IP_VS_WLC \
	CONFIG_IP_VS_FO \
	CONFIG_IP_VS_OVF \
	CONFIG_IP_VS_LBLC \
	CONFIG_IP_VS_LBLCR \
	CONFIG_IP_VS_DH \
	CONFIG_IP_VS_SH \
	CONFIG_IP_VS_SED \
	CONFIG_IP_VS_NQ \
	CONFIG_IP_VS_SH_TAB_BITS=8 \
	CONFIG_IP_VS_NFCT=y \
	CONFIG_NETFILTER_XT_MATCH_IPVS
  FILES:=$(foreach mod,$(IPVS_MODULES),$(LINUX_DIR)/net/netfilter/$(mod).ko)
  $(call AddDepends/ipt,+kmod-ipt-conntrack,+kmod-nf-conntrack)
endef

define KernelPackage/nf-ipvs/description
 IPVS (IP Virtual Server) implements transport-layer load balancing inside
 the Linux kernel so called Layer-4 switching.
endef

$(eval $(call KernelPackage,nf-ipvs))


define KernelPackage/nf-ipvs-ftp
  SUBMENU:=$(NF_MENU)
  TITLE:=Virtual Server FTP protocol support
  KCONFIG:=CONFIG_IP_VS_FTP
  DEPENDS:=kmod-nf-ipvs +kmod-nf-nat +kmod-nf-nathelper
  FILES:=$(LINUX_DIR)/net/netfilter/ipvs/ip_vs_ftp.ko
endef

define KernelPackage/nf-ipvs-ftp/description
  In the virtual server via Network Address Translation,
  the IP address and port number of real servers cannot be sent to
  clients in ftp connections directly, so FTP protocol helper is
  required for tracking the connection and mangling it back to that of
  virtual service.
endef

$(eval $(call KernelPackage,nf-ipvs-ftp))


define KernelPackage/nf-ipvs-sip
  SUBMENU:=$(NF_MENU)
  TITLE:=Virtual Server SIP protocol support
  KCONFIG:=CONFIG_IP_VS_PE_SIP
  DEPENDS:=kmod-nf-ipvs +kmod-nf-nathelper-extra
  FILES:=$(LINUX_DIR)/net/netfilter/ipvs/ip_vs_pe_sip.ko
endef

define KernelPackage/nf-ipvs-sip/description
  Allow persistence based on the SIP Call-ID
endef

$(eval $(call KernelPackage,nf-ipvs-sip))


define KernelPackage/ipt-nat
  TITLE:=Basic NAT targets
  KCONFIG:=$(KCONFIG_IPT_NAT)
  FILES:=$(foreach mod,$(IPT_NAT-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(IPT_NAT-m)))
  $(call AddDepends/ipt,+kmod-nf-nat)
endef

define KernelPackage/ipt-nat/description
 Netfilter (IPv4) kernel modules for basic NAT targets
 Includes:
 - MASQUERADE
endef

$(eval $(call KernelPackage,ipt-nat))


define KernelPackage/ipt-raw
  TITLE:=Netfilter IPv4 raw table support
  KCONFIG:=CONFIG_IP_NF_RAW
  FILES:=$(LINUX_DIR)/net/ipv4/netfilter/iptable_raw.ko
  AUTOLOAD:=$(call AutoProbe,iptable_raw)
  $(call AddDepends/ipt)
endef

$(eval $(call KernelPackage,ipt-raw))


define KernelPackage/ipt-raw6
  TITLE:=Netfilter IPv6 raw table support
  DEPENDS:=@IPV6
  KCONFIG:=CONFIG_IP6_NF_RAW
  FILES:=$(LINUX_DIR)/net/ipv6/netfilter/ip6table_raw.ko
  AUTOLOAD:=$(call AutoProbe,ip6table_raw)
  $(call AddDepends/ipt,+kmod-ip6tables)
endef

$(eval $(call KernelPackage,ipt-raw6))


define KernelPackage/ipt-nat6
  TITLE:=IPv6 NAT targets
  DEPENDS:=@IPV6
  KCONFIG:=$(KCONFIG_IPT_NAT6)
  FILES:=$(foreach mod,$(IPT_NAT6-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoLoad,43,$(notdir $(IPT_NAT6-m)))
  $(call AddDepends/ipt,+kmod-nf-nat6)
  $(call AddDepends/ipt,+kmod-ipt-conntrack)
  $(call AddDepends/ipt,+kmod-ipt-nat)
  $(call AddDepends/ipt,+kmod-ip6tables)
endef

define KernelPackage/ipt-nat6/description
 Netfilter (IPv6) kernel modules for NAT targets
endef

$(eval $(call KernelPackage,ipt-nat6))


define KernelPackage/ipt-nat-extra
  TITLE:=Extra NAT targets
  KCONFIG:=$(KCONFIG_IPT_NAT_EXTRA)
  FILES:=$(foreach mod,$(IPT_NAT_EXTRA-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(IPT_NAT_EXTRA-m)))
  $(call AddDepends/ipt,+kmod-ipt-nat)
endef

define KernelPackage/ipt-nat-extra/description
 Netfilter (IPv4) kernel modules for extra NAT targets
 Includes:
 - NETMAP
 - REDIRECT
endef

$(eval $(call KernelPackage,ipt-nat-extra))


define KernelPackage/nf-nathelper
  SUBMENU:=$(NF_MENU)
  TITLE:=Basic Conntrack and NAT helpers
  KCONFIG:=$(KCONFIG_NF_NATHELPER)
  FILES:=$(foreach mod,$(NF_NATHELPER-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NF_NATHELPER-m)))
  DEPENDS:=+kmod-nf-nat
endef

define KernelPackage/nf-nathelper/description
 Default Netfilter (IPv4) Conntrack and NAT helpers
 Includes:
 - ftp
endef

$(eval $(call KernelPackage,nf-nathelper))


define KernelPackage/nf-nathelper-extra
  SUBMENU:=$(NF_MENU)
  TITLE:=Extra Conntrack and NAT helpers
  KCONFIG:=$(KCONFIG_NF_NATHELPER_EXTRA)
  FILES:=$(foreach mod,$(NF_NATHELPER_EXTRA-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NF_NATHELPER_EXTRA-m)))
  DEPENDS:=+kmod-nf-nat +kmod-lib-textsearch +kmod-asn1-decoder
endef

define KernelPackage/nf-nathelper-extra/description
 Extra Netfilter (IPv4) Conntrack and NAT helpers
 Includes:
 - amanda
 - h323
 - irc
 - mms
 - pptp
 - proto_gre
 - sip
 - snmp_basic
 - tftp
 - broadcast
endef

$(eval $(call KernelPackage,nf-nathelper-extra))


define KernelPackage/ipt-nflog
  TITLE:=Module for user-space packet logging
  KCONFIG:=$(KCONFIG_IPT_NFLOG)
  FILES:=$(foreach mod,$(IPT_NFLOG-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(IPT_NFLOG-m)))
  $(call AddDepends/ipt,+kmod-nfnetlink-log)
endef

define KernelPackage/ipt-nflog/description
 Netfilter module for user-space packet logging
 Includes:
 - NFLOG
endef

$(eval $(call KernelPackage,ipt-nflog))


define KernelPackage/ipt-nfqueue
  TITLE:=Module for user-space packet queuing
  KCONFIG:=$(KCONFIG_IPT_NFQUEUE)
  FILES:=$(foreach mod,$(IPT_NFQUEUE-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(IPT_NFQUEUE-m)))
  $(call AddDepends/ipt,+kmod-nfnetlink-queue)
endef

define KernelPackage/ipt-nfqueue/description
 Netfilter module for user-space packet queuing
 Includes:
 - NFQUEUE
endef

$(eval $(call KernelPackage,ipt-nfqueue))


define KernelPackage/ipt-debug
  TITLE:=Module for debugging/development
  KCONFIG:=$(KCONFIG_IPT_DEBUG)
  FILES:=$(foreach mod,$(IPT_DEBUG-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(IPT_DEBUG-m)))
  $(call AddDepends/ipt,+kmod-ipt-raw +IPV6:kmod-ipt-raw6)
endef

define KernelPackage/ipt-debug/description
 Netfilter modules for debugging/development of the firewall
 Includes:
 - TRACE
endef

$(eval $(call KernelPackage,ipt-debug))


define KernelPackage/ipt-led
  TITLE:=Module to trigger a LED with a Netfilter rule
  KCONFIG:=$(KCONFIG_IPT_LED)
  FILES:=$(foreach mod,$(IPT_LED-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(IPT_LED-m)))
  $(call AddDepends/ipt)
endef

define KernelPackage/ipt-led/description
 Netfilter target to trigger a LED when a network packet is matched.
endef

$(eval $(call KernelPackage,ipt-led))

define KernelPackage/ipt-socket
  TITLE:=Iptables socket matching support
  DEPENDS+=+kmod-nf-socket +kmod-nf-conntrack
  KCONFIG:=$(KCONFIG_IPT_SOCKET)
  FILES:=$(foreach mod,$(IPT_SOCKET-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(IPT_SOCKET-m)))
  $(call AddDepends/ipt)
endef

define KernelPackage/ipt-socket/description
  Kernel modules for socket matching
endef

$(eval $(call KernelPackage,ipt-socket))

define KernelPackage/ipt-tproxy
  TITLE:=Transparent proxying support
  DEPENDS+=+kmod-nf-tproxy +kmod-nf-conntrack
  KCONFIG:=$(KCONFIG_IPT_TPROXY)
  FILES:=$(foreach mod,$(IPT_TPROXY-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(IPT_TPROXY-m)))
  $(call AddDepends/ipt)
endef

define KernelPackage/ipt-tproxy/description
  Kernel modules for Transparent Proxying
endef

$(eval $(call KernelPackage,ipt-tproxy))

define KernelPackage/ipt-tee
  TITLE:=TEE support
  DEPENDS:=+kmod-ipt-conntrack +kmod-nf-dup-inet
  KCONFIG:=$(KCONFIG_IPT_TEE)
  FILES:=$(foreach mod,$(IPT_TEE-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir nf_tee $(IPT_TEE-m)))
  $(call AddDepends/ipt)
endef

define KernelPackage/ipt-tee/description
  Kernel modules for TEE
endef

$(eval $(call KernelPackage,ipt-tee))


define KernelPackage/ipt-u32
  TITLE:=U32 support
  KCONFIG:=$(KCONFIG_IPT_U32)
  FILES:=$(foreach mod,$(IPT_U32-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir nf_tee $(IPT_U32-m)))
  $(call AddDepends/ipt)
endef

define KernelPackage/ipt-u32/description
  Kernel modules for U32
endef

$(eval $(call KernelPackage,ipt-u32))

define KernelPackage/ipt-checksum
  TITLE:=CHECKSUM support
  KCONFIG:=$(KCONFIG_IPT_CHECKSUM)
  FILES:=$(foreach mod,$(IPT_CHECKSUM-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(IPT_CHECKSUM-m)))
  $(call AddDepends/ipt)
endef

define KernelPackage/ipt-checksum/description
  Kernel modules for CHECKSUM fillin target
endef

$(eval $(call KernelPackage,ipt-checksum))


define KernelPackage/ipt-iprange
  TITLE:=Module for matching ip ranges
  KCONFIG:=$(KCONFIG_IPT_IPRANGE)
  FILES:=$(foreach mod,$(IPT_IPRANGE-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(IPT_IPRANGE-m)))
  $(call AddDepends/ipt)
endef

define KernelPackage/ipt-iprange/description
 Netfilter (IPv4) module for matching ip ranges
 Includes:
 - iprange
endef

$(eval $(call KernelPackage,ipt-iprange))

define KernelPackage/ipt-cluster
  TITLE:=Module for matching cluster
  KCONFIG:=$(KCONFIG_IPT_CLUSTER)
  FILES:=$(foreach mod,$(IPT_CLUSTER-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(IPT_CLUSTER-m)))
  $(call AddDepends/ipt,+kmod-nf-conntrack)
endef

define KernelPackage/ipt-cluster/description
 Netfilter (IPv4/IPv6) module for matching cluster
 This option allows you to build work-load-sharing clusters of
 network servers/stateful firewalls without having a dedicated
 load-balancing router/server/switch. Basically, this match returns
 true when the packet must be handled by this cluster node. Thus,
 all nodes see all packets and this match decides which node handles
 what packets. The work-load sharing algorithm is based on source
 address hashing.

 This module is usable for ipv4 and ipv6.

 To use it also enable iptables-mod-cluster

 see `iptables -m cluster --help` for more information.
endef

$(eval $(call KernelPackage,ipt-cluster))


define KernelPackage/ipt-extra
  TITLE:=Extra modules
  KCONFIG:=$(KCONFIG_IPT_EXTRA)
  FILES:=$(foreach mod,$(IPT_EXTRA-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(IPT_EXTRA-m)))
  $(call AddDepends/ipt)
endef

define KernelPackage/ipt-extra/description
 Other Netfilter (IPv4) kernel modules
 Includes:
 - addrtype
 - owner
 - pkttype
 - quota
endef

$(eval $(call KernelPackage,ipt-extra))


define KernelPackage/ipt-physdev
  TITLE:=physdev module
  KCONFIG:=$(KCONFIG_IPT_PHYSDEV)
  FILES:=$(foreach mod,$(IPT_PHYSDEV-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(IPT_PHYSDEV-m)))
  $(call AddDepends/ipt,+kmod-br-netfilter)
endef

define KernelPackage/ipt-physdev/description
 The iptables physdev kernel module
endef

$(eval $(call KernelPackage,ipt-physdev))


define KernelPackage/ip6tables
  SUBMENU:=$(NF_MENU)
  TITLE:=IPv6 modules
  DEPENDS:=@IPV6 +kmod-nf-reject6 +kmod-nf-ipt6 +kmod-ipt-core
  KCONFIG:=$(KCONFIG_IPT_IPV6)
  FILES:=$(foreach mod,$(IPT_IPV6-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoLoad,42,$(notdir $(IPT_IPV6-m)))
endef

define KernelPackage/ip6tables/description
 Netfilter IPv6 firewalling support
endef

$(eval $(call KernelPackage,ip6tables))

define KernelPackage/ip6tables-extra
  SUBMENU:=$(NF_MENU)
  TITLE:=Extra IPv6 modules
  DEPENDS:=@IPV6 +kmod-ip6tables
  KCONFIG:=$(KCONFIG_IPT_IPV6_EXTRA)
  FILES:=$(foreach mod,$(IPT_IPV6_EXTRA-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoLoad,43,$(notdir $(IPT_IPV6_EXTRA-m)))
endef

define KernelPackage/ip6tables-extra/description
 Netfilter IPv6 extra header matching modules
endef

$(eval $(call KernelPackage,ip6tables-extra))

ARP_MODULES = arp_tables arpt_mangle arptable_filter
define KernelPackage/arptables
  SUBMENU:=$(NF_MENU)
  TITLE:=ARP firewalling modules
  DEPENDS:=+kmod-ipt-core
  FILES:=$(LINUX_DIR)/net/ipv4/netfilter/arp*.ko
  KCONFIG:=CONFIG_IP_NF_ARPTABLES \
    CONFIG_IP_NF_ARPFILTER \
    CONFIG_IP_NF_ARP_MANGLE
  AUTOLOAD:=$(call AutoProbe,$(ARP_MODULES))
endef

define KernelPackage/arptables/description
 Kernel modules for ARP firewalling
endef

$(eval $(call KernelPackage,arptables))


define KernelPackage/br-netfilter
  SUBMENU:=$(NF_MENU)
  TITLE:=Bridge netfilter support modules
  DEPENDS:=+kmod-ipt-core
  FILES:=$(LINUX_DIR)/net/bridge/br_netfilter.ko
  KCONFIG:=CONFIG_BRIDGE_NETFILTER
  AUTOLOAD:=$(call AutoProbe,br_netfilter)
endef

define KernelPackage/br-netfilter/install
	$(INSTALL_DIR) $(1)/etc/sysctl.d
	$(INSTALL_DATA) ./files/sysctl-br-netfilter.conf $(1)/etc/sysctl.d/11-br-netfilter.conf
endef

$(eval $(call KernelPackage,br-netfilter))


define KernelPackage/ebtables
  SUBMENU:=$(NF_MENU)
  TITLE:=Bridge firewalling modules
  DEPENDS:=+kmod-ipt-core
  FILES:=$(foreach mod,$(EBTABLES-m),$(LINUX_DIR)/net/$(mod).ko)
  KCONFIG:=$(KCONFIG_EBTABLES)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(EBTABLES-m)))
endef

define KernelPackage/ebtables/description
  ebtables is a general, extensible frame/packet identification
  framework. It provides you to do Ethernet
  filtering/NAT/brouting on the Ethernet bridge.
endef

$(eval $(call KernelPackage,ebtables))


define AddDepends/ebtables
  SUBMENU:=$(NF_MENU)
  DEPENDS+= +kmod-ebtables $(1)
endef


define KernelPackage/ebtables-ipv4
  TITLE:=ebtables: IPv4 support
  FILES:=$(foreach mod,$(EBTABLES_IP4-m),$(LINUX_DIR)/net/$(mod).ko)
  KCONFIG:=$(KCONFIG_EBTABLES_IP4)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(EBTABLES_IP4-m)))
  $(call AddDepends/ebtables)
endef

define KernelPackage/ebtables-ipv4/description
 This option adds the IPv4 support to ebtables, which allows basic
 IPv4 header field filtering, ARP filtering as well as SNAT, DNAT targets.
endef

$(eval $(call KernelPackage,ebtables-ipv4))


define KernelPackage/ebtables-ipv6
  TITLE:=ebtables: IPv6 support
  DEPENDS:=@IPV6
  FILES:=$(foreach mod,$(EBTABLES_IP6-m),$(LINUX_DIR)/net/$(mod).ko)
  KCONFIG:=$(KCONFIG_EBTABLES_IP6)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(EBTABLES_IP6-m)))
  $(call AddDepends/ebtables)
endef

define KernelPackage/ebtables-ipv6/description
 This option adds the IPv6 support to ebtables, which allows basic
 IPv6 header field filtering and target support.
endef

$(eval $(call KernelPackage,ebtables-ipv6))


define KernelPackage/ebtables-watchers
  TITLE:=ebtables: watchers support
  FILES:=$(foreach mod,$(EBTABLES_WATCHERS-m),$(LINUX_DIR)/net/$(mod).ko)
  KCONFIG:=$(KCONFIG_EBTABLES_WATCHERS)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(EBTABLES_WATCHERS-m)))
  $(call AddDepends/ebtables)
endef

define KernelPackage/ebtables-watchers/description
 This option adds the log watchers, that you can use in any rule
 in any ebtables table.
endef

$(eval $(call KernelPackage,ebtables-watchers))


define KernelPackage/nfnetlink
  SUBMENU:=$(NF_MENU)
  TITLE:=Netlink-based userspace interface
  FILES:=$(foreach mod,$(NFNETLINK-m),$(LINUX_DIR)/net/$(mod).ko)
  KCONFIG:=$(KCONFIG_NFNETLINK)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NFNETLINK-m)))
endef

define KernelPackage/nfnetlink/description
 Kernel modules support for a netlink-based userspace interface
endef

$(eval $(call KernelPackage,nfnetlink))


define AddDepends/nfnetlink
  SUBMENU:=$(NF_MENU)
  DEPENDS+=+kmod-nfnetlink $(1)
endef


define KernelPackage/nfnetlink-log
  TITLE:=Netfilter LOG over NFNETLINK interface
  FILES:=$(foreach mod,$(NFNETLINK_LOG-m),$(LINUX_DIR)/net/$(mod).ko)
  KCONFIG:=$(KCONFIG_NFNETLINK_LOG)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NFNETLINK_LOG-m)))
  $(call AddDepends/nfnetlink)
endef

define KernelPackage/nfnetlink-log/description
 Kernel modules support for logging packets via NFNETLINK
 Includes:
 - NFLOG
endef

$(eval $(call KernelPackage,nfnetlink-log))


define KernelPackage/nfnetlink-queue
  TITLE:=Netfilter QUEUE over NFNETLINK interface
  FILES:=$(foreach mod,$(NFNETLINK_QUEUE-m),$(LINUX_DIR)/net/$(mod).ko)
  KCONFIG:=$(KCONFIG_NFNETLINK_QUEUE)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NFNETLINK_QUEUE-m)))
  $(call AddDepends/nfnetlink)
endef

define KernelPackage/nfnetlink-queue/description
 Kernel modules support for queueing packets via NFNETLINK
 Includes:
 - NFQUEUE
endef

$(eval $(call KernelPackage,nfnetlink-queue))


define KernelPackage/nfnetlink-cthelper
  TITLE:=Netfilter User space conntrack helpers
  FILES:=$(LINUX_DIR)/net/netfilter/nfnetlink_cthelper.ko
  KCONFIG:=CONFIG_NF_CT_NETLINK_HELPER
  AUTOLOAD:=$(call AutoProbe,nfnetlink_cthelper)
  $(call AddDepends/nfnetlink,+kmod-nfnetlink-queue +kmod-nf-conntrack-netlink)
endef

define KernelPackage/nfnetlink-cthelper/description
 Kernel modules support for a netlink-based connection tracking
 userspace helpers interface
endef

$(eval $(call KernelPackage,nfnetlink-cthelper))


define KernelPackage/nfnetlink-cttimeout
  TITLE:=Netfilter conntrack expectation timeout
  FILES:=$(LINUX_DIR)/net/netfilter/nfnetlink_cttimeout.ko
  KCONFIG:=CONFIG_NF_CT_NETLINK_TIMEOUT
  AUTOLOAD:=$(call AutoProbe,nfnetlink_cttimeout)
  $(call AddDepends/nfnetlink,+kmod-nf-conntrack @KERNEL_NF_CONNTRACK_TIMEOUT)
endef

define KernelPackage/nfnetlink-cttimeout/description
 Kernel modules support for a netlink-based connection tracking
 userspace timeout interface

 Requires CONFIG_NF_CONNTRACK_TIMEOUT (only enabled for non-small flash devices)
endef

$(eval $(call KernelPackage,nfnetlink-cttimeout))


define KernelPackage/nf-conntrack-netlink
  TITLE:=Connection tracking netlink interface
  FILES:=$(LINUX_DIR)/net/netfilter/nf_conntrack_netlink.ko
  KCONFIG:=CONFIG_NF_CT_NETLINK CONFIG_NF_CONNTRACK_EVENTS=y CONFIG_NETFILTER_NETLINK_GLUE_CT=y
  AUTOLOAD:=$(call AutoProbe,nf_conntrack_netlink)
  $(call AddDepends/nfnetlink,+kmod-nf-conntrack)
endef

define KernelPackage/nf-conntrack-netlink/description
 Kernel modules support for a netlink-based connection tracking
 userspace interface
endef

$(eval $(call KernelPackage,nf-conntrack-netlink))

define KernelPackage/ipt-hashlimit
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter hashlimit match
  DEPENDS:=+kmod-ipt-core
  KCONFIG:=$(KCONFIG_IPT_HASHLIMIT)
  FILES:=$(LINUX_DIR)/net/netfilter/xt_hashlimit.ko
  AUTOLOAD:=$(call AutoProbe,xt_hashlimit)
  $(call KernelPackage/ipt)
endef

define KernelPackage/ipt-hashlimit/description
 Kernel modules support for the hashlimit bucket match module
endef

$(eval $(call KernelPackage,ipt-hashlimit))

define KernelPackage/ipt-rpfilter
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter rpfilter match
  DEPENDS:=+kmod-ipt-core
  KCONFIG:=$(KCONFIG_IPT_RPFILTER)
  FILES:=$(realpath \
	$(LINUX_DIR)/net/ipv4/netfilter/ipt_rpfilter.ko \
	$(LINUX_DIR)/net/ipv6/netfilter/ip6t_rpfilter.ko)
  AUTOLOAD:=$(call AutoProbe,ipt_rpfilter ip6t_rpfilter)
  $(call KernelPackage/ipt)
endef

define KernelPackage/ipt-rpfilter/description
 Kernel modules support for the Netfilter rpfilter match
endef

$(eval $(call KernelPackage,ipt-rpfilter))


define KernelPackage/nft-core
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter nf_tables support
  DEPENDS:=+kmod-nfnetlink +kmod-nf-reject +IPV6:kmod-nf-reject6 +IPV6:kmod-nf-conntrack6 +kmod-nf-nat +kmod-nf-log +IPV6:kmod-nf-log6 +kmod-lib-crc32c
  FILES:=$(foreach mod,$(NFT_CORE-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NFT_CORE-m)))
  KCONFIG:= \
	CONFIG_NFT_COMPAT=n \
	CONFIG_NFT_QUEUE=n \
	$(KCONFIG_NFT_CORE)
endef

define KernelPackage/nft-core/description
 Kernel module support for nftables
endef

$(eval $(call KernelPackage,nft-core))


define KernelPackage/nft-arp
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter nf_tables ARP table support
  DEPENDS:=+kmod-nft-core
  FILES:=$(foreach mod,$(NFT_ARP-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NFT_ARP-m)))
  KCONFIG:=$(KCONFIG_NFT_ARP)
endef

$(eval $(call KernelPackage,nft-arp))


define KernelPackage/nft-bridge
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter nf_tables bridge table support
  DEPENDS:=+kmod-nft-core
  FILES:=$(foreach mod,$(NFT_BRIDGE-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NFT_BRIDGE-m)))
  KCONFIG:= \
	$(KCONFIG_NFT_BRIDGE)
endef

$(eval $(call KernelPackage,nft-bridge))


define KernelPackage/nft-dup-inet
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter nf_tables dup in ip/ip6/inet family support
  DEPENDS:=+kmod-nft-core +kmod-nf-dup-inet
  KCONFIG:= \
	CONFIG_NFT_DUP_IPV4 \
	CONFIG_NFT_DUP_IPV6
  FILES:= \
	$(LINUX_DIR)/net/ipv4/netfilter/nft_dup_ipv4.ko \
	$(LINUX_DIR)/net/ipv6/netfilter/nft_dup_ipv6.ko
  AUTOLOAD:=$(call AutoProbe,nft_dup_ipv4 nft_dup_ipv6)
endef

$(eval $(call KernelPackage,nft-dup-inet))


define KernelPackage/nft-nat
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter nf_tables NAT support
  DEPENDS:=+kmod-nft-core +kmod-nf-nat
  FILES:=$(foreach mod,$(NFT_NAT-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NFT_NAT-m)))
  KCONFIG:=$(KCONFIG_NFT_NAT)
endef

$(eval $(call KernelPackage,nft-nat))


define KernelPackage/nft-offload
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter nf_tables routing/NAT offload support
  DEPENDS:=@IPV6 +kmod-nf-flow +kmod-nft-nat
  KCONFIG:= \
	CONFIG_NF_FLOW_TABLE_INET \
	CONFIG_NFT_FLOW_OFFLOAD
  FILES:= \
	$(LINUX_DIR)/net/netfilter/nf_flow_table_inet.ko \
	$(LINUX_DIR)/net/netfilter/nft_flow_offload.ko
  AUTOLOAD:=$(call AutoProbe,nf_flow_table_inet nft_flow_offload)
endef

$(eval $(call KernelPackage,nft-offload))


define KernelPackage/nft-netdev
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter nf_tables netdev support
  DEPENDS:=+kmod-nft-core
  KCONFIG:= \
	CONFIG_NETFILTER_INGRESS=y \
	CONFIG_NETFILTER_EGRESS=y \
	CONFIG_NF_TABLES_NETDEV \
	CONFIG_NF_DUP_NETDEV \
	CONFIG_NFT_DUP_NETDEV \
	CONFIG_NFT_FWD_NETDEV
  FILES:= \
	$(LINUX_DIR)/net/netfilter/nf_dup_netdev.ko \
	$(LINUX_DIR)/net/netfilter/nft_dup_netdev.ko \
	$(LINUX_DIR)/net/netfilter/nft_fwd_netdev.ko
  AUTOLOAD:=$(call AutoProbe,nf_tables_netdev nf_dup_netdev nft_dup_netdev nft_fwd_netdev)
endef

$(eval $(call KernelPackage,nft-netdev))


define KernelPackage/nft-fib
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter nf_tables fib support
  DEPENDS:=+kmod-nft-core
  FILES:=$(foreach mod,$(NFT_FIB-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NFT_FIB-m)))
  KCONFIG:=$(KCONFIG_NFT_FIB)
endef

$(eval $(call KernelPackage,nft-fib))


define KernelPackage/nft-queue
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter nf_tables queue support
  DEPENDS:=+kmod-nft-core +kmod-nfnetlink-queue
  FILES:=$(foreach mod,$(NFT_QUEUE-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NFT_QUEUE-m)))
  KCONFIG:=$(KCONFIG_NFT_QUEUE)
endef

$(eval $(call KernelPackage,nft-queue))

define KernelPackage/nft-socket
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter nf_tables socket support
  DEPENDS:=+kmod-nft-core +kmod-nf-socket
  FILES:=$(foreach mod,$(NFT_SOCKET-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NFT_SOCKET-m)))
  KCONFIG:=$(KCONFIG_NFT_SOCKET)
endef

$(eval $(call KernelPackage,nft-socket))

define KernelPackage/nft-tproxy
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter nf_tables tproxy support
  DEPENDS:=+kmod-nft-core +kmod-nf-tproxy +kmod-nf-conntrack
  FILES:=$(foreach mod,$(NFT_TPROXY-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NFT_TPROXY-m)))
  KCONFIG:=$(KCONFIG_NFT_TPROXY)
endef

$(eval $(call KernelPackage,nft-tproxy))

define KernelPackage/nft-compat
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter nf_tables compat support
  DEPENDS:=+kmod-nft-core +kmod-nf-ipt
  FILES:=$(foreach mod,$(NFT_COMPAT-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NFT_COMPAT-m)))
  KCONFIG:=$(KCONFIG_NFT_COMPAT)
endef

$(eval $(call KernelPackage,nft-compat))

define KernelPackage/nft-xfrm
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter nf_tables xfrm support (ipsec)
  DEPENDS:=+kmod-nft-core
  FILES:=$(foreach mod,$(NFT_XFRM-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NFT_XFRM-m)))
  KCONFIG:=$(KCONFIG_NFT_XFRM)
endef

$(eval $(call KernelPackage,nft-xfrm))

define KernelPackage/nft-connlimit
  SUBMENU:=$(NF_MENU)
  TITLE:=Netfilter nf_tables connlimit support
  DEPENDS:=+kmod-nft-core +kmod-nf-conncount
  FILES:=$(foreach mod,$(NFT_CONNLIMIT-m),$(LINUX_DIR)/net/$(mod).ko)
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NFT_CONNLIMIT-m)))
  KCONFIG:=$(KCONFIG_NFT_CONNLIMIT)
endef

$(eval $(call KernelPackage,nft-connlimit))
