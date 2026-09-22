```bat
@echo off
setlocal

echo ======================================
echo USTAM WEB DEPLOY - FINAL v6 - STABIL
echo ======================================
echo.

REM ============================================================
REM [0/5] TEMIZLIK
REM ============================================================

echo [0/5] Temizlik...
call flutter clean

if errorlevel 1 (
    echo.
    echo HATA: FLUTTER CLEAN BASARISIZ!
    pause
    exit /b 1
)

echo Temizlik bitti.
echo.


REM ============================================================
REM [1/5] SEO SECIMI
REM ============================================================

:SEO_SECIM

set "SEO_CHOICE="

echo.
set /p "SEO_CHOICE=SEO dosyalarini deploy etmek istiyor musun? (Y/N): "

if /I "%SEO_CHOICE%"=="Y" (
    set "SEO_SKIP=0"
    goto SEO_BUILD
)

if /I "%SEO_CHOICE%"=="N" (
    set "SEO_SKIP=1"
    echo.
    echo SEO ATLANDI.
    echo.
    goto FLUTTER_BUILD
)

echo.
echo HATA: Lutfen sadece Y veya N gir.
goto SEO_SECIM


REM ============================================================
REM [1/5] SEO BUILD
REM ============================================================

:SEO_BUILD

echo.
echo [1/5] SEO Build aliniyor...

cd seo

call npm run build

if errorlevel 1 (
    echo.
    echo HATA: SEO BUILD BASARISIZ!
    cd ..
    pause
    exit /b 1
)

cd ..

echo SEO bitti.
echo.


REM ============================================================
REM [2/5] FLUTTER BUILD
REM ============================================================

:FLUTTER_BUILD

echo [2/5] Flutter Build...

call flutter build web --release --tree-shake-icons --no-wasm-dry-run

if errorlevel 1 (
    echo.
    echo HATA: FLUTTER BUILD BASARISIZ!
    pause
    exit /b 1
)

echo Flutter bitti.
echo.


REM ============================================================
REM [2.5/5] CACHE HEADERS
REM ============================================================

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

if errorlevel 1 (
    echo.
    echo HATA: _headers DOSYASI OLUSTURULAMADI!
    pause
    exit /b 1
)

echo Cache ayarlari tamam.
echo.


REM ============================================================
REM [3/5] SEO'YU FLUTTER BUILD'E GOM
REM ============================================================

if "%SEO_SKIP%"=="1" goto SEO_GOMME_ATLA

echo [3/5] SEO gomuluyor...
echo.


REM ------------------------------------------------------------
REM SEO KLASORLERI
REM
REM _next KOPYALANIR.
REM api BILINCLI OLARAK ATLANIR.
REM ------------------------------------------------------------

for /D %%i in ("seo\out\*") do (

    if /I not "%%~nxi"=="api" (

        echo Kopyalaniyor: %%~nxi

        xcopy "%%i" "build\web\%%~nxi\" /E /Y /I /Q >nul

        if errorlevel 2 (
            echo.
            echo HATA: SEO KLASORU KOPYALANAMADI: %%~nxi
            pause
            exit /b 1
        )
    )
)


REM ------------------------------------------------------------
REM SEO ROOT DOSYALARI
REM
REM index.html ATLANIR.
REM Flutter'in index.html dosyasi korunur.
REM Diger root dosyalari kopyalanir.
REM ------------------------------------------------------------

for %%F in ("seo\out\*") do (

    if not exist "%%F\" (

        if /I not "%%~nxF"=="index.html" (

            echo Kopyalaniyor: %%~nxF

            copy /Y "%%F" "build\web\%%~nxF" >nul

            if errorlevel 1 (
                echo.
                echo HATA: SEO DOSYASI KOPYALANAMADI: %%~nxF
                pause
                exit /b 1
            )
        )
    )
)

echo.
echo SEO gomuldu.
echo.

goto SEO_GOMME_BITTI


REM ============================================================
REM SEO ATLANDI
REM ============================================================

:SEO_GOMME_ATLA

echo [3/5] SEO ATLANDI.
echo.


REM ============================================================
REM [4/5] CLOUDFLARE DEPLOY
REM ============================================================

:SEO_GOMME_BITTI

echo [4/5] Cloudflare deploy...
echo.


REM ------------------------------------------------------------
REM FUNCTIONS KONTROL
REM ------------------------------------------------------------

if exist "functions_firebase" (
    echo.
    echo HATA: functions_firebase zaten mevcut!
    echo Onceki deploy yarim kalmis olabilir.
    echo Islem durduruldu.
    pause
    exit /b 1
)

if not exist "functions" (
    echo.
    echo HATA: functions klasoru bulunamadi!
    pause
    exit /b 1
)


REM ------------------------------------------------------------
REM FUNCTIONS GIZLE
REM ------------------------------------------------------------

ren "functions" "functions_firebase"

if errorlevel 1 (
    echo.
    echo HATA: functions klasoru gizlenemedi!
    pause
    exit /b 1
)

echo functions gizlendi.
echo.


REM ------------------------------------------------------------
REM WRANGLER
REM
REM TEK DENEME.
REM RETRY YOK.
REM ------------------------------------------------------------

echo Cloudflare deploy baslatiliyor...
echo.

call npx wrangler pages deploy build/web --project-name=ustam-web-deploy --commit-dirty=true

set "WRANGLER_ERROR=%ERRORLEVEL%"


REM ------------------------------------------------------------
REM FUNCTIONS GERI GETIR
REM
REM WRANGLER BASARILI OLSA DA OLMASA DA CALISIR.
REM ------------------------------------------------------------

echo.
echo functions geri getiriliyor...

ren "functions_firebase" "functions"

if errorlevel 1 (
    echo.
    echo ======================================
    echo KRITIK HATA!
    echo ======================================
    echo functions geri getirilemedi!
    echo.
    echo Klasor su an functions_firebase olarak kalmis olabilir.
    echo Manuel olarak kontrol et.
    echo.
    pause
    exit /b 1
)

echo functions geri geldi.
echo.


REM ------------------------------------------------------------
REM WRANGLER SONUCU
REM ------------------------------------------------------------

if not "%WRANGLER_ERROR%"=="0" (
    echo.
    echo ======================================
    echo CLOUDFLARE DEPLOY BASARISIZ!
    echo ======================================
    echo.
    echo Wrangler hata kodu: %WRANGLER_ERROR%
    echo.
    echo Otomatik retry YOK.
    echo Git push YAPILMAYACAK.
    echo.
    pause
    exit /b 1
)

echo ======================================
echo CLOUDFLARE DEPLOY TAMAM!
echo ======================================
echo.


REM ============================================================
REM REVALIDATE
REM
REM Sadece SEO deploy edildiyse.
REM Revalidate basarisiz olsa bile Cloudflare deploy basarili
REM oldugu icin ana deploy BASARISIZ sayilmaz.
REM ============================================================

if "%SEO_SKIP%"=="0" (

    echo Revalidate calistiriliyor...

    curl -s https://hemenustamgelsin.com/api/revalidate >nul

    if errorlevel 1 (
        echo UYARI: Revalidate istegi basarisiz oldu.
        echo Cloudflare deploy basarili.
        echo Sadece revalidate tekrar gerekebilir.
    ) else (
        echo Revalidate tamam.
    )

    echo.
)


REM ============================================================
REM [5/5] GIT
REM ============================================================

echo [5/5] Git push...
echo.


REM ------------------------------------------------------------
REM GIT ADD
REM ------------------------------------------------------------

call git add .

if errorlevel 1 (
    echo.
    echo HATA: GIT ADD BASARISIZ!
    pause
    exit /b 1
)


REM ------------------------------------------------------------
REM GIT COMMIT
REM ------------------------------------------------------------

call git commit -m "deploy: %date% %time% - FINAL v6" --allow-empty

if errorlevel 1 (
    echo.
    echo HATA: GIT COMMIT BASARISIZ!
    pause
    exit /b 1
)


REM ------------------------------------------------------------
REM GIT PULL
REM ------------------------------------------------------------

call git pull --rebase origin main

if errorlevel 1 (
    echo.
    echo HATA: GIT PULL --REBASE BASARISIZ!
    echo.
    echo Push YAPILMADI.
    pause
    exit /b 1
)


REM ------------------------------------------------------------
REM GIT PUSH
REM ------------------------------------------------------------

call git push origin main

if errorlevel 1 (
    echo.
    echo HATA: GIT PUSH BASARISIZ!
    pause
    exit /b 1
)


REM ============================================================
REM TAMAMLANDI
REM ============================================================

echo.
echo ======================================
echo DEPLOY TAMAMLANDI!
echo ======================================
echo.
echo https://hemenustamgelsin.com
echo.

pause
endlocal
```
