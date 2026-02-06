// Zygisk API Header
// 这是 Zygisk 模块的头文件

#pragma once

#include <cstdint>
#include <memory>
#include <vector>

namespace zygisk {

// Zygisk API 版本
static constexpr int ZYGISK_API_VERSION = 1;

// 前向声明
class Api;

// 模块基类
class ModuleBase {
public:
    virtual ~ModuleBase() = default;
    
    // 模块初始化
    virtual void onLoad(Api* api, JNIEnv* env) = 0;
    
    // 预加载 hook
    virtual void preAppSpecialize(AppSpecializeArgs* args) {}
    
    // 后 App 初始化 hook
    virtual void postAppSpecialize(const AppSpecializeArgs* args) {}
    
    // 预加载 Zygote
    virtual void preServerSpecialize(ServerSpecializeArgs* args) {}
    
    // 后 Zygote 初始化
    virtual void postServerSpecialize(const ServerSpecializeArgs* args) {}
};

} // namespace zygisk

// 导出符号
extern "C" {
    [[maybe_unused]] zygisk::ModuleBase *createModule();
}
