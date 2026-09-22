@echo off
setlocal

echo ======================================
echo USTAM WEB DEPLOY - FINAL
echo AGORA YOK - DART2JS - FIREBASE FUNCTIONS KORUNUYOR
echo ======================================
echo.

echo [0/5] Temizlik atlandi - HICBIR DOSYA SILINMIYOR.
echo Mevcut functions ve diger dosyalar korunuyor.
echo.

echo ===============================
choice /M "SEO dosyalarini deploy etmek istiyor musun"
if errorlevel 2 (
  echo.
  echo SEO ATLANDI - N dedin
  echo.
  set "SEO_SKIP=1"
  goto FLUTTER_BUILD
)
set "SEO_SKIP=0"

echo [1/5] SEO Build aliniyor (7052 sayfa)...
cd seo
call npm run build
if %errorlevel% neq 0 (
  echo.
  echo SEO BUILD PATLADI!
  cd ..
  pause
  exit /b 1
)
cd ..
echo SEO bitti.
echo.

:FLUTTER_BUILD
echo [2/5] Flutter Build - CLASSIC STABIL (DART2JS)...
call flutter build web --release --tree-shake-icons
if %errorlevel% neq 0 (
  echo.
  echo FLUTTER BUILD PATLADI!
  pause
  exit /b 1
)
echo Flutter bitti.
echo.

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
echo _headers olusturuldu.
echo.

if "%SEO_SKIP%"=="1" goto SEO_GOMME_ATLA

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

if exist "seo\out\sitemap.xml" (
  xcopy "seo\out\sitemap.xml" "build\web\" /Y >nul
)

if exist "seo\out\usta-sitemap.xml" (
  xcopy "seo\out\usta-sitemap.xml" "build\web\" /Y >nul
)

if exist "seo\out\robots.txt" (
  xcopy "seo\out\robots.txt" "build\web\" /Y >nul
)

echo SEO gomuldu.
echo.
goto SEO_GOMME_BITTI

:SEO_GOMME_ATLA
echo [3/5] SEO gomuluyor... ATLANDI
echo.

:SEO_GOMME_BITTI

echo [4/5] Cloudflare'e direkt deploy ediliyor...
echo.

REM ============================================================
REM CLOUDFLARE, ROOT'TAKI "functions" KLASORUNU PAGES FUNCTIONS
REM OLARAK ALGILIYOR.
REM BU KLASOR ASLINDA FIREBASE FUNCTIONS.
REM DEPLOY SIRASINDA SADECE GECICI OLARAK ADINI DEGISTIRIYORUZ.
REM HICBIR DOSYA SILINMIYOR.
REM ============================================================

if exist "functions_firebase" (
  echo HATA: functions_firebase zaten mevcut!
  echo Guvenlik nedeniyle deploy durduruldu.
  pause
  exit /b 1
)

if not exist "functions" (
  echo HATA: functions klasoru bulunamadi!
  pause
  exit /b 1
)

echo Firebase functions gecici olarak gizleniyor...
ren "functions" "functions_firebase"

if %errorlevel% neq 0 (
  echo.
  echo FUNCTIONS KLASORU YENIDEN ADLANDIRILAMADI!
  pause
  exit /b 1
)

echo functions -> functions_firebase
echo Cloudflare deploy basliyor...
echo.

call npx wrangler pages deploy build/web --project-name=ustam-web-deploy --commit-dirty=true

set "WRANGLER_ERROR=%errorlevel%"

echo.
echo Cloudflare deploy islemi tamamlandi.
echo.

REM ============================================================
REM NE OLURSA OLSUN FIREBASE FUNCTIONS GERI GETIRILIYOR
REM ============================================================

echo Firebase functions geri getiriliyor...
ren "functions_firebase" "functions"

if %errorlevel% neq 0 (
  echo.
  echo KRITIK HATA: functions klasoru geri getirilemedi!
  echo Manuel olarak:
  echo ren functions_firebase functions
  echo komutunu calistir.
  pause
  exit /b 1
)

echo functions_firebase -> functions
echo.

if not "%WRANGLER_ERROR%"=="0" (
  echo ======================================
  echo CLOUDFLARE DEPLOY PATLADI!
  echo ======================================
  echo.
  echo Firebase functions klasoru KORUNDU.
  pause
  exit /b 1
)

echo ======================================
echo CLOUDFLARE DEPLOY TAMAMLANDI!
echo ======================================
echo.

echo [5/5] GitHub'a commit ve push yapiliyor...
echo.

call git add .
if %errorlevel% neq 0 (
  echo GIT ADD PATLADI!
  pause
  exit /b 1
)

call git commit -m "deploy: %date% %time% - FINAL" --allow-empty
if %errorlevel% neq 0 (
  echo GIT COMMIT PATLADI!
  pause
  exit /b 1
)

call git pull --rebase origin main
if %errorlevel% neq 0 (
  echo GIT PULL --REBASE PATLADI!
  pause
  exit /b 1
)

call git push origin main
if %errorlevel% neq 0 (
  echo GIT PUSH PATLADI!
  pause
  exit /b 1
)

echo.
echo ======================================
echo BITTI!
echo ======================================
echo https://hemenustamgelsin.com
echo https://hemenustamgelsin.com/api/revalidate
echo ======================================
pause

endlocal