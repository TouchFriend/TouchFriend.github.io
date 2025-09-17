#!/bin/bash

# 检查所需命令是否可用
command -v dpkg-scanpackages >/dev/null 2>&1 || { echo "错误：未找到 dpkg-scanpackages，请使用 'brew install dpkg' 安装。"; exit 1; }
command -v md5 >/dev/null 2>&1 || { echo "错误：未找到 md5 命令，macOS 应内置此命令。"; exit 1; }
command -v shasum >/dev/null 2>&1 || { echo "错误：未找到 shasum 命令，macOS 应内置此命令。"; exit 1; }
command -v stat >/dev/null 2>&1 || { echo "错误：未找到 stat 命令，macOS 应内置此命令。"; exit 1; }
command -v gzip >/dev/null 2>&1 || { echo "错误：未找到 gzip 命令，macOS 应内置此命令。"; exit 1; }

# 确保在仓库根目录运行，检查 Packages 和 Packages.gz 是否存在
if [ ! -f "Packages" ] || [ ! -f "Packages.gz" ]; then
    echo "错误：未找到 Packages 或 Packages.gz。请先运行 'dpkg-scanpackages debs /dev/null > Packages' 和 'gzip -c9 Packages > Packages.gz'。"
    exit 1
fi

# 定义 Release 文件的元数据
ORIGIN="TouchFriend"                    # 你的品牌或名字
LABEL="TouchFriend Repo"                # 用户在 Cydia/Sileo 中看到的仓库名称
SUITE="stable"                          # 仓库类型
VERSION="1.0"                           # 版本号
CODENAME="ios"                          # 代号
ARCHITECTURES="iphoneos-arm64"          # 目标架构，适用于现代设备
COMPONENTS="main"                       # 组件
DESCRIPTION="TouchFriend 的 iOS 越狱仓库，包含自定义 tweak 和主题"  # 仓库描述
DATE=$(date -u '+%a, %d %b %Y %H:%M:%S GMT')  # 当前 UTC 时间

# 计算哈希值和文件大小
MD5_PACKAGES=$(md5 -q Packages)
MD5_PACKAGES_GZ=$(md5 -q Packages.gz)
SHA1_PACKAGES=$(shasum -a 1 Packages | cut -d' ' -f1)
SHA1_PACKAGES_GZ=$(shasum -a 1 Packages.gz | cut -d' ' -f1)
SHA256_PACKAGES=$(shasum -a 256 Packages | cut -d' ' -f1)
SHA256_PACKAGES_GZ=$(shasum -a 256 Packages.gz | cut -d' ' -f1)
SIZE_PACKAGES=$(stat -f%z Packages)
SIZE_PACKAGES_GZ=$(stat -f%z Packages.gz)

# 生成 Release 文件
cat <<EOF > Release
Origin: $ORIGIN
Label: $LABEL
Suite: $SUITE
Version: $VERSION
Codename: $CODENAME
Architectures: $ARCHITECTURES
Components: $COMPONENTS
Description: $DESCRIPTION
Date: $DATE
MD5Sum:
 $MD5_PACKAGES $SIZE_PACKAGES Packages
 $MD5_PACKAGES_GZ $SIZE_PACKAGES_GZ Packages.gz
SHA1:
 $SHA1_PACKAGES $SIZE_PACKAGES Packages
 $SHA1_PACKAGES_GZ $SIZE_PACKAGES_GZ Packages.gz
SHA256:
 $SHA256_PACKAGES $SIZE_PACKAGES Packages
 $SHA256_PACKAGES_GZ $SIZE_PACKAGES_GZ Packages.gz
EOF

echo "Release 文件已成功生成：$(pwd)/Release"