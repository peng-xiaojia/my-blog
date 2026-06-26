# hugostart — 个人博客项目手册

## 项目概述

基于 **Hugo** 静态网站生成器 + **PaperMod** 主题的个人博客。内容使用 Markdown 编写，通过 Git 管理版本，CI/CD 自动部署到 GitHub Pages。

- **仓库地址**: <https://github.com/peng-xiaojia/blog>
- **线上地址**: <https://peng-xiaojia.github.io/blog/>
- **技术栈**: Hugo v0.163+ Extended, PaperMod, GitHub Actions

---

## 快速开始（新环境初始化）

> 💡 在任何有 Git 和智能体的新机器上，直接运行对应脚本即可完成环境搭建。

### 自动安装（推荐）
| 平台 | 脚本 |
|------|------|
| **Windows** | 双击 `scripts\setup.bat`（或以管理员身份运行） |
| **macOS** | `./scripts/setup.sh` |
| **Linux** | `./scripts/setup.sh` |

### 手动安装
| 工具 | 安装方式 |
|------|----------|
| **Hugo Extended** ≥ 0.146 | `winget install Hugo.Hugo.Extended` (Win) / `brew install hugo` (Mac) / `snap install hugo` (Linux) |
| **Git** | `winget install Git.Git` (Win) / `brew install git` (Mac) / `apt install git` (Linux) |
| **主题** | `git submodule update --init --recursive` |

### 验证环境
```bash
hugo version    # 应显示 v0.146+ extended
git --version
hugo server --buildDrafts    # 启动后访问 http://localhost:1313/
```

---

## 项目结构

```
hugostart/
├── hugo.toml                    # 🔧 主配置：站点名、baseURL、主题参数
├── .gitignore                   # Git 忽略规则
├── .gitmodules                  # Git 子模块（主题）
│
├── content/                     # ✍️ 所有内容写在这里
│   ├── posts/                   #    博客文章 (.md)
│   │   └── hello-world.md       #    示例：带 slug 的文章
│   ├── about.md                 #    关于页面
│   └── search.md                #    搜索页面 (layout: search)
│
├── archetypes/default.md        # 📄 新文章模板（含 slug 自动生成）
├── assets/                      # 🎨 SCSS/TS 等需要编译的资源
├── static/                      # 🖼️ 静态文件（图片、favicon、CSS/JS）
│
├── themes/PaperMod/             # 🎨 主题（Git 子模块，不要直接修改）
├── layouts/                     # 📐 自定义模板（覆盖主题用）
├── data/                        # 📊 数据文件 (JSON/YAML)
├── i18n/                        # 🌐 国际化翻译
│
├── scripts/                     # 🚀 一键脚本
│   ├── setup.sh / setup.bat     #    环境安装
│   └── publish.sh / publish.bat #    一键发布
│
└── .github/workflows/
    └── deploy.yml               # 🤖 CI/CD：自动部署到 GitHub Pages
```

---

## 日常写作工作流

### 写一篇新文章
```bash
# 1. 拉取最新代码（多人/多设备必备）
git pull

# 2. 创建新文章
hugo new posts/my-new-post.md
# 文件生成在 content/posts/my-new-post.md

# 3. 编辑文章
# 用任意编辑器打开 content/posts/my-new-post.md
# 将 draft: true 改为 draft: false 即可发布

# 4. 本地预览（含草稿）
hugo server --buildDrafts
# 浏览器打开 http://localhost:1313/

# 5. 满意后发布
./scripts/publish.sh "post: 新文章标题"
# 或 Windows: scripts\publish.bat "post: 新文章标题"
```

### 一键脚本做了什么
```
publish.sh / publish.bat:
  1. git pull         → 拉取远程更新，避免冲突
  2. hugo --minify    → 构建压缩版站点到 public/
  3. git commit       → 提交所有变更
  4. git push         → 推送到 GitHub
  → GitHub Actions 自动部署
```

---

## Front Matter 参考

每篇文章顶部的 YAML 配置：

```yaml
---
title: '文章标题'
date: '2026-06-25T15:07:34+08:00'
draft: false           # true = 草稿（不发布），false = 公开
slug: 'my-post'        # URL 友好名称（必填！否则中文标题会变乱码）
categories: ['技术']    # 分类
tags: ['hugo', '博客'] # 标签
description: '文章摘要，用于 SEO 和列表展示'
series: ['系列名']      # 系列文章（可选）
---
```

### ⚠️ 重要：slug 规则
- `slug` 必须是**英文 + 连字符**，如 `hello-world`
- 不设置 slug 时，中文标题会被 URL 编码成一长串 `%E6%...`
- 模板已自动配置 `slug: '{{ .File.ContentBaseName }}'`（取文件名不含扩展名）

---

## 部署架构

```
┌─────────┐   git push    ┌──────────┐   GitHub Actions   ┌──────────────┐
│ 本地编写  │ ────────────→ │  GitHub  │ ─────────────────→ │ GitHub Pages │
│ (Markdown)│              │  Repo    │   hugo --minify    │ (静态网站)    │
└─────────┘               └──────────┘                    └──────────────┘
```

- **触发条件**: 推送到 `master` 分支
- **构建环境**: `ubuntu-latest` + Hugo Extended (latest)
- **部署目标**: GitHub Pages (`gh-pages` 分支由 Action 自动管理)
- **手动触发**: 在 Actions 页面点击 "Run workflow"

---

## 多设备协同工作

```
  公司电脑 ──git pull/push──→  GitHub  ←──git pull/push──  家里电脑
                                   ↑
                              笔记本 ──┘
```

### 黄金规则
1. **写前先 pull** — 每次开始写作前 `git pull`
2. **写完就 push** — 一篇文章完成立即推送，不堆积
3. **不同设备不同文件** — 尽量不在两台设备上编辑同一篇文章
4. **分工写** — 文章是独立的 `.md` 文件，天然支持多人并行写作

### 冲突处理
如果出现冲突（极少），直接编辑冲突的 `.md` 文件：
```bash
git pull --rebase    # 遇到冲突时
# 编辑冲突文件，保留想要的内容
git add .
git rebase --continue
git push
```

---

## 自定义配置

### 修改个人信息
编辑 `hugo.toml`:
```toml
[params]
  author = '你的名字'
  description = '你的描述'
  # 社交链接（去掉注释即可启用）
  socialIcons:
    - name = 'github'
      url = 'https://github.com/你的用户名'
```

### 添加头像
将 `avatar.png` 放入 `static/` 目录，然后在 `hugo.toml` 添加：
```toml
[params]
  profileMode:
    enabled = true
    title = '你好 👋'
    imageUrl = '/avatar.png'
```

### 更换域名
1. 修改 `hugo.toml` 中 `baseURL = 'https://你的域名/'`
2. GitHub Pages 设置中添加自定义域名
3. 如果有 CNAME 文件，放入 `static/CNAME`

### 开启评论
PaperMod 支持多种评论系统，在 `hugo.toml` 的 `[params]` 中添加：
```toml
# Giscus（推荐，基于 GitHub Discussions）
[params.giscus]
  repo = 'peng-xiaojia/blog'
  repoId = '你的 repo ID'
  category = 'Announcements'
  categoryId = '你的 category ID'
```

---

## 迁移到 Gitea

本项目设计时已考虑 Gitea 兼容性：

### Gitea Actions（兼容 GitHub Actions）
1. `.github/workflows/deploy.yml` → 复制到 `.gitea/workflows/deploy.yml`
2. 内容基本无需改动（Gitea Actions 兼容 GitHub Actions 语法）
3. 唯一区别：`${{ secrets.GITHUB_TOKEN }}` → Gitea 中对应 `${{ secrets.GITEA_TOKEN }}`

### Gitea Pages 部署
```yaml
# 关键改动
- name: Deploy to Gitea Pages
  uses: peaceiris/actions-gh-pages@v3  # 仍然可用
  with:
    gitea_token: ${{ secrets.GITEA_TOKEN }}  # 改用 gitea_token
    publish_dir: ./public
    external_repository: your-gitea-server/your-repo  # Gitea Pages 仓库
```

### 一键切换远程仓库
```bash
# 查看当前远程
git remote -v

# 切换到 Gitea
git remote set-url origin https://your-gitea.com/username/blog.git

# 或同时保留两个远程
git remote add gitea https://your-gitea.com/username/blog.git
git push gitea master
```

---

## 常用命令速查

| 命令 | 说明 |
|------|------|
| `hugo server --buildDrafts` | 启动本地预览 (含草稿) |
| `hugo server` | 启动本地预览 (仅已发布) |
| `hugo new posts/xxx.md` | 创建新文章 |
| `hugo --minify` | 构建生产版本到 `public/` |
| `hugo new about.md` | 创建新页面 |
| `hugo new posts/xxx.md --editor vim` | 创建并用指定编辑器打开 |
| `git pull && hugo new posts/xxx.md` | 拉取更新后创建文章 |
| `./scripts/publish.sh "msg"` | 一键发布 (macOS/Linux) |
| `scripts\publish.bat "msg"` | 一键发布 (Windows) |

---

## 故障排除

| 问题 | 解决方法 |
|------|----------|
| `hugo: command not found` | 运行 `scripts/setup.sh` 或 `scripts\setup.bat` |
| 主题样式异常 | `git submodule update --init --recursive` |
| slug 出现乱码 | 设置文章 `slug` 为英文 |
| 页面 404 | 检查 `draft: false`，或文章 slug 是否正确 |
| 部署后未更新 | 检查 Actions 页面是否有报错，确认 push 到了 master 分支 |
| `git push` 被拒 | 先 `git pull --rebase` 再 `git push` |
| 本地预览卡死 | `Ctrl+C` 停止后，`rm -rf public/` 再重试 |
