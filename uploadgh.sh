#!/bin/bash
# GitHub depo yayını yükleyicisi - GitHub repository release uploader
# By YZBruh

# Directly exit
set -e

# Paket kurulumları - Package installatations
echo "Gerekli paketler kurulsunmu? (y/n | y=evet n=hayır)"
read PASS
if [ "$PASS" == "y" ]; then
   sudo apt update
   sudo apt -y install curl jq
elif [ "$PASS" == "n" ]; then
   echo "Paket kurulumu atlanıyor."
else
   echo "Bilinmeyen argüman!"
   exit 1
fi

# Bilgileri al - Get info's
echo
echo "GitHub depo yayın yükleyicisi V1 | By YZBruh"
read -p "Kullanıcı adı: " USERNAME
echo
read -p "Depo adı: " REPO
echo
read -p "Etiket adı: " TAG_NAME
echo
read -p "Yayın başlığı: " RELEASE_NAME
echo
read -p "Erişim tokeni: " ACCESS_TOKEN
echo
read -p "Kaydedilecek dosya adı (yayındaki ad): " RELEASE_FILEN
echo
read -p "Yüklenecek dosyanın adı: " FILE
echo

# GitHub yayın API'si üzerinden yayını oluştur
response=$(curl -X POST -H "Authorization: token $ACCESS_TOKEN" -d '{"tag_name": "'$TAG_NAME'", "name": "'$RELEASE_NAME'", "draft": false, "prerelease": false}' "https://api.github.com/repos/$USERNAME/$REPO/releases")

# JSON çıktısından tarayıcı ve indirme URL'sini al
browser_download_url=$(echo $response | jq -r '.upload_url' | sed -e 's/{?name,label}//')
browser_download_url="${browser_download_url}?name="$RELEASE_FILEN""

# Yayın dosyasını ekle
curl -X POST -H "Authorization: token $ACCESS_TOKEN" -H "Content-Type: application/zip" --data-binary @"$FILE" "$browser_download_url"

unset USERNAME REPO TAG_NAME RELEASE_NAME RELEASE_FILEN ACCESS_TOKEN FILE PASS response browser_download_url
