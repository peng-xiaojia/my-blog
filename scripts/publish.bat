@echo off
REM ============================================
REM Hugo 博客 - 一键发布脚本 (Windows)
REM ============================================
REM 用法:
REM   scripts\publish.bat
REM   scripts\publish.bat "自定义提交信息"
REM
REM 工作流:
REM   1. 拉取 Gitea 最新代码
REM   2. 构建 Hugo 站点
REM   3. 提交变更
REM   4. 推送到 Gitea（代码）+ GitHub（自动部署）
REM ============================================
setlocal enabledelayedexpansion

if "%~1"=="" (
  set "COMMIT_MSG=post: 更新博客文章"
) else (
  set "COMMIT_MSG=%~1"
)

echo ========================================
echo  Hugo 博客 - 一键发布
echo ========================================

REM --- 1. 拉取 Gitea 最新代码 ---
echo [1/5] 拉取 Gitea 最新代码...
git pull --rebase gitea master 2>nul || echo [INFO] 无法拉取 Gitea，继续...

REM --- 2. 构建站点 ---
echo [2/5] 构建站点...
hugo --minify
if %ERRORLEVEL% NEQ 0 (
  echo [ERROR] 构建失败，请检查错误信息
  pause
  exit /b 1
)
echo [OK] 构建完成 -^> public\

REM --- 3. 提交变更 ---
echo [3/5] 提交变更...
git add -A

git diff --cached --quiet 2>nul
if %ERRORLEVEL% EQU 0 (
  echo [INFO] 没有需要提交的变更
) else (
  git commit -m "%COMMIT_MSG%"
  echo [OK] 已提交: %COMMIT_MSG%
)

REM --- 4. 推送到 Gitea ---
echo [4/5] 推送到 Gitea...
git push gitea master 2>nul
if %ERRORLEVEL% NEQ 0 (
  echo [WARN] Gitea 推送失败，请检查网络
)

REM --- 5. 推送到 GitHub ---
echo [5/5] 推送到 GitHub（触发部署）...
git push origin master 2>nul
if %ERRORLEVEL% NEQ 0 (
  echo [WARN] GitHub 推送失败
)

echo.
echo ========================================
echo  ✅ 发布完成！
echo ========================================
echo.
echo 📦 代码已推送到:  Gitea
echo 🚀 部署已触发:    GitHub Actions
echo 🔗 线上地址:      https://peng-xiaojia.github.io/blog/

pause
