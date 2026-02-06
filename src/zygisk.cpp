#include <jni.h>
#include <android/log.h>
#include "../include/zygisk.hpp"

#define LOG_TAG "ZygiskFridaGadget"
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)

class MyModule : public zygisk::ModuleBase {
public:
    void onLoad(zygisk::Api* api, JNIEnv* env) override {
        LOGI("Zygisk Frida Gadget module loaded");
        // 初始化代码
    }

    void preAppSpecialize(zygisk::AppSpecializeArgs* args) override {
        // App 启动前的 hook
        LOGI("preAppSpecialize called");
    }

    void postAppSpecialize(const zygisk::AppSpecializeArgs* args) override {
        // App 启动后的 hook
        LOGI("postAppSpecialize called");
    }
};

zygisk::ModuleBase *createModule() {
    return new MyModule();
}
