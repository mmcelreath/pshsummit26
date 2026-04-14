# LatchedMama‑Inventory‑Notifier

An automated inventory notification script for LatchedMama.  The script reads a CSV file of desired products, checks the live LatchedMama store for availability, and sends notifications via **Telegram** and/or **Pushover**.

> This mechanism has been deprecated considering that the Latched Mama store is now available via the Shop app, which allows for notifications for restock alerts.

## Author Information

Check out [my blog for more information](https://therealgill.com). Thanks!

## Overview
The notifier is a collection of PowerShell functions that:
1. **Import** the `joshooaj.PSPushover` module when needed.
2. **Issue** a health‑check for the Telegram bot to keep the token alive.
3. **Query** the LatchedMama Shopify storefront for each product variant.
4. **Build** human‑readable messages for Telegram and/or Pushover.
5. **Send** the messages to the configured channels.

The main entry point is `Invoke‑LatchedMamaInventoryNotifier`, which orchestrates the entire workflow.

## Function Map
| Function | Purpose |
|----------|---------|
| `Get‑InStockItems` | Reads the input CSV, queries the LatchedMama storefront, and returns a collection of in‑stock items as PSCustomObjects. |
| `Import‑PSPushoverModule` | Installs and imports the `joshooaj.PSPushover` module if it is not already available. |
| `Set‑PSPushoverConfig` | Configures the Pushover client with user and application tokens. |
| `New‑PSPushoverMessage` | Builds a Pushover message payload from a single in‑stock item. |
| `New‑TelegramMessage` | Builds a consolidated Telegram message string from a list of in‑stock items. |
| `Send‑TelegramMessage` | Sends a plain text message via the Telegram Bot API. |
| `Send‑Pushover` | (Imported from PSPushover) Sends a Pushover notification. |
| `Invoke‑TelegramHealthCheck` | Sends a periodic health‑check message to keep the Telegram bot active. |
| `Invoke‑LatchedMamaInventoryNotifier` | Public function that ties everything together; accepts CSV path and optional notification parameters. |

## CSV Input Specification
The notifier expects a CSV file with the following columns (in this exact order):

| Column | Type | Description |
|--------|------|-------------|
| `Enabled` | Boolean (`TRUE`/`FALSE`) | Whether the product should be monitored. Only rows with `TRUE` are processed. |
| `Print` | String | The print name or identifier used to match variant `option2`. |
| `Sizes` | String | Either `*` to include all sizes or a comma‑separated list of size values that match variant `option1`. |
| `URL` | String | The base URL of the product page; the script appends `?variant=` with the variant ID when constructing links. |

Example row:

```csv
Enabled,Print,Sizes,URL
TRUE,Classic Tee,*,https://latchedmama.com/collections/tees
```

The script groups rows by `URL` and queries the corresponding `URL.js` endpoint to retrieve variant data.

## Usage
```powershell
Invoke‑LatchedMamaInventoryNotifier -Path "C:\path\to\products.csv" \
	-Telegram \
	-TelegramChatID "123456" \
	-TelegramToken "<token>" \
	-PSPushover \
	-PSPushoverUsrToken "<user>" \
	-PSPushoverAppToken "<app>"
```
Telegram and/or Pushover may be used. Reference `Get-Help Invoke-LatchedMamaInventoryNotifier` for more information.

> It is recommended that user should implement environment variables for Telegram/Pushover tokens

## License
GNU GENERAL PUBLIC LICENSE
