# 版本号管理规范

## 版本号格式

本项目采用 [Semantic Versioning](https://semver.org/spec/v2.0.0.html) 语义化版本号规范：

```
MAJOR.MINOR.PATCH

例如：1.2.3
- MAJOR (1): 主版本号，不兼容的API修改
- MINOR (2): 次版本号，向下兼容的功能新增
- PATCH (3): 修订号，向下兼容的问题修复
```

## 版本号规则

### MAJOR 版本号
- **何时递增**: 当进行不兼容的API更改时
- **示例**: 
  - 移除或修改现有的API端点
  - 更改数据库结构导致不兼容
  - 重大架构重构

### MINOR 版本号
- **何时递增**: 当添加向下兼容的新功能时
- **示例**:
  - 添加新的供应商适配器
  - 添加新的支付方式
  - 添加新的管理功能

### PATCH 版本号
- **何时递增**: 当进行向下兼容的问题修复时
- **示例**:
  - 修复bug
  - 修复安全漏洞
  - 性能优化

## 预发布版本

使用以下后缀标识预发布版本：

- `alpha`: 内部测试版本，不稳定
- `beta`: 公开测试版本，基本功能可用
- `rc` (Release Candidate): 候选版本，即将正式发布

示例：
```
1.0.0-alpha.1
1.0.0-beta.2
1.0.0-rc.1
```

## 版本发布流程

### 1. 准备阶段
- [ ] 确保所有功能已完成并测试通过
- [ ] 更新 `CHANGELOG.md`
- [ ] 更新 `VERSION` 文件
- [ ] 检查并更新依赖项

### 2. 发布阶段
```bash
# 1. 创建发布分支
git checkout -b release/v1.2.3

# 2. 更新版本号
echo "1.2.3" > VERSION

# 3. 更新CHANGELOG
# 编辑 CHANGELOG.md，将[Unreleased]内容移到新版本下

# 4. 提交更改
git add VERSION CHANGELOG.md
git commit -m "chore(release): prepare for v1.2.3"

# 5. 合并到主分支
git checkout main
git merge release/v1.2.3

# 6. 打标签
git tag -a v1.2.3 -m "Release version 1.2.3"

# 7. 推送
git push origin main
git push origin v1.2.3
```

### 3. 发布后
- [ ] 创建GitHub Release
- [ ] 部署到生产环境
- [ ] 通知相关方
- [ ] 监控生产环境

## 版本号使用场景

### 代码中读取版本号
```go
// 读取版本号
version, err := os.ReadFile("VERSION")
if err != nil {
    version = []byte("unknown")
}
fmt.Printf("Version: %s\n", strings.TrimSpace(string(version)))
```

### API中暴露版本号
```go
// /api/version 端点
func GetVersion(c *gin.Context) {
    version, _ := os.ReadFile("VERSION")
    c.JSON(200, gin.H{
        "version": strings.TrimSpace(string(version)),
        "build_time": buildTime,
        "git_commit": gitCommit,
    })
}
```

### Docker镜像标签
```dockerfile
# Dockerfile
ARG VERSION=latest
LABEL version="${VERSION}"
```

## 版本兼容性

### API兼容性
- **MAJOR版本不变**: API保持兼容
- **MINOR版本更新**: 添加新端点，不改变现有端点
- **PATCH版本更新**: 仅修复bug，不改变API行为

### 数据库兼容性
- **MAJOR版本更新**: 可能需要数据库迁移
- **MINOR/PATCH版本**: 自动迁移，向下兼容

## 特殊情况

### 紧急修复 (Hotfix)
当生产环境发现严重bug需要立即修复时：

```bash
# 1. 从最新的tag创建hotfix分支
git checkout -b hotfix/v1.2.4 v1.2.3

# 2. 修复问题并提交
git commit -m "fix: resolve critical security issue"

# 3. 打标签并发布
git tag v1.2.4
git push origin v1.2.4
```

### 版本回滚
如果新版本出现问题，可以快速回滚：

```bash
# 回滚到上一个版本
git checkout v1.2.2
git checkout -b rollback/v1.2.2
```

## 自动化工具

### 版本号自动递增脚本
使用 `scripts/bump-version.sh` 自动递增版本号。

### CI/CD集成
在GitHub Actions/GitLab CI中自动：
- 检查版本号格式
- 自动生成CHANGELOG
- 自动打标签
- 自动构建并推送Docker镜像

## 参考文档

- [Semantic Versioning 规范](https://semver.org/spec/v2.0.0.html)
- [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
- [Conventional Commits](https://www.conventionalcommits.org/)
