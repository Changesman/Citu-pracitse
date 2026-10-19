@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"

echo ============================================================
echo   词途 CET4 · 一键推送到 GitHub Pages
echo   目录：%CD%
echo ============================================================
echo.

where git >nul 2>nul
if errorlevel 1 (
  echo [x] 没有找到 git。
  echo     请先安装 Git for Windows： https://git-scm.com/download/win
  echo     安装时一路默认即可，装完关掉本窗口重新运行。
  echo.
  pause
  exit /b 1
)

echo 还没建仓库的话，先打开 https://github.com/new
echo   仓库名随意，比如 wordway-cet4
echo   可见性必须选 Public（免费账号的 Pages 只支持公开仓库）
echo   不要勾选 Add a README
echo.
set /p REPO=把仓库地址粘到这里（形如 https://github.com/你的用户名/wordway-cet4.git）: 

if "%REPO%"=="" (
  echo [x] 地址不能为空。
  pause
  exit /b 1
)

echo.
echo ---- 初始化仓库 ----
if not exist ".git" (
  git init || goto :err
  git branch -M main || goto :err
)

echo ---- 添加文件 ----
git add -A || goto :err

echo ---- 提交 ----
git config --get user.email >nul 2>nul
if errorlevel 1 (
  git -c user.name="%USERNAME%" -c user.email="%USERNAME%@users.noreply.github.com" ^
      commit -m "部署：词途 CET4 词汇与翻译" || echo （没有新改动需要提交）
) else (
  git commit -m "部署：词途 CET4 词汇与翻译" || echo （没有新改动需要提交）
)

echo ---- 关联远程 ----
git remote remove origin >nul 2>nul
git remote add origin "%REPO%" || goto :err

echo ---- 推送 ----
echo 如果弹出登录窗口，账号填 GitHub 用户名，
echo 密码要填 Personal Access Token（不是登录密码）：
echo   https://github.com/settings/tokens  ->  Generate new token (classic)  ->  勾选 repo
echo.
git push -u origin main || goto :err

echo.
echo ============================================================
echo  [√] 代码已推送成功
echo.
echo  最后一步（只需做一次）：
echo    打开仓库 -^> Settings -^> Pages
echo    Source 选  "Deploy from a branch"
echo    Branch 选  main   ，目录选  / (root)   -^> Save
echo.
echo  等 1~2 分钟，访问：
echo    https://你的用户名.github.io/仓库名/
echo ============================================================
echo.
pause
exit /b 0

:err
echo.
echo [x] 出错了，请对照上面的提示排查：
echo     - 仓库地址是否写错（要以 .git 结尾）
echo     - 是否已经在浏览器里登录了正确的 GitHub 账号
echo     - 推送时密码是否用了 Personal Access Token
echo.
pause
exit /b 1
