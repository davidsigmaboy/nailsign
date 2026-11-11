# nailsign

On-device IPA signer без ПК.

## Идея

- **База:** форк [SideStore](https://github.com/SideStore/SideStore): вход по Apple ID, подпись на устройстве, обновление через loopback-VPN.
- **Anisette:** внешний anisette-сервер (свой или публичный) отдаёт данные для авторизации в Apple.
- **Безлимит приложений:** встроенный [LiveContainer](https://github.com/LiveContainer/LiveContainer), запускает IPA внутри одного подписанного контейнера, поэтому лимит 3 приложения / 10 App ID не мешает.
- **Старые iOS:** установка через [TrollStore](https://github.com/opa334/TrollStore) (постоянная подпись, без Apple ID).

## Структура репо

- `upstream/SideStore` — сабмодуль с исходниками SideStore (вместе с minimuxer и SideSign).
- `scripts/rebrand.sh` — в CI меняет bundle ID на `com.nailsign` и имя на nailsign.
- `.github/workflows/build.yml` — сборка через `make build / fakesign / ipa`.

Клонировать: `git clone --recurse-submodules https://github.com/davidsigmaboy/nailsign`

## Сборка

GitHub → Actions → **Build nailsign IPA** → Run workflow.
Готовый `nailsign.ipa` лежит в Artifacts. Тег `v*` создаёт Release.

Перед первой сборкой:
1. Залей в репо исходники форка SideStore (с сабмодулями).
2. Проверь `WORKSPACE` и `SCHEME` в `.github/workflows/build.yml`.

## План

1. Форк SideStore, ребрендинг в nailsign.
2. Подмодуль LiveContainer, режим «открыть IPA в контейнере».
3. Выбор anisette-сервера в настройках.
4. Ветка для TrollStore на iOS ≤ 17.0.
5. Сайт-лендинг со ссылкой на установку.

## Ограничения

- Сайт с «Добавить на экран» (PWA) подписывать IPA не может: нужен нативный код (zsign/ldid). Сайт годится только как лендинг и для ссылки на первую установку.
- Первая установка nailsign всё равно требует подписи (AltStore/SideStore/TrollStore/сертификат). Дальше всё на устройстве.
- Для работы SideStore нужен pairing-файл и loopback-VPN (StosVPN/LocalDevVPN).
- Бесплатный Apple ID: подпись живёт 7 дней, автообновление в фоне.
- TrollStore работает только на определённых версиях iOS.
