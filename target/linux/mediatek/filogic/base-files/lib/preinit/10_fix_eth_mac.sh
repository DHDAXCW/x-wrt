. /lib/functions/system.sh

preinit_set_mac_address() {
	ip link set eth0 down; ip link set eth1 down
	case $(board_name) in
	acer,predator-w6)
		key_path="/var/qcidata/data"
		ip link set dev lan1 address "$(cat $key_path/LANMAC)"
		ip link set dev lan2 address "$(cat $key_path/LANMAC)"
		ip link set dev lan3 address "$(cat $key_path/LANMAC)"
		ip link set dev game address "$(cat $key_path/LANMAC)"
		ip link set dev eth1 address "$(cat $key_path/WANMAC)"
		;;
	asus,tuf-ax4200|\
	asus,tuf-ax6000)
		CI_UBIPART="UBI_DEV"
		addr=$(mtd_get_mac_binary_ubi "Factory" 0x4)
		ip link set dev eth0 address "$addr"
		ip link set dev eth1 address "$addr"
		;;
	cmcc,rax3000m-emmc-ubootlayout)
		addr=$(mmc_get_mac_binary factory 0x24)
		ip link set dev eth0 address "$addr"
		addr=$(mmc_get_mac_binary factory 0x2a)
		ip link set dev eth1 address "$addr"
		;;
	cmcc,rax3000m)
		case "$(cmdline_get_var root)" in
		/dev/mmc*)
			addr=$(mmc_get_mac_binary factory 0x24)
			ip link set dev eth0 address "$addr"
			addr=$(mmc_get_mac_binary factory 0x2a)
			ip link set dev eth1 address "$addr"
			;;
		esac
		;;
	mercusys,mr90x-v1|\
	tplink,re6000xd)
		addr=$(get_mac_binary "/tmp/tp_data/default-mac" 0)
		ip link set dev eth1 address "$(macaddr_add $addr 1)"
		;;
	smartrg,sdg-8612|\
	smartrg,sdg-8614|\
	smartrg,sdg-8733|\
	smartrg,sdg-8734)
		addr=$(mmc_get_mac_ascii mfginfo MFG_MAC)
		lan_addr=$(macaddr_add $addr 1)
		ip link set dev wan address "$addr"
		ip link set dev eth0 address "$lan_addr"
		ip link set dev lan1 address "$lan_addr"
		ip link set dev lan2 address "$lan_addr"
		ip link set dev lan3 address "$lan_addr"
		ip link set dev lan4 address "$lan_addr"
		;;
	smartrg,sdg-8622|\
	smartrg,sdg-8632)
		addr=$(mmc_get_mac_ascii mfginfo MFG_MAC)
		ip link set dev wan address "$addr"
		ip link set dev lan address "$(macaddr_add $addr 1)"
		;;
	*)
		;;
	esac
	ip link set eth0 up; ip link set eth1 up
}

boot_hook_add preinit_main preinit_set_mac_address
