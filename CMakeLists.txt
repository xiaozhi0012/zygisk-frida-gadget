cmake_minimum_required(VERSION 3.21)
project(zygisk-frida-gadget LANGUAGES CXX C)

# 编译标准
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)

# 检查编译器是否已设置（Android 交叉编译情况）
if(ANDROID)
    message(STATUS "Building for Android")
    message(STATUS "  ABI: ${ANDROID_ABI}")
    message(STATUS "  Platform: ${ANDROID_PLATFORM}")
    message(STATUS "  STL: ${ANDROID_STL}")
else()
    message(STATUS "Not building for Android")
endif()

# 添加头文件目录
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)

# 获取所有源文件
file(GLOB_RECURSE SOURCES "src/*.cpp")

if(NOT SOURCES)
    message(FATAL_ERROR "No source files found in src/")
endif()

message(STATUS "Found sources: ${SOURCES}")

# 创建共享库
add_library(zygisk SHARED ${SOURCES})

# 设置输出目录
set_target_properties(zygisk PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/${ANDROID_ABI}"
    SONAME "zygisk.so"
    PREFIX "lib"
    SUFFIX ".so"
)

# 链接库 (仅在 Android 上)
if(ANDROID)
    target_link_libraries(zygisk PRIVATE log)
    message(STATUS "Linked with Android log library")
endif()

# 编译选项
target_compile_options(zygisk PRIVATE
    -Wall
    -Wextra
    -Werror=format
    -fvisibility=hidden
    -fvisibility-inlines-hidden
    -U_FORTIFY_SOURCE
    -D_FORTIFY_SOURCE=2
)

# Android 特定选项
if(ANDROID)
    target_compile_options(zygisk PRIVATE
        -fno-exceptions
        -fno-rtti
    )
    
    # 检查 Android API 级别
    if(NOT ANDROID_PLATFORM EQUAL 0)
        if(ANDROID_PLATFORM LESS 29)
            message(FATAL_ERROR "Minimum Android API level is 29, got ${ANDROID_PLATFORM}")
        endif()
    endif()
    
    message(STATUS "Zygisk module will be built for ${ANDROID_ABI} (Android ${ANDROID_PLATFORM})")
endif()

# 输出编译信息
message(STATUS "Output library: ${CMAKE_BINARY_DIR}/lib/${ANDROID_ABI}/libzygisk.so")
