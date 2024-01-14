#!/bin/bash

sudo apt update
sudo apt -y install curl jq

echo "By @YZBruh"
echo "Kullanıcı adı:"
read USERNAME
echo "Depo adı:"
read REPO
echo "Etiket adı:"
read TAG_NAME
echo "Yayın başlığı:"
read RELEASE_NAME
echo "Erişim tokeni:"
read ACCESS_TOKEN
echo "Kaydedilecek dosya adı (yayındaki ad):"
read RELEASE_FILEN
echo "Yüklenecek dosyanın adı:"
read FILE

# GitHub Release API'si üzerinden yayını oluştur
response=$(curl -X POST -H "Authorization: token $ACCESS_TOKEN" -d '{"tag_name": "'$TAG_NAME'", "name": "'$RELEASE_NAME'", "draft": false, "prerelease": false}' "https://api.github.com/repos/$USERNAME/$REPO/releases")

# JSON çıktısından tarayıcı ve indirme URL'sini al
browser_download_url=$(echo $response | jq -r '.upload_url' | sed -e 's/{?name,label}//')
browser_download_url="${browser_download_url}?name="$RELEASE_FILEN""

# Yayın dosyasını ekle
curl -X POST -H "Authorization: token $ACCESS_TOKEN" -H "Content-Type: application/zip" --data-binary @$FILE "$browser_download_url"

unset USERNAME REPO TAG_NAME RELEASE_NAME RELEASE_FILEN ACCESS_TOKEN FILE