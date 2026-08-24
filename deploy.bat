@echo off
echo ======================================
echo USTAM WEB DEPLOY - CANLI + YEDEK + SEO
echo ======================================

echo [1/4] SEO Build aliniyor (3570 sayfa)...
cd seo
call npm run build
if %errorlevel% neq 0 (
  echo SEO BUILD PATLADI!
  cd ..
  pause
  exit /b
)
cd ..

echo [2/4] Flutter Build aliniyor...
call flutter build web --release
if %errorlevel% neq 0 (
  echo BUILD PATLADI!
  pause
  exit /b
)

echo [3/4] SEO sayfalari build/web icine gomuluyor (index hariç)...
xcopy "seo\out\adana" "build\web\adana\" /E /Y /I >nul
for /D %%i in ("seo\out\*") do (
  if /I not "%%~nxi"=="index.html" (
    xcopy "%%i" "build\web\%%~nxi\" /E /Y /I >nul
  )
)
xcopy "seo\out\sitemap.xml" "build\web\" /Y >nul
xcopy "seo\out\robots.txt" "build\web\" /Y >nul
echo SEO gomuldu! Flutter saglam!

echo [4/4] Cloudflare'e atiliyor (CANLI)...
if exist functions (
  ren functions _functions_temp
)
call npx wrangler pages deploy build/web --project-name=ustam-web-deploy --commit-dirty=true
if exist _functions_temp (
  ren _functions_temp functions
)

echo [5/5] GitHub'a yedekleniyor...
call git pull --rebase origin main
call git add .
call git commit -m "deploy: %date% %time% - canliya atildi + seo" --allow-empty
call git push origin main

echo ======================================
echo TAMAMDIR MORUK! HEM CANLIDA HEM YEDEKTE! SEO DAHIL!
echo Site: https://hemenustamgelsin.com
echo Kontrol: https://hemenustamgelsin.com/adana
echo ======================================
pause