@echo off
echo ======================================
echo USTAM WEB DEPLOY - CANLI + YEDEK
echo ======================================

echo [1/3] Build aliniyor...
call flutter build web --release
if %errorlevel% neq 0 (
  echo BUILD PATLADI!
  pause
  exit /b
)

echo [2/3] Cloudflare'e atiliyor (CANLI)...
if exist functions (
  ren functions _functions_temp
)
call npx wrangler pages deploy build/web --project-name=ustam-web-deploy --branch=main --commit-dirty=true
if exist _functions_temp (
  ren _functions_temp functions
)

echo [3/3] GitHub'a yedekleniyor...
call git add .
call git commit -m "deploy: %date% %time% - canliya atildi" --allow-empty
call git push origin main

echo ======================================
echo TAMAMDIR MORUK! HEM CANLIDA HEM YEDEKTE!
echo Site: https://hemenustamgelsin.com
echo ======================================
pause