@echo off
echo ======================================
echo USTAM WEB DEPLOY - CANLI + YEDEK + SEO + USTA-SEO + HIZLI - FINAL
echo ======================================

echo [1/5] SEO Build aliniyor (7052 sayfa - musteri + usta)...
cd seo
call npm run build
if %errorlevel% neq 0 (
  echo SEO BUILD PATLADI!
  cd ..
  pause
  exit /b
)
cd ..
echo SEO build bitti! out klasoru olustu.

echo [2/5] Flutter Build aliniyor - WASM HIZLI MOD...
call flutter build web --wasm --tree-shake-icons --release
if %errorlevel% neq 0 (
  echo WASM olmadi, eski hizli yontemle devam ediyorum...
  call flutter build web --release --tree-shake-icons
)
if %errorlevel% neq 0 (
  echo FLUTTER BUILD PATLADI!
  pause
  exit /b
)

echo [2.5/5] WebP ve Cache fixleri uygulaniyor...
if exist "web\splash\img\*.webp" (
  xcopy "web\splash\img\*.webp" "build\web\splash\img\" /Y >nul
  echo WebP'ler kopyalandi!
)

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
echo _headers olusturuldu!

echo [3/5] SEO sayfalari build/web icine gomuluyor (index haric)...
echo   Sehir sayfalari + Usta ilan sayfalari + Rehber...

REM Tum klasorleri kopyala - api ve _next HARIC
for /D %%i in ("seo\out\*") do (
  if /I not "%%~nxi"=="index.html" (
    if /I not "%%~nxi"=="_next" (
      if /I not "%%~nxi"=="api" (
        echo   - %%~nxi kopyalaniyor...
        xcopy "%%i" "build\web\%%~nxi\" /E /Y /I /Q >nul
      )
    )
  )
)

REM Sitemap ve robots.txt
if exist "seo\out\sitemap.xml" (
  xcopy "seo\out\sitemap.xml" "build\web\" /Y >nul
  echo   - sitemap.xml kopyalandi
)
if exist "seo\out\usta-sitemap.xml" (
  xcopy "seo\out\usta-sitemap.xml" "build\web\" /Y >nul
  echo   - usta-sitemap.xml kopyalandi
)
if exist "seo\out\robots.txt" (
  xcopy "seo\out\robots.txt" "build\web\" /Y >nul
  echo   - robots.txt kopyalandi
)

echo SEO gomuldu! 81 il + 3500+ usta ilani + rehber iceride!

echo [4/5] Cloudflare'e atiliyor (CANLI - WASM HIZLI + FUNCTIONS)...
REM functions klasoru ARTIK GIZLENMIYOR - api/revalidate.js canliya cikacak
call npx wrangler pages deploy build/web --project-name=ustam-web-deploy --commit-dirty=true

echo [5/5] GitHub'a yedekleniyor...
call git pull --rebase origin main
call git add .
call git commit -m "deploy: %date% %time% - FINAL usta-seo + functions api" --allow-empty
call git push origin main

echo ======================================
echo TAMAMDIR MORUK! HIZLANDIRILDI + USTA SEO EKLENDI + API FIX!
echo Site: https://hemenustamgelsin.com
echo Kontrol 1: https://hemenustamgelsin.com/adana
echo Kontrol 2: https://hemenustamgelsin.com/usta-is-ilanlari/adana/ic-cephe-boya-ve-badana
echo Kontrol 3: https://hemenustamgelsin.com/rehber
echo Kontrol 4: https://hemenustamgelsin.com/api/revalidate
echo Toplam: 7052 sayfa + 1 api canlida!
echo ======================================
pause