#!/usr/bin/env bash
# ============================================
# Hugo 博客 - 一键发布脚本 (macOS / Linux)
# ============================================
# 用法:
#   chmod +x scripts/publish.sh
#   ./scripts/publish.sh "新文章的提交信息"
#
# 工作流:
#   1. 拉取 Gitea 最新代码
#   2. 构建 Hugo 站点
#   3. 提交变更
#   4. 推送到 Gitea（代码）和 GitHub（触发自动部署）
# ============================================
set -euo pipefail

COMMIT_MSG="${1:-post: 更新博客文章}"

echo "========================================"
echo " Hugo 博客 - 一键发布"
echo "========================================"

# --- 1. 拉取 Gitea 最新代码 ---
echo "[1/5] 拉取 Gitea 最新代码..."
git pull --rebase gitea master 2>/dev/null || echo "[INFO] 无法拉取 Gitea，继续..."

# --- 2. 构建站点 ---
echo "[2/5] 构建站点..."
hugo --minify
echo "[OK] 构建完成 -> public/"

# --- 3. 提交变更 ---
echo "[3/5] 提交变更..."
git add -A

if git diff --cached --quiet; then
  echo "[INFO] 没有需要提交的变更"
else
  git commit -m "$COMMIT_MSG"
  echo "[OK] 已提交: $COMMIT_MSG"
fi

# --- 4. 推送到 Gitea（代码托管） ---
echo "[4/5] 推送到 Gitea..."
git push gitea master 2>/dev/null || echo "[WARN] Gitea 推送失败，请检查网络"

# --- 5. 推送到 GitHub（触发 Actions 部署） ---
echo "[5/5] 推送到 GitHub..."
git push origin master 2>/dev/null || echo "[WARN] GitHub SSH 推送失败，尝试 HTTPS..."

echo ""
echo "========================================"
echo " ✅ 发布完成！"
echo "========================================"
echo ""
echo "📦 代码已推送到:  Gitea"
echo "🚀 部署已触发:    GitHub Actions → GitHub Pages"
echo "🔗 线上地址:      https://peng-xiaojia.github.io/my-blog/"
