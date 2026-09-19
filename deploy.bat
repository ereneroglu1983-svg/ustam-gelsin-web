@echo off
echo ======================================
echo USTAM WEB DEPLOY - FINAL - AGORA YOK - WASM YOK
echo ======================================

echo [0/5] Temizlik...
if exist "functions\node_modules" (
  echo   - Agora node_modules siliniyor...
  rmdir /S /Q "functions\node_modules"
)
if exist "functions\package-lock.json" del /Q "functions\package-lock.json"
if exist "functions\package.json" del /Q "functions\package.json"
if exist "functions\index.js" del /Q "functions\index.js"
if exist "seo\app\api" (
  echo   - Bozuk seo/app/api siliniyor...
  rmdir /S /Q "seo\app\api"
)
if exist "seo\.next" rmdir /S /Q "seo\.next"
if exist "seo\out" rmdir /S /Q "seo\out"
echo Temizlik bitti.

echo [1/5] SEO Build aliniyor (7052 sayfa)...
cd seo
call npm run build
if %errorlevel% neq 0 (
  echo SEO BUILD PATLADI!
  cd ..
  pause
  exit /b
)
cd ..
echo SEO bitti.

echo [2/5] Flutter Build - CLASSIC STABIL ^(WASM KAPALI^)...
call flutter build web --release --tree-shake-icons
if %errorlevel% neq 0 (
  echo FLUTTER BUILD PATLADI!
  pause
  exit /b
)

echo [2.5/5] Cache fix...
(
echo /*.js
echo   Cache-Control: public, max-age=31536000, immutable
echo /*.mjs
echo   Cache-Control: public, max-age=31536000, immutable
echo /*.wasm
echo   Cache-Control: public, max-age=31536000, immutable
echo /*.webp
echo   Cache-Control: public, max-age=31536000, immutable
echo /*.png
echo   Cache-Control: public, max-age=31536000, immutable
echo /flutter_bootstrap.js
echo   Cache-Control: public, max-age=3600
echo /*.html
echo   Cache-Control: public, max-age=0, must-revalidate
) > "build\web\_headers"
echo _headers olustu.

echo [3/5] SEO gomuluyor...
for /D %%i in ("seo\out\*") do (
  if /I not "%%~nxi"=="_next" (
    if /I not "%%~nxi"=="api" (
      if /I not "%%~nxi"=="index.html" (
        xcopy "%%i" "build\web\%%~nxi\" /E /Y /I /Q >nul
      )
    )
  )
)
if exist "seo\out\sitemap.xml" xcopy "seo\out\sitemap.xml" "build\web\" /Y >nul
if exist "seo\out\usta-sitemap.xml" xcopy "seo\out\usta-sitemap.xml" "build\web\" /Y >nul
if exist "seo\out\robots.txt" xcopy "seo\out\robots.txt" "build\web\" /Y >nul
echo SEO gomuldu.

echo [4/5] Cloudflare'e atiliyor...
call npx wrangler pages deploy build/web --project-name=ustam-web-deploy --commit-dirty=true
if %errorlevel% neq 0 (
  echo CLOUDFLARE PATLADI!
  pause
  exit /b
)

echo [5/5] GitHub'a yedekleniyor...
call git add .
call git commit -m "deploy: %date% %time% - FINAL agora yok wasm yok" --allow-empty
call git pull --rebase origin main
call git push origin main

echo ======================================
echo BİTTİ!
echo https://hemenustamgelsin.com
echo https://hemenustamgelsin.com/api/revalidate
echo ======================================
pause