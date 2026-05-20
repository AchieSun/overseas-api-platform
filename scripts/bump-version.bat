@echo off
chcp 65001 >nul
REM 版本号管理脚本 for Windows
REM 使用方法: bump-version.bat [major|minor|patch]

setlocal enabledelayedexpansion

REM 获取当前版本号
for /f "tokens=*" %%a in (VERSION) do set CURRENT_VERSION=%%a
set CURRENT_VERSION=%CURRENT_VERSION: =%

echo 当前版本号: %CURRENT_VERSION%

REM 解析版本号
for /f "tokens=1,2,3 delims=." %%a in ("%CURRENT_VERSION%") do (
    set MAJOR=%%a
    set MINOR=%%b
    set PATCH=%%c
)

REM 检查参数
if "%1"=="" (
    echo 用法: bump-version.bat [major|minor|patch]
    echo   major - 递增主版本号 (如: 1.2.3 -> 2.0.0)
    echo   minor - 递增次版本号 (如: 1.2.3 -> 1.3.0)
    echo   patch - 递增修订号 (如: 1.2.3 -> 1.2.4)
    exit /b 1
)

if "%1"=="major" (
    set /a NEW_MAJOR=MAJOR+1
    set NEW_VERSION=!NEW_MAJOR!.0.0
    echo 递增主版本号: %CURRENT_VERSION% -> !NEW_VERSION!
) else if "%1"=="minor" (
    set /a NEW_MINOR=MINOR+1
    set NEW_VERSION=!MAJOR!.!NEW_MINOR!.0
    echo 递增次版本号: %CURRENT_VERSION% -> !NEW_VERSION!
) else if "%1"=="patch" (
    set /a NEW_PATCH=PATCH+1
    set NEW_VERSION=!MAJOR!.!MINOR!.!NEW_PATCH!
    echo 递增修订号: %CURRENT_VERSION% -> !NEW_VERSION!
) else (
    echo 错误: 无效参数 "%1"
    echo 用法: bump-version.bat [major|minor|patch]
    exit /b 1
)

REM 确认
set /p CONFIRM=确认更新版本号到 !NEW_VERSION!? [y/N]: 
if /i not "!CONFIRM!"=="y" (
    echo 已取消
    exit /b 0
)

REM 更新VERSION文件
echo !NEW_VERSION! > VERSION
echo 已更新 VERSION 文件

REM 更新CHANGELOG
echo. >> CHANGELOG.md
echo ## [!NEW_VERSION!] - %date% >> CHANGELOG.md
echo. >> CHANGELOG.md
echo ### Added >> CHANGELOG.md
echo - 添加新功能 >> CHANGELOG.md
echo. >> CHANGELOG.md
echo ### Changed >> CHANGELOG.md
echo - 修改现有功能 >> CHANGELOG.md
echo. >> CHANGELOG.md
echo ### Fixed >> CHANGELOG.md
echo - 修复问题 >> CHANGELOG.md
echo. >> CHANGELOG.md
echo [!NEW_VERSION!]: https://github.com/yourusername/new-api/releases/tag/v!NEW_VERSION! >> CHANGELOG.md

echo 已更新 CHANGELOG.md

REM Git操作
echo.
echo 建议执行以下Git命令：
echo   git add VERSION CHANGELOG.md
echo   git commit -m "chore(release): bump version to v!NEW_VERSION!"
echo   git tag v!NEW_VERSION!
echo   git push origin main --tags

echo.
echo 版本号已更新到 !NEW_VERSION!
