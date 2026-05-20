# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2026-05-20

### Added
- 初始化项目结构
- 创建版本号管理机制
- 建立Git仓库
- 创建核心功能模块（ProviderRouter、Billing、Payment）
- 集成支付宝国际支付
- 支持DeepSeek和Qwen供应商
- 实现Circuit Breaker和健康检查
- 实现Token精确计费系统
- 创建充值前端界面
- 添加Docker环境配置

### Fixed
- CRITICAL-1: 定义AlipayNotifyRequest结构体
- CRITICAL-2: 修复deserializeSnapshot反序列化
- CRITICAL-3: 修复mutex使用
- CRITICAL-4: 替换float64为int64（金额精度）
- CRITICAL-5: 添加重放攻击保护
- CRITICAL-6: 修复DeepSeek ConvertRerankRequest nil返回

### Security
- 添加支付回调重放攻击保护
- 实现签名验证机制
- 添加并发安全锁

[Unreleased]: https://github.com/AchieSun/overseas-api-platform/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/AchieSun/overseas-api-platform/releases/tag/v0.1.0
