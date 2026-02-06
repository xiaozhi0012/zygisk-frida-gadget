#!/system/bin/sh
# Zygisk Frida Gadget - Service Script

# 模块安装后执行的服务脚本
# 这里可以添加运行时的配置和初始化代码

MODDIR=${0%/*}

# 日志函数
log_print() {
    echo "[ZygiskFridaGadget] $1" | tee -a /data/local/tmp/zygisk_frida_gadget.log
}

log_print "Service started"

# 确保库文件的权限正确
chmod 644 "$MODDIR/lib/arm64-v8a"/*.so 2>/dev/null

log_print "Initialization completed"
