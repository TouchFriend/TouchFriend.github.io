#!/bin/bash

# 更新 Packages 和 Packages.bz2
dpkg-scanpackages -m debs > Packages
rm Packages.bz2
bzip2 -k Packages

# 提交更改
git add .
git commit -m "更新 Cydia 源"
git push origin main --verbose

echo "仓库已更新，等待 GitHub Pages 部署（约 5-10 分钟）。"