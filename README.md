# Philips Air+ Home Assistant Integration

Custom integration for Philips Air+ air purifiers. Communicates with the Philips/Versuni cloud service using the same MQTT protocol as the official mobile app.

This is a fork of [ShorMeneses/philips-airplus-homeassistant](https://github.com/ShorMeneses/philips-airplus-homeassistant), significantly extended and rearchitected: the original supported only AC0650/10 with a hardcoded device model; this fork introduces a model-agnostic, YAML-driven entity system and adds full AC0651/10 support.

## Features

- **Fan Control**: Preset modes with on/off
- **Fan Level Sensor**: Actual fan speed level (0–18) with history — useful in Auto mode to see current intensity
- **Filter Monitoring**: Filter replacement and cleaning life (percentage + remaining hours)
- **Maintenance Resets**: Reset filter timers via buttons or HA services
- **Real-time Updates**: Live status updates via MQTT subscription
- **Reconnect Resilience**: Automatic reconnect with exponential backoff (30 s → 5 min) and token refresh before re-connecting
- **Air Quality Sensors**: PM2.5 concentration and allergen index (AC0651/10)
- **Standby Monitor**: Toggle sensor standby mode (AC0651/10)

## Supported Devices

| Model | Modes | Fan Level | Filter Monitoring | Air Quality | Standby Monitor |
|-------|-------|-----------|-------------------|-------------|-----------------|
| AC0650/10 | Auto, Sleep, Turbo | ✅ | ✅ | ✅ PM2.5 | — |
| AC0651/10 | Auto, Medium, Sleep, Turbo | ✅ | ✅ | ✅ PM2.5, Allergen Index | ✅ |

Other Air+ models sharing the same MQTT protocol may work but are untested. New models can be added via `models.yaml` without code changes.

## Installation

### via HACS (Recommended)

1. Go to HACS > Integrations
2. Click the three dots menu and select "Custom repositories"
3. Add repository: `https://github.com/markusstephany/philips-airplus-homeassistant`
4. Select "Integration" as category
5. Click "Add"
6. Go to HACS > Integrations and search for "Philips Air+ Multi"
7. Click "Install" and restart Home Assistant

### Manual Installation

1. Copy the `custom_components/philips_airplus_multi` directory to your Home Assistant `config/custom_components` directory
2. Restart Home Assistant

## Configuration

### Prerequisites

A Philips Air+ account with your device already set up in the official mobile app.

### Authentication: OAuth PKCE Flow

1. Add the integration in Home Assistant — a login URL will be shown.
2. Open that URL in your browser.
3. Open browser DevTools (F12) → Network tab — before logging in.
4. Complete the login and authorization on the Philips website.
5. In the Network tab, find the redirect to `com.philips.air://loginredirect?code=...` and copy the full URL.
6. Paste it into Home Assistant as the Authorization Code.

Notes:
- On desktop browsers, the `com.philips.air://...` request will fail to open — this is expected.
- You can paste the full redirect URL or just the code value; the integration extracts the code automatically.
- If the token expires, go to **Integration → Configure** and paste a new authorization code — no need to remove and re-add the integration.

## Services

Two HA services are registered:

- `philips_airplus_multi.reset_filter_clean` — replicates the official app's "Filter cleaned" reset
- `philips_airplus_multi.reset_filter_replace` — replicates the official app's "New filter" reset

Both accept an optional `device_uuid` parameter to target a specific device when multiple are configured.

## Architecture

All device-specific behaviour is driven by `models.yaml` — no model assumptions are hardcoded. Each model entry declares its MQTT properties, preset modes, and which sensors/switches/buttons to create. Adding support for a new model requires only a new entry in `models.yaml`.

Entities are registered lazily: the integration waits for the device to report its model identifier over MQTT before creating entities, so `device_info` always contains the correct model name from the start.

## Limitations

- Actively tested with AC0651/10; AC0650/10 configuration is carried over from the original fork and untested on real hardware
- Requires internet connectivity (cloud-dependent)

## Adding a New Model

1. Add an entry to `models.yaml` with the model identifier as reported by the device (`ctn` property)
2. Define `modes`, `properties`, and optionally `sensors`, `switches`, `buttons`
3. No code changes required

Open an issue or pull request if you have a device and logs to contribute.

## Contributing

Contributions welcome — especially tested `models.yaml` entries for additional Air+ models.

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## Development

Developed with [Claude Code](https://claude.ai/code).

## License

MIT License. See LICENSE file for details.

## Disclaimer

Not affiliated with or endorsed by Philips or Versuni. Based on the [ShorMeneses/philips-airplus-homeassistant](https://github.com/ShorMeneses/philips-airplus-homeassistant) project. Use at your own risk.
