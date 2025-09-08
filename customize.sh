#!/bin/bash
#===============================================
# Modify default IP and hostname in one go
sed -i -e 's/192.168.1.1/192.168.10.5/g' -e 's/kenzo/OpenWrt/g' openwrt/package/base-files/files/bin/config_generate

# Modify default theme (正确路径)
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' openwrt/feeds/luci/collections/luci/Makefile

# 添加iStoreOS风格的首页和网络向导
echo "Adding iStoreOS-style homepage and network wizard..."

# 创建iStoreOS风格的首页
mkdir -p openwrt/package/base-files/files/usr/lib/lua/luci/view/istoreos/
cat > openwrt/package/base-files/files/usr/lib/lua/luci/view/istoreos/homepage.htm << 'HTMLEND'
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title><%:iStoreOS - 首页%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%=media%>/css/style.css">
    <style>
        .istoreos-home {
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }
        .istoreos-header {
            text-align: center;
            margin-bottom: 30px;
            padding: 20px;
            background: linear-gradient(135deg, #1890ff 0%, #096dd9 100%);
            color: white;
            border-radius: 8px;
        }
        .istoreos-cards {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .istoreos-card {
            background: #fff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
            transition: all 0.3s;
        }
        .istoreos-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 16px 0 rgba(0, 0, 0, 0.15);
        }
        .istoreos-card-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 15px;
            color: #1890ff;
        }
        .istoreos-btn {
            display: inline-block;
            padding: 8px 16px;
            background: #1890ff;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            margin: 5px;
            transition: all 0.3s;
        }
        .istoreos-btn:hover {
            background: #40a9ff;
            color: white;
        }
        .istoreos-status {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
        }
        .istoreos-status-label {
            color: #666;
        }
        .istoreos-status-value {
            font-weight: bold;
        }
        .progress-bar {
            height: 8px;
            background: #f0f0f0;
            border-radius: 4px;
            overflow: hidden;
            margin: 10px 0;
        }
        .progress-bar-inner {
            height: 100%;
            background: #1890ff;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <div class="istoreos-home">
        <div class="istoreos-header">
            <h1><%:欢迎使用 iStoreOS 风格固件%></h1>
            <p><%:简洁、高效、易用的路由器操作系统%></p>
        </div>
        
        <div class="istoreos-cards">
            <div class="istoreos-card">
                <div class="istoreos-card-title"><%:系统状态%></div>
                <div class="istoreos-status">
                    <span class="istoreos-status-label"><%:运行时间%>:</span>
                    <span class="istoreos-status-value"><%=luci.sys.uptime()%></span>
                </div>
                <div class="istoreos-status">
                    <span class="istoreos-status-label"><%:CPU 使用率%>:</span>
                    <span class="istoreos-status-value"><%=luci.sys.exec("top -bn1 | grep 'Cpu(s)' | awk '{print $2}' | cut -d'%' -f1")%>%</span>
                </div>
                <div class="istoreos-status">
                    <span class="istoreos-status-label"><%:内存使用%>:</span>
                    <span class="istoreos-status-value"><%=luci.sys.exec("free -m | awk 'NR==2{printf \"%.1f/%.1fMB (%.1f%%)\", \$3/1024,\$2/1024,\$3*100/\$2 }'")%></span>
                </div>
                <div class="progress-bar">
                    <div class="progress-bar-inner" style="width: <%=luci.sys.exec("free -m | awk 'NR==2{printf \"%.1f\", \$3*100/\$2 }'")%>%"></div>
                </div>
            </div>
            
            <div class="istoreos-card">
                <div class="istoreos-card-title"><%:快速设置%></div>
                <p><%:一键配置您的路由器%></p>
                <a href="<%=url('admin/network/wizard')%>" class="istoreos-btn"><%:网络设置向导%></a>
                <a href="<%=url('admin/network/wireless')%>" class="istoreos-btn"><%:无线设置%></a>
                <a href="<%=url('admin/system/admin')%>" class="istoreos-btn"><%:密码设置%></a>
            </div>
            
            <div class="istoreos-card">
                <div class="istoreos-card-title"><%:网络状态%></div>
                <div class="istoreos-status">
                    <span class="istoreos-status-label"><%:WAN 状态%>:</span>
                    <span class="istoreos-status-value"><%=luci.sys.exec("ubus call network.interface.wan status 2>/dev/null | grep -q '\"up\": true' && echo '已连接' || echo '未连接'")%></span>
                </div>
                <div class="istoreos-status">
                    <span class="istoreos-status-label"><%:LAN IP%>:</span>
                    <span class="istoreos-status-value"><%=luci.sys.exec("uci get network.lan.ipaddr 2>/dev/null")%></span>
                </div>
                <div class="istoreos-status">
                    <span class="istoreos-status-label"><%:客户端数量%>:</span>
                    <span class="istoreos-status-value"><%=luci.sys.exec("cat /tmp/dhcp.leases | wc -l")%></span>
                </div>
            </div>
        </div>
        
        <div class="istoreos-card">
            <div class="istoreos-card-title"><%:系统信息%></div>
            <div class="istoreos-status">
                <span class="istoreos-status-label"><%:固件版本%>:</span>
                <span class="istoreos-status-value"><%=luci.version.distversion%></span>
            </div>
            <div class="istoreos-status">
                <span class="istoreos-status-label"><%:内核版本%>:</span>
                <span class="istoreos-status-value"><%=luci.sys.exec("uname -r")%></span>
            </div>
            <div class="istoreos-status">
                <span class="istoreos-status-label"><%:本地时间%>:</span>
                <span class="istoreos-status-value"><%=os.date("%Y-%m-%d %H:%M:%S")%></span>
            </div>
        </div>
    </div>
</body>
</html>
HTMLEND

# 创建网络设置向导控制器
mkdir -p openwrt/package/base-files/files/usr/lib/lua/luci/controller/admin/network/
cat > openwrt/package/base-files/files/usr/lib/lua/luci/controller/admin/network/wizard.lua << 'LUACIEND'
module("luci.controller.admin.network.wizard", package.seeall)

function index()
    entry({"admin", "network", "wizard"}, call("wizard"), _("Network Wizard"), 1)
end

function wizard()
    local uci = require "luci.model.uci".cursor()
    local http = require "luci.http"
    
    if http.formvalue("step") == "2" then
        -- 处理WAN设置
        local wan_proto = http.formvalue("wan_proto") or "dhcp"
        uci:set("network", "wan", "proto", wan_proto)
        
        if wan_proto == "pppoe" then
            uci:set("network", "wan", "username", http.formvalue("pppoe_user") or "")
            uci:set("network", "wan", "password", http.formvalue("pppoe_pass") or "")
        elseif wan_proto == "static" then
            uci:set("network", "wan", "ipaddr", http.formvalue("static_ip") or "")
            uci:set("network", "wan", "netmask", http.formvalue("static_mask") or "")
            uci:set("network", "wan", "gateway", http.formvalue("static_gw") or "")
            uci:set("network", "wan", "dns", http.formvalue("static_dns") or "")
        end
        
        uci:commit("network")
        
        -- 处理无线设置
        local wireless_enabled = http.formvalue("wireless_enabled") and "1" or "0"
        uci:set("wireless", "default_radio0", "disabled", wireless_enabled == "1" and "0" or "1")
        
        if wireless_enabled == "1" then
            uci:set("wireless", "default_radio0", "ssid", http.formvalue("ssid") or "OpenWrt")
            uci:set("wireless", "default_radio0", "encryption", http.formvalue("encryption") or "psk2")
            if http.formvalue("encryption") ~= "none" then
                uci:set("wireless", "default_radio0", "key", http.formvalue("key") or "")
            end
        end
        
        uci:commit("wireless")
        
        -- 应用设置
        luci.sys.call("/etc/init.d/network restart >/dev/null 2>&1 &")
        luci.sys.call("/etc/init.d/firewall restart >/dev/null 2>&1 &")
        
        luci.template.render("istoreos/wizard_success", {
            message = "网络设置已应用，系统正在重启网络服务..."
        })
        return
    end
    
    luci.template.render("istoreos/wizard", {
        wan_proto = uci:get("network", "wan", "proto") or "dhcp",
        pppoe_user = uci:get("network", "wan", "username") or "",
        wireless_disabled = uci:get("wireless", "default_radio0", "disabled") or "0",
        ssid = uci:get("wireless", "default_radio0", "ssid") or "OpenWrt",
        encryption = uci:get("wireless", "default_radio0", "encryption") or "psk2"
    })
end
LUACIEND

# 创建网络设置向导页面
cat > openwrt/package/base-files/files/usr/lib/lua/luci/view/istoreos/wizard.htm << 'WIZARDEND'
<%+header%>
<div class="cbi-map">
    <h2 name="content"><%:网络设置向导%></h2>
    <div class="cbi-map-descr"><%:欢迎使用网络设置向导，这将帮助您快速配置网络设置%></div>
    
    <form method="post" action="<%=url('admin/network/wizard')%>">
        <input type="hidden" name="step" value="2">
        
        <fieldset class="cbi-section">
            <legend><%:互联网连接设置%></legend>
            
            <div class="cbi-value">
                <label class="cbi-value-title"><%:连接类型%></label>
                <div class="cbi-value-field">
                    <select name="wan_proto" class="cbi-input-select" onchange="updateWanFields()">
                        <option value="dhcp" <%=self.wan_proto == "dhcp" and 'selected="selected"' or ''%>><%:自动获取 (DHCP)%></option>
                        <option value="pppoe" <%=self.wan_proto == "pppoe" and 'selected="selected"' or ''%>><%:PPPoE%></option>
                        <option value="static" <%=self.wan_proto == "static" and 'selected="selected"' or ''%>><%:静态地址%></option>
                    </select>
                </div>
            </div>
            
            <div id="pppoe_fields" style="display:<%=self.wan_proto == "pppoe" and 'block' or 'none'%>">
                <div class="cbi-value">
                    <label class="cbi-value-title"><%:PPPoE用户名%></label>
                    <div class="cbi-value-field">
                        <input type="text" name="pppoe_user" class="cbi-input-text" value="<%=self.pppoe_user%>" />
                    </div>
                </div>
                
                <div class="cbi-value">
                    <label class="cbi-value-title"><%:PPPoE密码%></label>
                    <div class="cbi-value-field">
                        <input type="password" name="pppoe_pass" class="cbi-input-password" value="" />
                    </div>
                </div>
            </div>
            
            <div id="static_fields" style="display:<%=self.wan_proto == "static" and 'block' or 'none'%>">
                <div class="cbi-value">
                    <label class="cbi-value-title"><%:IP地址%></label>
                    <div class="cbi-value-field">
                        <input type="text" name="static_ip" class="cbi-input-text" value="<%=uci:get('network', 'wan', 'ipaddr') or ''%>" />
                    </div>
                </div>
                
                <div class="cbi-value">
                    <label class="cbi-value-title"><%:子网掩码%></label>
                    <div class="cbi-value-field">
                        <input type="text" name="static_mask" class="cbi-input-text" value="<%=uci:get('network', 'wan', 'netmask') or '255.255.255.0'%>" />
                    </div>
                </div>
                
                <div class="cbi-value">
                    <label class="cbi-value-title"><%:网关%></label>
                    <div class="cbi-value-field">
                        <input type="text" name="static_gw" class="cbi-input-text" value="<%=uci:get('network', 'wan', 'gateway') or ''%>" />
                    </div>
                </div>
                
                <div class="cbi-value">
                    <label class="cbi-value-title"><%:DNS服务器%></label>
                    <div class="cbi-value-field">
                        <input type="text" name="static_dns" class="cbi-input-text" value="<%=uci:get('network', 'wan', 'dns') or ''%>" />
                    </div>
                </div>
            </div>
        </fieldset>
        
        <fieldset class="cbi-section">
            <legend><%:无线网络设置%></legend>
            
            <div class="cbi-value">
                <label class="cbi-value-title"><%:启用无线网络%></label>
                <div class="cbi-value-field">
                    <input type="checkbox" name="wireless_enabled" class="cbi-input-checkbox" <%=self.wireless_disabled == "0" and 'checked="checked"' or ''%> />
                </div>
            </div>
            
            <div class="cbi-value">
                <label class="cbi-value-title"><%:网络名称 (SSID)%></label>
                <div class="cbi-value-field">
                    <input type="text" name="ssid" class="cbi-input-text" value="<%=self.ssid%>" />
                </div>
            </div>
            
            <div class="cbi-value">
                <label class="cbi-value-title"><%:加密方式%></label>
                <div class="cbi-value-field">
                    <select name="encryption" class="cbi-input-select">
                        <option value="none" <%=self.encryption == "none" and 'selected="selected"' or ''%>><%:不加密%></option>
                        <option value="psk" <%=self.encryption == "psk" and 'selected="selected"' or ''%>><%:WPA-PSK%></option>
                        <option value="psk2" <%=self.encryption == "psk2" and 'selected="selected"' or ''%>><%:WPA2-PSK%></option>
                        <option value="psk-mixed" <%=self.encryption == "psk-mixed" and 'selected="selected"' or ''%>><%:WPA/WPA2混合%></option>
                    </select>
                </div>
            </div>
            
            <div class="cbi-value">
                <label class="cbi-value-title"><%:无线密码%></label>
                <div class="cbi-value-field">
                    <input type="password" name="key" class="cbi-input-password" value="" />
                </div>
            </div>
        </fieldset>
        
        <div class="cbi-page-actions right">
            <input type="submit" class="cbi-button cbi-button-apply" value="<%:应用设置%>" />
            <input type="button" class="cbi-button cbi-button-reset" value="<%:取消%>" onclick="window.history.back()" />
        </div>
    </form>
</div>

<script>
    function updateWanFields() {
        var wanType = document.querySelector('select[name="wan_proto"]').value;
        document.getElementById('pppoe_fields').style.display = wanType === 'pppoe' ? 'block' : 'none';
        document.getElementById('static_fields').style.display = wanType === 'static' ? 'block' : 'none';
    }
</script>
<%+footer%>
WIZARDEND

# 创建向导成功页面
cat > openwrt/package/base-files/files/usr/lib/lua/luci/view/istoreos/wizard_success.htm << 'SUCCESSEND'
<%+header%>
<div class="cbi-map">
    <h2 name="content"><%:设置已应用%></h2>
    <div class="cbi-map-descr">
        <p><%:您的网络设置已成功应用，系统正在重启网络服务。%></p>
        <p><%:这可能需要几分钟时间，请耐心等待。%></p>
        <p><%:完成后，您可以<%> <a href="<%=url('admin/status/overview')%>"><%:查看状态%></a> <%:或进行其他设置。%></p>
    </div>
    
    <div class="cbi-page-actions right">
        <a href="<%=url('admin/status/overview')%>" class="cbi-button cbi-button-positive"><%:前往状态页%></a>
        <a href="<%=url('admin/network/wizard')%>" class="cbi-button"><%:返回向导%></a>
    </div>
</div>
<%+footer%>
SUCCESSEND

# 创建初始化脚本，设置首页为iStoreOS风格
mkdir -p openwrt/package/base-files/files/etc/uci-defaults/
cat > openwrt/package/base-files/files/etc/uci-defaults/99-istoreos-style << 'EOF'
#!/bin/sh

# 设置iStoreOS风格首页
uci set luci.main.mediaurlbase='/luci-static/argon'
uci set luci.main.landingpage='istoreos/homepage'
uci commit luci

# 确保网络向导菜单项存在
if ! grep -q "wizard" /usr/lib/lua/luci/controller/admin/network.lua 2>/dev/null; then
    sed -i '/^module/a\
\
entry({"admin", "network", "wizard"}, call("wizard"), _("Network Wizard"), 1).dependent = false' /usr/lib/lua/luci/controller/admin/network.lua
fi

exit 0
EOF

chmod +x openwrt/package/base-files/files/etc/uci-defaults/99-istoreos-style

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

echo "iStoreOS风格首页和网络向导已添加完成!"