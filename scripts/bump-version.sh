#!/bin/bash
# 版本号管理脚本 for Linux/Mac
# 使用方法: ./bump-version.sh [major|minor|patch]

set -e

# 获取当前版本号
CURRENT_VERSION=$(cat VERSION | tr -d '[:space:]')
echo "当前版本号: $CURRENT_VERSION"

# 解析版本号
MAJOR=$(echo $CURRENT_VERSION | cut -d. -f1)
MINOR=$(echo $CURRENT_VERSION | cut -d. -f2)
PATCH=$(echo $CURRENT_VERSION | cut -d. -f3)

# 检查参数
if [ $# -eq 0 ]; then
    echo "用法: ./bump-version.sh [major|minor|patch]"
    echo "  major - 递增主版本号 (如: 1.2.3 -> 2.0.0)"
    echo "  minor - 递增次版本号 (如: 1.2.3 -> 1.3.0)"
    echo "  patch - 递增修订号 (如: 1.2.3 -> 1.2.4)"
    exit 1
fi

# 计算新版本号
case $1 in
    major)
        NEW_MAJOR=$((MAJOR + 1))
        NEW_VERSION="${NEW_MAJOR}.0.0"
        echo "递增主版本号: $CURRENT_VERSION -> $NEW_VERSION"
        ;;
    minor)
        NEW_MINOR=$((MINOR + 1))
        NEW_VERSION="${MAJOR}.${NEW_MINOR}.0"
        echo "递增次版本号: $CURRENT_VERSION -> $NEW_VERSION"
        ;;
    patch)
        NEW_PATCH=$((PATCH + 1))
        NEW_VERSION="${MAJOR}.${MINOR}.${NEW_PATCH}"
        echo "递增修订号: $CURRENT_VERSION -> $NEW_VERSION"
        ;;
    *)
        echo "错误: 无效参数 '$1'"
        echo "用法: ./bump-version.sh [major|minor|patch]"
        exit 1
        ;;
esac

# 确认
read -p "确认更新版本号到 $NEW_VERSION? [y/N]: " CONFIRM
if [[ ! $CONFIRM =~ ^[Yy]$ ]]; then
    echo "已取消"
    exit 0
fi

# 更新VERSION文件
echo "$NEW_VERSION" > VERSION
echo "已更新 VERSION 文件"

# 更新CHANGELOG
cat >> CHANGELOG.md << EOF

## [$NEW_VERSION] - $(date +%Y-%m-%d)

### Added
- 添加新功能

### Changed
- 修改现有功能

### Fixed
- 修复问题

[$NEW_VERSION]: https://github.com/yourusername/new-api/releases/tag/v$NEW_VERSION
EOF

echo "已更新 CHANGELOG.md"

# Git操作
echo ""
echo "建议执行以下Git命令："
echo "  git add VERSION CHANGELOG.md"
echo "  git commit -m \"chore(release): bump version to v$NEW_VERSION\""
echo "  git tag v$NEW_VERSION"
echo "  git push origin main --tags"

echo ""
echo "版本号已更新到 $NEW_VERSION!"
