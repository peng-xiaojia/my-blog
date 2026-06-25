#!/usr/bin/env bash
# ============================================
# Hugo 博客 - 环境安装脚本 (macOS / Linux)
# ============================================
# 用法:
#   chmod +x scripts/setup.sh
#   ./scripts/setup.sh
# ============================================
set -euo pipefail

echo "========================================"
echo " Hugo 博客 - 环境初始化"
echo "========================================"

# --- 检测操作系统 ---
OS="$(uname -s)"
case "$OS" in
  Darwin)  OS_NAME="macOS" ;;
  Linux)   OS_NAME="Linux" ;;
  *)       OS_NAME="$OS" ;;
esac
echo "[INFO] 检测到系统: $OS_NAME"

# --- 1. 安装 Hugo Extended ---
echo ""
echo "[1/3] 检查 Hugo..."

if command -v hugo &>/dev/null; then
  HUGO_VER="$(hugo version 2>/dev/null || true)"
  echo "[OK] Hugo 已安装: $HUGO_VER"
else
  echo "[INFO] 正在安装 Hugo Extended..."
  case "$OS" in
    Darwin)
      if command -v brew &>/dev/null; then
        brew install hugo
      else
        echo "[ERROR] 请先安装 Homebrew: https://brew.sh"
        exit 1
      fi
      ;;
    Linux)
      # 尝试 snap / apt / 直接下载
      if command -v snap &>/dev/null; then
        sudo snap install hugo
      elif command -v apt-get &>/dev/null; then
        sudo apt-get update && sudo apt-get install -y hugo
      else
        # 通用: 下载预编译二进制
        echo "[INFO] 直接下载 Hugo..."
        curl -sL "https://github.com/gohugoio/hugo/releases/latest/download/hugo_extended_0.163.3_linux-amd64.tar.gz" | sudo tar -xz -C /usr/local/bin hugo
      fi
      ;;
  esac
  echo "[OK] Hugo 安装完成: $(hugo version)"
fi

# --- 2. 拉取主题子模块 ---
echo ""
echo "[2/3] 检查主题..."
if git submodule status themes/PaperMod 2>/dev/null | grep -q '^ '; then
  git submodule update --init --recursive
  echo "[OK] 主题已拉取"
else
  echo "[OK] 主题已存在"
fi

# --- 3. 安装 Git (如果缺失) ---
echo ""
echo "[3/3] 检查 Git..."
if command -v git &>/dev/null; then
  echo "[OK] Git 已安装: $(git --version)"
else
  case "$OS" in
    Darwin) brew install git ;;
    Linux)  sudo apt-get install -y git ;;
  esac
  echo "[OK] Git 安装完成"
fi

echo ""
echo "========================================"
echo " ✅ 环境初始化完成！"
echo "========================================"
echo ""
echo "快速开始："
echo "  hugo server --buildDrafts    # 启动本地预览"
echo "  hugo new posts/xxx.md        # 创建新文章"
echo "  ./scripts/publish.sh         # 一键发布"
