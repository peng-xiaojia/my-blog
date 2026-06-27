---
title: '零成本部署个人网站：从 GitHub Pages 到 Cloudflare Pages'
date: '2026-06-27T22:00:00+08:00'
draft: false
slug: 'zero-cost-deploy'
categories: ['技术']
tags: ['部署', 'GitHub', '静态网站', '教程']
description: '用 Git 存代码，靠 Pages 服务部署，一分钱不花。'
series: []
---

自己搭博客或者个人网站，最烦的不是写代码，是部署。

买服务器要钱，配 Nginx 要时间，搞 HTTPS 证书要折腾。对只是想写点东西的人来说，太重了。

现在有几个平台可以把这件事简化到几乎零成本——代码推上去，自动部署，自带域名和 HTTPS。用好了，一条命令就能让网站上线。

这篇文章把这几种方案捋一遍。

## 核心思路

不管用哪个平台，流程都一样：

1. 本地写代码，用 Git 管理。
2. 推到 GitHub 或 Gitee。
3. 平台自动检测到推送，触发构建和部署。

对静态网站——HTML、CSS、JS，或者 Hugo、Hexo、VuePress 这类生成的——前端资源编译完就是一堆静态文件，不需要服务器跑程序。这些平台天然适合。

如果需要后端逻辑，情况就不一样了。后面细说。

## GitHub Pages

最老牌的一个。GitHub 自带，每个仓库都能开 Pages。

操作：
1. 在仓库 Settings → Pages 里选分支和目录。
2. 推送代码，自动部署。
3. 默认域名是 `用户名.github.io/仓库名`，也可以绑自己的域名。

限制：
- 纯静态。不支持任何服务端代码。
- 编译过程只能用 GitHub Actions 跑，免费额度每月 2000 分钟，个人用绰绰有余。
- 单个文件不能超过 1GB，站点总大小不超过 1GB。

适合：纯静态博客、文档站、作品集。

## Gitee Pages

国内版 GitHub Pages，Gitee 提供。

操作类似，但区别比较大：
- 需要在 Gitee 上实名认证才能开通。
- 部署需要手动点"更新"按钮，不能像 GitHub 那样推送自动触发。除非买 Gitee Pages Pro。
- 绑定自定义域名也需要 Pro 版。

好处是访问速度快，毕竟服务器在国内。没备案的域名也能用。

适合：面向国内读者的纯静态站，能接受手动部署。

## Netlify

比 Pages 多了很多东西。

操作：
1. 用 GitHub 账号登录 Netlify，选仓库。
2. 设置构建命令和输出目录。比如 Hugo 就是 `hugo` + `public/`。
3. 推送代码，Netlify 自动构建部署。

Netlify 有几个实际有用的功能：
- **表单处理**：在 HTML 里加 `netlify` 属性，就能收表单数据，不需要后端。
- **Functions**：可以写简单的服务端逻辑，比如处理 webhook、发邮件。底层是 AWS Lambda。免费额度每月 125K 次请求。
- **重定向和 Header 配置**：一个 `_redirects` 文件搞定。
- **Branch Deploy**：每个分支自动生成一个预览链接，适合团队协作。

限制：Functions 有 10 秒超时，不能跑长任务。免费套餐带宽 100GB/月。

适合：静态站为主，偶尔需要一点服务端逻辑——比如表单提交、API 代理。

## Vercel

Next.js 背后的公司做的。对前端框架支持最好。

操作和 Netlify 差不多：连 GitHub 仓库，设构建命令，推送自动部署。

Vercel 的核心差异在后端支持：
- **Serverless Functions**：支持 Node.js、Go、Python、Ruby。比 Netlify Functions 更灵活，能写完整的 API。
- **Edge Functions**：代码跑在全球边缘节点，响应更快，适合做 A/B 测试、鉴权等。
- **ISR（增量静态再生成）**：Next.js 的招牌功能，静态页面可以按需更新，不用全量重建。

限制：免费套餐 Functions 执行时间 10 秒（Pro 版 60 秒），每月 100GB 带宽，100GB-Hrs 函数执行时长。商用需要注意。

适合：前端项目为主，后端逻辑较多的情况。尤其用 Next.js 的话，Vercel 是最好的选择。

## Cloudflare Pages

CDN 起家的 Cloudflare 做的。

操作也是连 GitHub 仓库，设构建命令。

它的独特之处：
- **Workers**：在 Cloudflare 全球网络上跑 JavaScript/TypeScript 代码。不是传统的 Serverless，是 V8 引擎上跑的，冷启动几乎为零。
- **D1**：Cloudflare 的边缘数据库（SQLite），可以和 Pages 配合用。
- **KV / R2**：键值存储和对象存储，适合存配置、图片等。
- **Durable Objects**：有状态的 Worker，能做 WebSocket、协作编辑这类。

所有 Worker 相关服务都有免费额度，个人项目基本够用。

限制：Worker 每次请求 CPU 时间 10ms（免费版）。不能用 Node.js 原生模块，生态和传统后端不太一样。

适合：对性能要求高的静态站，或者想用 Workers 写轻量后端的项目。

## 后端支持对比

一张表说清楚：

| 平台 | 静态部署 | 表单 | Serverless | 数据库 | 边缘计算 |
|------|---------|------|-----------|--------|----------|
| GitHub Pages | ✅ | ❌ | ❌ | ❌ | ❌ |
| Gitee Pages | ✅ | ❌ | ❌ | ❌ | ❌ |
| Netlify | ✅ | ✅ | ✅ (Node/Go) | ❌ | ❌ |
| Vercel | ✅ | ❌ | ✅ (多语言) | ✅ (第三方) | ✅ |
| Cloudflare Pages | ✅ | ❌ | ✅ (JS/Wasm) | ✅ (D1) | ✅ |

## 我的选择

先想清楚自己要什么，再选平台。

如果只是写博客、放文档，GitHub Pages 够用。不需要任何后端，纯 Markdown 生成 HTML，推上去就行。我现在就在用这个。

如果需要表单提交——比如博客加个留言板——Netlify 最省事。一个属性搞定，不用写一行后端代码。

如果需要跑一些后端逻辑，Vercel 和 Cloudflare Pages 各有优势。Vercel 对前端框架支持好，生态成熟；Cloudflare 全球 CDN 有优势，Workers 免费额度慷慨。

本地用 Git 存代码，推到一个仓库，挂上这些平台的自动部署。域名一年几十块，平台本身免费。对个人项目来说，够了。
