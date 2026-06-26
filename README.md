# 我的博客

> 基于 [Hugo](https://gohugo.io/) + [PaperMod](https://github.com/adityatelange/hugo-PaperMod) 的个人博客。

[![Deploy](https://github.com/peng-xiaojia/blog/actions/workflows/deploy.yml/badge.svg)](https://github.com/peng-xiaojia/blog/actions/workflows/deploy.yml)

🔗 **线上地址**：https://peng-xiaojia.github.io/blog/

---

## 架构

```
┌──────────┐   git push     ┌──────────┐   自动部署     ┌──────────────┐
│  本地写作  │ ────────────→ │  Gitea   │               │  GitHub Pages │
│ (Markdown)│               │ (代码托管) │               │  (静态网站)    │
└──────────┘               └──────────┘               └──────────────┘
                                  │                          ↑
                                  │ git push                 │
                                  └──────────────────────────┘
                                         触发 GitHub Actions
```

- **代码**：Gitea（国内直连，速度快）
- **部署**：GitHub Actions → GitHub Pages（免费 + 全球 CDN）

---

## 快速开始

### 环境要求
- Hugo Extended ≥ 0.146
- Git

### 安装

```bash
# 克隆仓库（Gitea）
git clone http://121.43.230.181:8102/jjia/blog.git
cd blog

# 拉取主题
git submodule update --init --recursive

# 添加 GitHub 远程（部署用）
git remote add origin git@github.com:peng-xiaojia/blog.git
```

**Windows 用户**：双击运行 `scripts\setup.bat` 自动安装 Hugo。

**macOS / Linux 用户**：运行 `./scripts/setup.sh` 自动安装 Hugo。

### 写文章

```bash
# 创建新文章
hugo new posts/my-post.md

# 编辑 content/posts/my-post.md
# 把 draft: true 改为 draft: false

# 本地预览
hugo server --buildDrafts
# 打开 http://localhost:1313/
```

### 发布

```bash
# 一键构建 + 推送到 Gitea 和 GitHub
./scripts/publish.sh "新文章标题"     # macOS / Linux
scripts\publish.bat "新文章标题"      # Windows
```

---

## 项目结构

```
blog/
├── content/                 # 文章目录（Markdown）
│   ├── posts/               #   博客文章
│   ├── about.md             #   关于页
│   └── search.md            #   搜索页
├── archetypes/default.md    # 文章模板
├── static/                  # 静态文件（图片等）
├── themes/PaperMod/         # 主题（Git 子模块）
├── scripts/                 # 一键脚本
│   ├── setup.sh / setup.bat     # 环境安装
│   └── publish.sh / publish.bat # 一键发布
├── .github/workflows/       # GitHub Actions 自动部署
├── hugo.toml                # 站点配置
├── CLAUDE.md                # AI 智能体手册
└── README.md
```

---

## 多设备写作

1. 每台电脑 `git clone` 一次
2. 写前 `git pull`，写完 `git push`
3. 不同设备写不同文件，避免冲突

---

## 自定义

| 需求 | 操作 |
|------|------|
| 改头像 | `static/` 放 `avatar.png` |
| 改标题 | 编辑 `hugo.toml` → `title` |
| 改域名 | `hugo.toml` → `baseURL` |
| 开评论 | `hugo.toml` → `[params.giscus]` |
| 换主题 | 参考 [Hugo Themes](https://themes.gohugo.io/) |

详细配置见 [CLAUDE.md](CLAUDE.md)。

---

## 技术栈

- **框架**：Hugo v0.163 Extended
- **主题**：PaperMod
- **CI/CD**：GitHub Actions
- **代码托管**：Gitea
- **部署**：GitHub Pages
