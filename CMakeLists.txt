cmake_minimum_required(VERSION 3.21)
project(zygisk-frida-gadget)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 添加头文件目录
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)

# 获取所有源文件
file(GLOB_RECURSE SOURCES "src/*.cpp")

# 创建共享库
add_library(zygisk SHARED ${SOURCES})

# 设置输出目录
set_target_properties(zygisk PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/${ANDROID_ABI}"
    SONAME "zygisk.so"
)

# 链接必要的库
target_link_libraries(zygisk
    log
)

# 设置编译选项
target_compile_options(zygisk PRIVATE
    -fvisibility=hidden
    -fvisibility-inlines-hidden
    -Wall
    -Wextra
    -Werror=format
    -U_FORTIFY_SOURCE
    -D_FORTIFY_SOURCE=2
)

# Android 特定设置
if(ANDROID)
    target_compile_options(zygisk PRIVATE
        -fno-exceptions
        -fno-rtti
    )
endif()
