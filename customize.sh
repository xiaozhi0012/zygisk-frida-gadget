#!/system/bin/sh
# Zygisk Frida Gadget - Customize Script

# 检查 zygisk 模块
MODDIR=${0%/*}

# 确保库文件存在
if [ ! -d "$MODDIR/lib/arm64-v8a" ]; then
    mkdir -p "$MODDIR/lib/arm64-v8a"
fi

# 设置权限
chmod 755 "$MODDIR/lib/arm64-v8a" 2>/dev/null
find "$MODDIR/lib" -type f -name "*.so" -exec chmod 644 {} \; 2>/dev/null

# 日志输出
ui_print "- Zygisk Frida Gadget module installed"
