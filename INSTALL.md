# Zen Ambience — Installation Guide

Four ways to run it. Pick the one that fits your setup.

---

## Quick Comparison

| Method | Dependencies | Install Time | Platform |
|---|---|---|---|
| **PWA (Browser)** | None — just a browser | 10 seconds | Windows / macOS / Linux / Android / iOS |
| **Chrome Extension** | Chrome / Edge / Brave | 30 seconds | Windows / macOS / Linux / ChromeOS |
| **Antigravity Extension** | Antigravity IDE | Already installed | Windows / macOS / Linux |
| **CLI (PowerShell)** | PowerShell 7+ | 1 minute | Windows |
| **CLI (zsh)** | zsh + mpv | 1 minute | macOS / Linux |

---

## Method 1 — PWA (Browser, any device)

**Dependencies:** None. Any modern browser.

### Steps

1. Open **https://aayushrajaji-09.github.io/zen-code-ambience/**
2. Press any channel to play.
3. *(Optional — Install as app)*
   - **Chrome / Edge (desktop):** Click the install icon  in the address bar → "Install"
   - **Android Chrome:** Tap the banner → "Add to Home Screen"
   - **iOS Safari:** Share → "Add to Home Screen"

### What you get
- Full 9-channel sound mixer
- Master volume, skip tracks, EQ visualizer
- Works offline (cached tracks replay without internet)
- No installation, no permissions, no updates to manage

---

## Method 2 — Chrome Extension

**Dependencies:** Google Chrome, Microsoft Edge, Brave, or any Chromium-based browser (version 114+ for side panel).

### Steps

1. Clone or download the repository:
   ```bash
   git clone https://github.com/AayushRajaji-09/zen-code-ambience.git
   ```
   Or download and extract the ZIP from GitHub.

2. Open **chrome://extensions** in your browser.

3. Enable **Developer mode** (toggle in top-right corner).

4. Click **Load unpacked** → select the `extension/` folder from the repo.

5. Pin the extension:
   - Click the puzzle piece icon in the toolbar
   - Find "Zen Ambience" → click the pin icon

### Usage

| Action | How |
|---|---|
| **Open popup** | Click the extension icon in the toolbar |
| **Open side panel** | Right-click the extension icon → "Open side panel" |
| **Keyboard shortcut** | `chrome://extensions/shortcuts` → set a global hotkey |

### Side panel (recommended)
The side panel keeps Zen Ambience open while you browse other tabs. Audio continues playing in the background. To open:
- Click the extension icon, then click "Open side panel"
- Or use `Ctrl+B` (customisable in extension shortcuts)

---

## Method 3 — Antigravity IDE Extension

**Dependencies:** Antigravity IDE (code editor).

### Steps

The extension is already built and bundled. To activate:

1. Open Antigravity IDE.
2. Go to the Extensions panel (Ctrl+Shift+X).
3. Search for **"Zen Ambience"** or **"aayush.zen-code-ambience"**.
4. Click **Install**.
5. Open a file — the Zen Ambience panel appears in the sidebar.

### Manual install (if marketplace is unavailable)

Copy the `zen-code-ambience/` folder to your Antigravity extensions directory:

| OS | Path |
|---|---|
| Windows | `%USERPROFILE%\.antigravity\extensions\aayush.zen-code-ambience-1.0.0\` |
| Windows (IDE) | `%USERPROFILE%\.antigravity-ide\extensions\aayush.zen-code-ambience-1.0.0\` |
| macOS / Linux | `~/.antigravity/extensions/aayush.zen-code-ambience-1.0.0/` |

```bash
# Example (Windows PowerShell)
Copy-Item -Recurse zen-code-ambience "$env:USERPROFILE\.antigravity\extensions\aayush.zen-code-ambience-1.0.0\"
```

Then restart Antigravity.

---

## Method 4 — CLI (PowerShell)

**Dependencies:**
- **PowerShell 7+** — [Download](https://github.com/PowerShell/PowerShell/releases)
- Audio device (built-in speakers / headphones)

*Note: On Windows 10/11, the built-in `powershell.exe` (v5.1) works but PowerShell 7 is recommended for best compatibility.*

### Steps

1. Clone the repo or download `zen-ambiator.ps1`:
   ```bash
   git clone https://github.com/AayushRajaji-09/zen-code-ambience.git
   cd zen-code-ambience
   ```

2. Run the script:
   ```powershell
   pwsh ./zen-ambiator.ps1
   ```
   Or if using Windows PowerShell:
   ```powershell
   powershell ./zen-ambiator.ps1
   ```

### CLI Controls

| Command | Action |
|---|---|
| `1`–`9` | Toggle play/pause for a channel |
| `s 1`–`s 9` | Skip to next track |
| `v 1 80` | Set channel volume (0–100) |
| `mv 70` | Set master volume (all channels) |
| `m` | Mute all |
| `q` | Quit |

---

## Method 5 — CLI (zsh + mpv)

**Dependencies:**
- **zsh** — default shell on macOS, installable on Linux
- **mpv** — [Download](https://mpv.io/installation/)
  - macOS: `brew install mpv`
  - Ubuntu/Debian: `sudo apt install mpv`
  - Arch: `sudo pacman -S mpv`

### Steps

1. Clone the repo:
   ```bash
   git clone https://github.com/AayushRajaji-09/zen-code-ambience.git
   cd zen-code-ambience
   ```

2. Make the script executable:
   ```bash
   chmod +x zen-ambiator.zsh
   ```

3. Run:
   ```bash
   ./zen-ambiator.zsh
   ```

### Controls

Same as the PowerShell version: number keys toggle channels, `s` skips, `v` sets volume, `mv` master volume, `m` mute, `q` quit.

---

## Troubleshooting

### "No sound plays" — PWA / Chrome Extension

1. Check that **master volume** is not at 0 (bottom bar slider).
2. Click a channel — the play button should turn  and the EQ bars should animate.
3. If EQ animates but no sound:
   - Check your system audio output device.
   - Open browser audio mixer (right-click volume icon → "Open Volume Mixer") and ensure the browser is not muted.
4. Some audio tracks are fetched from SoundHelix and GitHub — an internet connection is required for first play. Once cached, offline replay works.

### "Extension won't load" — Chrome

1. Make sure you selected the `extension/` folder, not the repo root.
2. Verify the folder contains `manifest.json`.
3. Check for errors in `chrome://extensions` — click "Errors" on the Zen Ambience card.

### "Command not found" — CLI (zsh)

Install mpv:
```bash
# macOS
brew install mpv

# Ubuntu / Debian
sudo apt update && sudo apt install mpv
```

### "Execution policy error" — CLI (PowerShell)

PowerShell may block script execution. Run this once:
```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

---

## File Reference

```
repo root
├── docs/                          ← PWA website (GitHub Pages)
│   ├── index.html                 ← Web app
│   ├── manifest.json              ← PWA install manifest
│   ├── sw.js                      ← Service worker (caching)
│   └── icons/                     ← App icons
├── extension/                     ← Chrome extension
│   ├── manifest.json              ← Extension manifest (V3)
│   ├── popup.html                 ← Popup / side panel UI
│   └── icons/
├── zen-code-ambience/             ← Antigravity IDE extension
│   ├── webview.html               ← Main webview
│   ├── extension.js               ← Extension logic
│   └── package.json
├── zen-ambiator.ps1               ← PowerShell CLI player
├── zen-ambiator.zsh               ← zsh/mpv CLI player
└── INSTALL.md                     ← This file
```

---

## License

MIT — free to use, modify, and distribute.
