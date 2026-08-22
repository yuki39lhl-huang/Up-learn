# Git 常用操作（本机保存 / 上传 GitHub）

面向本仓库 `up-learn`。远程：`origin` → GitHub。

**两个词先分清：**

| 说法 | 命令 | 作用 |
|------|------|------|
| **保存** | `git add` + `git commit` | 只记在你电脑里 |
| **上传** | `git push` | 推到 GitHub，别的电脑才能 `pull` |

顺序必须是：**先 commit，再 push**。没提交就 push，远程不会变。

---

## 1. 命令行：保存（commit）

在项目根目录打开终端（PowerShell / IDEA Terminal）：

```bash
cd E:\GrammarPractice\IdeaProject\up-learn

# 看改了哪些文件
git status

# 把要保存的文件放进暂存区（. = 全部改动）
git add .

# 也可以只加某几个文件
# git add markdown/docker.md
# git add backend/user-service/src/main/resources/

# 提交并写说明（写清楚「为什么改」更好）
git commit -m "简短说明这次改了什么"

# 确认工作区干净
git status
```

PowerShell 多行说明可用：

```powershell
git commit -m @"
第一行摘要。

可选：补充说明。
"@
```

---

## 2. 命令行：上传（push）

```bash
# 日常推送（分支已跟踪远程时）
git push

# 本仓库主分支首次推送可用
git push -u origin master
```

推送前可看本地比远程多几个提交：

```bash
git status
# 若显示 Your branch is ahead of 'origin/master' by N commit(s)
# 说明有 N 次提交还没上传
```

---

## 3. 命令行：从 GitHub 拉下来（pull）

换电脑或别人改过远程时：

```bash
git pull
```

有冲突时按提示改文件，再 `git add` + `git commit`。

---

## 4. IDEA / Cursor 图形界面

### 保存（Commit）

1. 左侧 **Git** / **Commit** 面板  
2. 勾选要提交的文件  
3. 填写 **Commit Message**  
4. 点 **Commit**（只保存本机）

### 上传（Push）

1. 点 **Push**，或菜单 **Git → Push**  
2. 不要和 Commit 搞混：  
   - **Commit** = 本机保存  
   - **Commit and Push** = 保存并立刻上传  

---

## 5. 常用查看

```bash
# 最近几条提交
git log --oneline -10

# 看某文件改了什么（未提交）
git diff

# 看已暂存的差异
git diff --staged
```

---

## 6. 注意

1. **不要提交密钥**：`markdown/apikey`、`.env` 等已在 `.gitignore`，不要强行 `git add -f`。  
2. **IDE 插件塞进 SQL 的注释**（如 `-- Active: ...@3308@up_learn`）不要提交。  
3. 推错了、要改历史：先问清楚再动 `reset` / `force push`，主分支慎用强制推送。  
4. 本仓库当前主分支名是 **`master`**（有的项目是 `main`，以 `git branch` 为准）。

---

## 7. 最小记忆版

```bash
git status
git add .
git commit -m "说明"
git push
```
