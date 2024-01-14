@echo off
:: GitHub depo yayını yükleyicisi - GitHub repository release uploader
:: By YZBruh

:: Logcat temizliği - Clear logcat
cls

:: Bilgileri al - Get info's
set /p USERNAME="Kullanıcı adı: "
set /p REPO="Depo adı: "
set /p TAG_NAME="Etiket adı: "
set /p RELEASE_NAME="Yayın adı: "
set /p ACCESS_TOKEN="Erişim tokeni: "
set /p RELEASE_FILEN="Kaydedilecek dosya adı (yayındaki ad): "
set /p FILE="Yüklenecek dosyanın adı: "

:: GitHub Release API'si üzerinden yayını oluştur
curl -s -H "Authorization: token %ACCESS_TOKEN%" -d "{""tag_name"": ""%TAG_NAME%"", ""name"": ""%RELEASE_NAME%"", ""draft"": false, ""prerelease"": false}" "https://api.github.com/repos/%USERNAME%/%REPO%/releases"

:: Yayın dosyasını eklemek için
curl -s -H "Authorization: token %ACCESS_TOKEN%" -H "Content-Type: application/zip" --data-binary @%FILE% "https://uploads.github.com/repos/%USERNAME%/%REPO%/releases/%TAG_NAME%/assets?name=%RELEASE_FILEN%"
