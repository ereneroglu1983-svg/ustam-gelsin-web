@echo off
setlocal
chcp 65001 >nul
title HUG PROJE DEPLOY - deploy-hug-pro
color 0A

echo ============================================
echo  HUG PROJE DEPLOY - deploy-hug-pro.bat
echo  ESKI deploy.bat'a DOKUNMAZ
echo ============================================
echo.

:: 1. HUG PROJE SEO BUILD
echo [1/4] HUG PROJE build ediliyor...
cd /d "%~dp0hug-proje-seo"
if exist "out" rmdir /S /Q "out" >nul 2>&1
if exist ".next" rmdir /S /Q ".next" >nul 2>&1
if not exist node_modules (
  echo node_modules yok, npm install yapiliyor...
  call npm install
)
set NODE_OPTIONS=--max-old-space-size=8192
call npm run build
if errorlevel 1 (
  echo.
  echo HATA: HUG PROJE build basarisiz!
  cd /d "%~dp0"
  pause
  exit /b 1
)
cd /d "%~dp0"
echo HUG PROJE build OK.
echo.

:: 2. BUILD/WEB HAZIR MI KONTROL ET
if not exist "build\web\index.html" (
  echo.
  echo UYARI: build/web yok! Once eski deploy.bat ile Flutter build yapman lazim.
  echo Sadece HUG tek basina basilamaz, cunku build/web Flutter + SEO iceriyor.
  pause
  exit /b 1
)

:: 3. HUG'U KOPYALA - _redirects'i SILMEDEN
echo [2/4] build/web/hug-proje kopyalaniyor...
if exist "build\web\hug-proje" rmdir /S /Q "build\web\hug-proje" >nul 2>&1
mkdir "build\web\hug-proje"
xcopy "hug-proje-seo\out\*" "build\web\hug-proje\" /E /Y /I /Q
if errorlevel 1 (
  echo HATA: Kopyalama basarisiz!
  pause
  exit /b 1
)
del /f /q "build\web\hug-proje\_worker.js" >nul 2>&1
del /f /q "build\web\hug-proje\_routes.json" >nul 2>&1

:: _redirects'e sadece HUG satiri yoksa ekle, dosyayi bastan yazma!
findstr /C:"/hug-proje/*" "build\web\_redirects" >nul 2>&1
if errorlevel 1 (
  echo /hug-proje/*  /hug-proje/index.html  200 >> "build\web\_redirects"
  echo _redirects'e HUG satiri eklendi.
) else (
  echo _redirects'de HUG satiri zaten var.
)
echo.

:: 4. CLOUDFLARE - SENIN SATIRIN AYNISI
echo [3/4] Cloudflare PRODUCTION deploy...
echo.
call wrangler pages deploy build/web --project-name=ustam-web-deploy --branch=main --commit-dirty=true
if errorlevel 1 (
  echo CLOUDFLARE DEPLOY BASARISIZ!
  pause
  exit /b 1
)
echo CLOUDFLARE DEPLOY TAMAM!
echo.

:: 5. GIT - node_modules ALMADAN
echo [4/4] Git push...
call git add .gitignore build/web/hug-proje hug-proje-seo/app hug-proje-seo/data hug-proje-seo/lib hug-proje-seo/public deploy-hug-pro.bat
call git commit -m "deploy hug-proje: %date% %time%" --allow-empty
call git pull --rebase origin main
call git push origin main
echo.
echo ======================================
echo DEPLOY TAMAMLANDI!
echo https://hemenustamgelsin.com/hug-proje/
echo ======================================
pause
endlocal