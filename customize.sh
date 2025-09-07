#!/bin/bash
#===============================================
# Modify default IP and hostname in one go
sed -i -e 's/192.168.1.1/192.168.10.5/g' -e 's/kenzo/OpenWrt/g' openwrt/package/base-files/files/bin/config_generate

# Modify default theme (正确路径)
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' openwrt/feeds/luci/collections/luci/Makefile

# 确保目录存在（正确路径）
mkdir -p openwrt/package/base-files/files/etc/

# 写入banner文件（正确路径）
echo "_________" > openwrt/package/base-files/files/etc/banner
echo "    /        /\      _    ___ ___  ___" >> openwrt/package/base-files/files/etc/banner
echo "   /  LE    /  \    | |  | __|   \| __|" >> openwrt/package/base-files/files/etc/banner
echo "  /    DE  /    \   | |__| _|| |) | _|" >> openwrt/package/base-files/files/etc/banner
echo " /________/  LE  \  |____|___|___/|___|" >> openwrt/package/base-files/files/etc/banner
echo " \        \   DE /" >> openwrt/package/base-files/files/etc/banner
echo "  \    LE  \    /  -------------------------------------------" >> openwrt/package/base-files/files/etc/banner
echo "   \  DE    \  /    %D" >> openwrt/package/base-files/files/etc/banner
echo "    \________\/    -------------------------------------------" >> openwrt/package/base-files/files/etc/banner