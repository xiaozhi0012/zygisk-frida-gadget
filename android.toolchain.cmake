# Android CMake Toolchain File
# 用于编译 Android NDK 项目

if(ANDROID_TOOLCHAIN)
    return()
endif()
set(ANDROID_TOOLCHAIN TRUE)

# 检查必需的变量
if(NOT ANDROID_ABI)
    message(FATAL_ERROR "ANDROID_ABI must be set")
endif()

if(NOT ANDROID_PLATFORM)
    message(FATAL_ERROR "ANDROID_PLATFORM must be set")
endif()

if(NOT ANDROID_NDK_ROOT)
    message(FATAL_ERROR "ANDROID_NDK_ROOT must be set")
endif()

# 提取 API 级别
string(REGEX MATCH "[0-9]+" ANDROID_API_LEVEL "${ANDROID_PLATFORM}")

# 设置编译器
set(ANDROID_TOOLCHAIN_ROOT "${ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/linux-x86_64")

# 设置编译器路径
set(CMAKE_C_COMPILER "${ANDROID_TOOLCHAIN_ROOT}/bin/clang")
set(CMAKE_CXX_COMPILER "${ANDROID_TOOLCHAIN_ROOT}/bin/clang++")

# ARM64 ABI 特定配置 - 使用 CMake 期望的处理器名称
if(ANDROID_ABI STREQUAL "arm64-v8a")
    set(ANDROID_LLVM_TRIPLE aarch64-linux-android)
    set(ANDROID_ARCH_NAME aarch64)  # CMake 期望的是 aarch64，不是 arm64
elseif(ANDROID_ABI STREQUAL "armeabi-v7a")
    set(ANDROID_LLVM_TRIPLE armv7a-linux-androideabi)
    set(ANDROID_ARCH_NAME armv7)
elseif(ANDROID_ABI STREQUAL "x86")
    set(ANDROID_LLVM_TRIPLE i686-linux-android)
    set(ANDROID_ARCH_NAME i686)
elseif(ANDROID_ABI STREQUAL "x86_64")
    set(ANDROID_LLVM_TRIPLE x86_64-linux-android)
    set(ANDROID_ARCH_NAME x86_64)
else()
    message(FATAL_ERROR "Unknown Android ABI: ${ANDROID_ABI}")
endif()

# 设置编译器标志
set(CMAKE_C_FLAGS "--target=${ANDROID_LLVM_TRIPLE}${ANDROID_API_LEVEL} ${CMAKE_C_FLAGS}")
set(CMAKE_CXX_FLAGS "--target=${ANDROID_LLVM_TRIPLE}${ANDROID_API_LEVEL} ${CMAKE_CXX_FLAGS}")

# NDK 库路径
set(ANDROID_SYSROOT "${ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/linux-x86_64/sysroot")
set(CMAKE_SYSROOT "${ANDROID_SYSROOT}")

# 系统相关设置
set(CMAKE_SYSTEM_NAME Android)
set(CMAKE_SYSTEM_VERSION ${ANDROID_API_LEVEL})
set(CMAKE_SYSTEM_PROCESSOR ${ANDROID_ARCH_NAME})

# 其他编译器设置
set(CMAKE_FIND_ROOT_PATH "${ANDROID_SYSROOT}")
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# C++ 标准库设置
if(ANDROID_STL STREQUAL "c++_shared")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++")
elseif(ANDROID_STL STREQUAL "c++_static")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++")
endif()

message(STATUS "Android Toolchain Configuration:")
message(STATUS "  ABI: ${ANDROID_ABI}")
message(STATUS "  API Level: ${ANDROID_API_LEVEL}")
message(STATUS "  Processor: ${CMAKE_SYSTEM_PROCESSOR}")
message(STATUS "  Compiler: ${CMAKE_C_COMPILER}")
message(STATUS "  STL: ${ANDROID_STL}")

