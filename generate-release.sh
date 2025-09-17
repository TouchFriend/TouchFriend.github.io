#!/bin/bash

# 确保在仓库根目录运行
if [ ! -f "Packages" ] || [ ! -f "Packages.gz" ]; then
    echo "Error: Packages or Packages.gz not found. Run 'dpkg-scanpackages deb /dev/null > Packages' and 'gzip -c9 Packages > Packages.gz' first."
    exit 1
fi

# 定义 Release 文件的元数据
ORIGIN="TouchFriend"
LABEL="TouchFriend's Repo"
SUITE="stable"
VERSION="1.0"
CODENAME="ios"
ARCHITECTURES="iphoneos-arm"
COMPONENTS="main"
DESCRIPTION="My iOS Jailbreak Repository"
DATE=$(date -u '+%a, %d %b %Y %H:%M:%S GMT')

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

echo "Release file generated successfully at $(pwd)/Release"