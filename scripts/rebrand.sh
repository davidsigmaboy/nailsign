#!/usr/bin/env bash
# Ребрендинг SideStore -> nailsign. Запускается в CI перед сборкой.
# Меняет только то, что безопасно: bundle ID (org) и отображаемое имя.
# Имена target/scheme/путей (SideStore.app и т.д.) НЕ трогаем: на них завязан Makefile апстрима.
set -euo pipefail

SRC="${1:-upstream/SideStore}"
ORG="${NAILSIGN_ORG:-com.nailsign}"
NAME="${NAILSIGN_NAME:-nailsign}"

cd "$SRC"

# 1) Свой org-идентификатор, чтобы не конфликтовать с настоящим SideStore
sed -i '' "s/com\.SideStore/${ORG}/g" Makefile Build.xcconfig

# 2) Отображаемое имя под иконкой
for plist in AltStore/Info.plist; do
  [ -f "$plist" ] || continue
  /usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName ${NAME}" "$plist" 2>/dev/null \
    || /usr/libexec/PlistBuddy -c "Add :CFBundleDisplayName string ${NAME}" "$plist"
done

echo "Rebrand done: org=${ORG}, name=${NAME}"
