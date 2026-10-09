@echo off
setlocal

echo ======================================
echo USTAM WEB DEPLOY - FINAL v12 - PRODUCTION
echo ======================================
echo.

echo [0/5] Temizlik...
call flutter clean
if errorlevel 1 (
    echo HATA: FLUTTER CLEAN BASARISIZ!
    pause
    exit /b 1
)

:SEO_SECIM
set "SEO_CHOICE="
set /p "SEO_CHOICE=SEO dosyalarini deploy etmek istiyor musun? (Y/N): "
if /I "%SEO_CHOICE%"=="Y" goto SEO_BUILD
if /I "%SEO_CHOICE%"=="N" goto FLUTTER_BUILD
echo Lutfen Y veya N gir.
goto SEO_SECIM

:SEO_BUILD
echo.
echo [1/5] SEO Build...
cd seo
if exist "out" rmdir /S /Q "out" >nul 2>&1
if exist ".next" rmdir /S /Q ".next" >nul 2>&1
set NODE_OPTIONS=--max-old-space-size=8192
call npm run build
if errorlevel 1 (
    cd ..
    pause
    exit /b 1
)
cd ..
echo.

:FLUTTER_BUILD
echo [2/5] Flutter Build...
call flutter build web --release --tree-shake-icons --no-wasm-dry-run
if errorlevel 1 (
    pause
    exit /b 1
)
echo.

echo [2.5/5] Cache ve Redirect ayarlari...
del /f /q "build\web\_worker.js" >nul 2>&1
del /f /q "build\web\_routes.json" >nul 2>&1

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
echo # GOOGLE INDEX FIX - YANLIS YAZIMLAR 301
echo /usta-is-ilanlari/*/otamatik-sulama-sistemleri /usta-is-ilanlari/:splat/otomatik-sulama-sistemleri 301!
echo /usta-is-ilanlari/*/otamatik-sulama-sistemleri/ /usta-is-ilanlari/:splat/otomatik-sulama-sistemleri/ 301!
echo /usta-is-ilanlari/*/boya-badana /usta-is-ilanlari/:splat/ic-cephe-boya-ve-badana 301!
echo /usta-is-ilanlari/*/boya-badana/ /usta-is-ilanlari/:splat/ic-cephe-boya-ve-badana/ 301!
echo /usta-is-ilanlari/*/cati-yapimi-aktarma-ve-izalasyon /usta-is-ilanlari/:splat/cati-aktarma-ve-izolasyon 301!
echo /usta-is-ilanlari/*/cati-yapimi-aktarma-ve-izalasyon/ /usta-is-ilanlari/:splat/cati-aktarma-ve-izolasyon/ 301!
echo /usta-is-ilanlari/*/uydu-internet-ve-kamera-sitemleri /usta-is-ilanlari/:splat/uydu-ve-kamera-sistemleri 301!
echo /usta-is-ilanlari/*/uydu-internet-ve-kamera-sitemleri/ /usta-is-ilanlari/:splat/uydu-ve-kamera-sistemleri/ 301!
echo.
echo # HOME FIX - 301 KALICI
echo /home / 301!
echo /home/ / 301!
echo.
echo # LLM DOSYALARI - SPA'YA EZDIRME!
echo /llms.txt /llms.txt 200
echo /llms-full.txt /llms-full.txt 200
echo /llms-hug-full.txt /llms-hug-full.txt 200
echo /ai.txt /ai.txt 200
echo /sitemap.xml /sitemap.xml 200
echo /hug-market-sitemap.xml /hug-market-sitemap.xml 200
echo /usta-sitemap.xml /usta-sitemap.xml 200
echo /robots.txt /robots.txt 200
echo.
echo # SEO KLASORLERI - FLUTTER'A EZDIRME!
echo /izmir/* /izmir/:splat 200
echo /istanbul/* /istanbul/:splat 200
echo /ankara/* /ankara/:splat 200
echo /adana/* /adana/:splat 200
echo /antalya/* /antalya/:splat 200
echo /bursa/* /bursa/:splat 200
echo /konya/* /konya/:splat 200
echo /gaziantep/* /gaziantep/:splat 200
echo /kocaeli/* /kocaeli/:splat 200
echo /manisa/* /manisa/:splat 200
echo /mugla/* /mugla/:splat 200
echo /aydin/* /aydin/:splat 200
echo /balikesir/* /balikesir/:splat 200
echo /kayseri/* /kayseri/:splat 200
echo /mersin/* /mersin/:splat 200
echo /hatay/* /hatay/:splat 200
echo /samsun/* /samsun/:splat 200
echo /tekirdag/* /tekirdag/:splat 200
echo /eskisehir/* /eskisehir/:splat 200
echo /denizli/* /denizli/:splat 200
echo /sanliurfa/* /sanliurfa/:splat 200
echo /diyarbakir/* /diyarbakir/:splat 200
echo /malatya/* /malatya/:splat 200
echo /erzurum/* /erzurum/:splat 200
echo /kahramanmaras/* /kahramanmaras/:splat 200
echo /van/* /van/:splat 200
echo /sakarya/* /sakarya/:splat 200
echo /trabzon/* /trabzon/:splat 200
echo /ordu/* /ordu/:splat 200
echo /afyonkarahisar/* /afyonkarahisar/:splat 200
echo /sivas/* /sivas/:splat 200
echo /batman/* /batman/:splat 200
echo /elazig/* /elazig/:splat 200
echo /tokat/* /tokat/:splat 200
echo /zonguldak/* /zonguldak/:splat 200
echo /kutahya/* /kutahya/:splat 200
echo /canakkale/* /canakkale/:splat 200
echo /osmaniye/* /osmaniye/:splat 200
echo /corum/* /corum/:splat 200
echo /kirklareli/* /kirklareli/:splat 200
echo /kirikkale/* /kirikkale/:splat 200
echo /adiyaman/* /adiyaman/:splat 200
echo /nevsehir/* /nevsehir/:splat 200
echo /isparta/* /isparta/:splat 200
echo /bolu/* /bolu/:splat 200
echo /duzce/* /duzce/:splat 200
echo /yozgat/* /yozgat/:splat 200
echo /nigde/* /nigde/:splat 200
echo /karaman/* /karaman/:splat 200
echo /edirne/* /edirne/:splat 200
echo /kars/* /kars/:splat 200
echo /kastamonu/* /kastamonu/:splat 200
echo /mardin/* /mardin/:splat 200
echo /siirt/* /siirt/:splat 200
echo /sinop/* /sinop/:splat 200
echo /karabuk/* /karabuk/:splat 200
echo /kilis/* /kilis/:splat 200
echo /kirsehir/* /kirsehir/:splat 200
echo /artvin/* /artvin/:splat 200
echo /bingol/* /bingol/:splat 200
echo /bitlis/* /bitlis/:splat 200
echo /burdur/* /burdur/:splat 200
echo /cankiri/* /cankiri/:splat 200
echo /erzincan/* /erzincan/:splat 200
echo /giresun/* /giresun/:splat 200
echo /gumushane/* /gumushane/:splat 200
echo /hakkari/* /hakkari/:splat 200
echo /igdir/* /igdir/:splat 200
echo /kars/* /kars/:splat 200
echo /rize/* /rize/:splat 200
echo /sirnak/* /sirnak/:splat 200
echo /tunceli/* /tunceli/:splat 200
echo /usak/* /usak/:splat 200
echo /yalova/* /yalova/:splat 200
echo /amasya/* /amasya/:splat 200
echo /agri/* /agri/:splat 200
echo /aksaray/* /aksaray/:splat 200
echo /ardahan/* /ardahan/:splat 200
echo /bartin/* /bartin/:splat 200
echo /bayburt/* /bayburt/:splat 200
echo /bilecik/* /bilecik/:splat 200
echo /mus/* /mus/:splat 200
echo /rehber/* /rehber/:splat 200
echo /hug-market/* /hug-market/:splat 200
echo /usta-is-ilanlari/* /usta-is-ilanlari/:splat 200
echo /404/* /404/:splat 200
echo /_next/* /_next/:splat 200
echo /.well-known/* /.well-known/:splat 200
echo.
echo # FLUTTER SPA FALLBACK - EN SONDA KALMALI
echo /* /index.html 200
) > "build\web\_redirects"

echo.

if "%SEO_CHOICE%"=="N" goto SEO_ATLA
echo [3/5] SEO gomuluyor...
del /f /q "build\web\_worker.js" >nul 2>&1
del /f /q "build\web\_routes.json" >nul 2>&1
for /D %%i in ("seo\out\*") do (
    if /I not "%%~nxi"=="api" (
        xcopy "%%i" "build\web\%%~nxi\" /E /Y /I /Q >nul
    )
)
for %%F in ("seo\out\*") do (
    if not exist "%%F\" (
        if /I not "%%~nxF"=="index.html" (
            copy /Y "%%F" "build\web\%%~nxF" >nul
        )
    )
)
if exist "build\web\404.html" del /Q "build\web\404.html" >nul 2>&1
if exist "build\web\404" rmdir /S /Q "build\web\404" >nul 2>&1
del /f /q "build\web\_worker.js" >nul 2>&1
del /f /q "build\web\_routes.json" >nul 2>&1
goto DEPLOY

:SEO_ATLA
echo [3/5] SEO ATLANDI.
del /f /q "build\web\_worker.js" >nul 2>&1
del /f /q "build\web\_routes.json" >nul 2>&1
echo.

:DEPLOY
echo [4/5] Cloudflare PRODUCTION deploy...
echo.
call wrangler pages deploy build/web --project-name=ustam-web-deploy --branch=main --commit-dirty=true
if errorlevel 1 (
    echo CLOUDFLARE DEPLOY BASARISIZ!
    pause
    exit /b 1
)
echo CLOUDFLARE DEPLOY TAMAM!
echo.

if "%SEO_CHOICE%"=="Y" (
    curl -s https://hemenustamgelsin.com/api/revalidate >nul
    echo Revalidate tamam.
    echo.
)

echo [5/5] Git push...
call git add .
call git commit -m "deploy: %date% %time% - FINAL v12" --allow-empty
call git pull --rebase origin main
call git push origin main
echo.
echo ======================================
echo DEPLOY TAMAMLANDI!
echo https://hemenustamgelsin.com
echo ======================================
pause
endlocal