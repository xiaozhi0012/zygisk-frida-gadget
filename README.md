# Zygisk Frida Gadget

一个基于 Zygisk 框架的 Magisk 模块，用于注入 Frida Gadget。

## 功能特性

- ✅ 基于 Zygisk 框架
- ✅ 支持 ARM64 架构
- ✅ 自动编译和打包
- ✅ GitHub Actions CI/CD

## 项目结构

```
zygisk-frida-gadget/
├── module.prop              # Magisk 模块配置
├── customize.sh             # 安装自定义脚本
├── service.sh               # 安装后服务脚本
├── CMakeLists.txt          # CMake 构建配置
├── lib/arm64-v8a/          # 库文件目录
├── zygisk/arm64-v8a/       # Zygisk 模块输出
├── include/zygisk.hpp      # Zygisk API 头文件
├── src/zygisk.cpp          # 模块源代码
└── .github/workflows/build.yml  # GitHub Actions 配置
```

## 构建步骤

### 本地构建

```bash
# 安装依赖
sudo apt-get install -y cmake build-essential ninja-build

# 下载 Android NDK
# 设置 ANDROID_NDK_ROOT 环境变量

# 构建
mkdir build && cd build
cmake .. \
  -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_ROOT/build/cmake/android.cmake \
  -DANDROID_ABI=arm64-v8a \
  -DANDROID_PLATFORM=android-29 \
  -DANDROID_STL=c++_shared \
  -DCMAKE_BUILD_TYPE=Release \
  -GNinja
ninja -j$(nproc)
```

### GitHub Actions 自动构建

推送到 `main` 分支自动触发构建，构建产物保存为 Artifacts。

## 安装

1. 下载最新的 `zygisk-frida-gadget.zip`
2. 通过 Magisk Manager 安装
3. 重启设备

## 配置说明

### module.prop

模块的基本信息：
- `id`: 模块 ID
- `name`: 模块名称
- `version`: 版本号
- `versionCode`: 版本代码
- `author`: 作者
- `description`: 描述

### customize.sh

模块安装时执行，用于检查环境和设置权限。

### service.sh

模块安装后执行的服务脚本，用于初始化和配置。

## 开发指南

### 添加 Hook

在 `src/zygisk.cpp` 中的 `MyModule` 类中实现相应的 hook 方法：

- `onLoad()`: 模块加载时调用
- `preAppSpecialize()`: App 启动前调用
- `postAppSpecialize()`: App 启动后调用
- `preServerSpecialize()`: Zygote 启动前调用
- `postServerSpecialize()`: Zygote 启动后调用

### 编译标准

- C++ 标准: C++20
- 最小 Android 版本: Android 10 (API 29)
- 架构: ARM64

## 许可证

MIT License

## 贡献

欢迎提交 Issue 和 Pull Request！