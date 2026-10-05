@echo off
setlocal

echo ======================================
echo USTAM WEB DEPLOY - FINAL v8 - CANAVAR
echo ======================================
echo.

echo [0/5] Temizlik...
call flutter clean
if errorlevel 1 (
    echo HATA: FLUTTER CLEAN BASARISIZ!
    pause
    exit /b 1
)
echo Temizlik bitti.
echo.

:SEO_SECIM
set "SEO_CHOICE="
set /p "SEO_CHOICE=SEO dosyalarini deploy etmek istiyor musun? (Y/N): "
if /I "%SEO_CHOICE%"=="Y" goto SEO_BUILD
if /I "%SEO_CHOICE%"=="N" goto FLUTTER_BUILD
echo HATA: Lutfen sadece Y veya N gir.
goto SEO_SECIM

:SEO_BUILD
echo.
echo [1/5] SEO Build aliniyor...
cd seo
if exist "out" rmdir /S /Q "out" >nul 2>&1
if exist ".next" rmdir /S /Q ".next" >nul 2>&1
call npm run build
if errorlevel 1 (
    echo HATA: SEO BUILD BASARISIZ!
    cd ..
    pause
    exit /b 1
)
cd ..
echo SEO bitti.
echo.

:FLUTTER_BUILD
echo [2/5] Flutter Build...
call flutter build web --release --tree-shake-icons --no-wasm-dry-run
if errorlevel 1 (
    echo HATA: FLUTTER BUILD BASARISIZ!
    pause
    exit /b 1
)
echo Flutter bitti.
echo.

echo [2.5/5] Cache ayarlari...
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
echo   Cache-Control: public, max-age=0, must-revalidate
echo /index.html
echo   Cache-Control: public, max-age=0, must-revalidate
echo /*.html
echo   Cache-Control: public, max-age=0, must-revalidate
) > "build\web\_headers"

(
echo # GOOGLE INDEX FIX 301
echo /usta-is-ilanlari/*/otamatik-sulama-sistemleri /usta-is-ilanlari/:splat/otomatik-sulama-sistemleri 301!
echo /usta-is-ilanlari/*/otamatik-sulama-sistemleri/ /usta-is-ilanlari/:splat/otomatik-sulama-sistemleri/ 301!
echo /usta-is-ilanlari/*/boya-badana /usta-is-ilanlari/:splat/ic-cephe-boya-ve-badana 301!
echo /usta-is-ilanlari/*/boya-badana/ /usta-is-ilanlari/:splat/ic-cephe-boya-ve-badana/ 301!
echo /usta-is-ilanlari/*/cati-yapimi-aktarma-ve-izalasyon /usta-is-ilanlari/:splat/cati-aktarma-ve-izolasyon 301!
echo /usta-is-ilanlari/*/cati-yapimi-aktarma-ve-izalasyon/ /usta-is-ilanlari/:splat/cati-aktarma-ve-izolasyon/ 301!
echo /usta-is-ilanlari/*/uydu-internet-ve-kamera-sitemleri /usta-is-ilanlari/:splat/uydu-ve-kamera-sistemleri 301!
echo /usta-is-ilanlari/*/uydu-internet-ve-kamera-sitemleri/ /usta-is-ilanlari/:splat/uydu-ve-kamera-sistemleri/ 301!
echo.
echo # HOME FIX
echo /home / 301!
echo /home/ / 301!
echo.
echo # FLUTTER SPA FALLBACK - EN SONDA
echo /* /index.html 200
) > "build\web\_redirects"

echo Cache tamam.
echo.

if "%SEO_CHOICE%"=="N" goto SEO_ATLA
echo [3/5] SEO gomuluyor...
echo.
for /D %%i in ("seo\out\*") do (
    if /I not "%%~nxi"=="api" (
        echo Kopyalaniyor: %%~nxi
        xcopy "%%i" "build\web\%%~nxi\" /E /Y /I /Q >nul
    )
)
for %%F in ("seo\out\*") do (
    if not exist "%%F\" (
        if /I not "%%~nxF"=="index.html" (
            echo Kopyalaniyor: %%~nxF
            copy /Y "%%F" "build\web\%%~nxF" >nul
        )
    )
)
if exist "build\web\404.html" del /Q "build\web\404.html" >nul 2>&1
if exist "build\web\404" rmdir /S /Q "build\web\404" >nul 2>&1
echo SEO gomuldu.
echo.
goto DEPLOY

:SEO_ATLA
echo [3/5] SEO ATLANDI.
echo.

:DEPLOY
echo [4/5] Cloudflare deploy...
echo.
call npx wrangler pages deploy build/web --project-name=ustam-web-deploy --commit-dirty=true
if errorlevel 1 (
    echo CLOUDFLARE DEPLOY BASARISIZ!
    pause
    exit /b 1
)
echo CLOUDFLARE DEPLOY TAMAM!
echo.

if "%SEO_CHOICE%"=="Y" (
    echo Revalidate...
    curl -s https://hemenustamgelsin.com/api/revalidate >nul
    echo Revalidate tamam.
    echo.
)

echo [5/5] Git push...
call git add .
call git commit -m "deploy: %date% %time% - FINAL v8" --allow-empty
call git pull --rebase origin main
call git push origin main
echo.
echo ======================================
echo DEPLOY TAMAMLANDI!
echo https://hemenustamgelsin.com
echo ======================================
pause
endlocal