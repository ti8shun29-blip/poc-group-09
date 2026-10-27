# 🚀 同步到 GitHub 指令指南

> 目標 repo：`https://github.com/ti8shun29-blip/poc-group-09`
> 本指南是給「你自己的電腦」使用的。目前這台 AI 環境沒裝 Git，所以請在你自己電腦上照下面步驟執行。

---

## 步驟 0：安裝 Git（如果還沒裝）

- Windows（用 winget）：
  ```
  winget install --id Git.Git -e --source winget
  ```
- Mac（用 Homebrew）：
  ```
  brew install git
  ```
- 安裝完請**重新開啟** PowerShell / Terminal，讓 `git` 指令生效。

## 步驟 1：設定 Git 身分（只做一次）

把姓名與 email 換成你的 GitHub 帳號資訊：

```bash
git config --global user.name "你的名字"
git config --global user.email "your-email@example.com"
```

## 步驟 2：把 repo 抓下來

先複製 repo 到桌面（或任何地方）：

```bash
cd ~/Desktop
git clone https://github.com/ti8shun29-blip/poc-group-09.git
cd poc-group-09
```

> 因為 repo 已經有 `README.md`，我們用 clone 的方式最乾淨。

## 步驟 3：把 POC 檔案放進來

把這兩個檔案放進剛 clone 好的資料夾（`~/Desktop/poc-group-09/`）：

- `index.html`
- `README.md`
- （選擇性）`SYNC-GUIDE.md`

## 步驟 4：提交並上傳

```bash
git add .
git commit -m "Add POC: polite decline tool (index.html + README)"
git push
```

> 第一次 push 會跳出視窗要求你登入 GitHub（Git Credential Manager 會自動開啟）。登入完成即上傳成功。

---

## 如果 push 時遇到問題

| 問題 | 解法 |
| --- | --- |
| `error: failed to push some refs`（遠端有新變更） | 先執行 `git pull --rebase`，再用 `git push` |
| 要求 `.gitignore` 內藏金鑰 | 本 POC 無任何金鑰/密碼，不需要 |
| `git commit` 說沒有 user.name | 回步驟 1 設定身分 |

## 完成後

打開 → `https://github.com/ti8shun29-blip/poc-group-09` 應該就能看到 `index.html` 與 `README.md`。

> 如需用無痕 / 上傳方式，也可改用密鑰（SSH）遠端：`git remote set-url origin git@github.com:ti8shun29-blip/poc-group-09.git`
