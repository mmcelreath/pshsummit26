# Domestic Automation Adventures: An Inventory Tracker

PowerShell + DevOps Global Summit 2026 session materials for an automation demo that tracks product availability on a Shopify storefront and sends notifications when items are in stock.

## Session Overview

This session demonstrates how to build a small automation workflow around a private storefront inventory problem.

Key ideas covered:
- Why inventory tracking is hard and why an automated source of truth matters
- Using Shopify storefront data and browser DevTools to discover product variants
- Designing a PowerShell workflow to read desired products, query live inventory, and generate notifications
- Integrating notification platforms such as Telegram and Pushover
- Tying the full solution together with a public entry point function and reusable helper functions

## What the Demo Does

The demo project includes a PowerShell notifier that:
1. Reads a CSV of desired products, sizes, and storefront URLs
2. Queries the Shopify storefront `URL.js` endpoint to retrieve variant inventory and pricing data
3. Filters for in-stock items that match the requested product and size selections
4. Builds messages for Telegram and/or Pushover
5. Sends notifications to configured channels

The main entry point is `Invoke-LatchedMamaInventoryNotifier`, which orchestrates the workflow and supports both Telegram and PSPushover output.

## Code Structure

- `code/` contains the PowerShell implementation and supporting files
- `code/functions/public/invoke-latched-mama-inventory-notifier.ps1` is the public orchestration function
- `code/functions/private/` contains helper functions for inventory lookup, notification creation, and delivery
- `code/data/lm-inventory-example.csv` shows the expected input format
- `code/README.md` contains module-specific implementation details and CSV input expectations

## Talk Flow

The presentation is structured around:
- The problem and the need for a reliable inventory tracker
- Identifying the source of truth for product variant data
- Using DevTools and Shopify variant endpoints to extract SKU and inventory details
- Designing the automation with discrete stages: input, query, parse, notify
- Reviewing the PowerShell code and integration with PSPushover
- Running a live demo
- Future improvements: generalized Shopify module, better documentation, abstraction, source control, and support for more notification platforms

## Useful Links

- Telegram Bot API: https://core.telegram.org/bots/api
- PSPushover PowerShell module: https://www.joshooaj.com/PSPushover/
- Speaker: Matthew Gill — TheRealGill.com

## Notes

This implementation was built for a specific LatchedMama storefront workflow. The same design pattern can be adapted to other Shopify stores and notification channels.

> The original demo notes that the Latched Mama workflow is now deprecated in favor of Shopify/Shop app restock alerts, but the automation pattern is still a useful PowerShell example.
