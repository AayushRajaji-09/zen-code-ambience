# Zen Ambience — Installation Guide

Five ways to run it. Pick the one that fits your setup.

---

## Quick Comparison

| Method | Dependencies | Install Time | Platform |
|---|---|---|---|
| **PWA (Browser)** | None — just a browser | 10 seconds | Windows / macOS / Linux / Android / iOS |
| **VS Code Extension** | VS Code | 30 seconds | macOS / Windows / Linux |
| **Chrome Extension** | Chrome / Edge / Brave | 30 seconds | Windows / macOS / Linux / ChromeOS |
| **Antigravity Extension** | Antigravity IDE | Already installed | Windows / macOS / Linux |
| **CLI (PowerShell)** | PowerShell 7+ | 1 minute | Windows |
| **macOS App** | macOS + mpv | 1 minute | macOS |
| **CLI (zsh)** | zsh + mpv | 1 minute | Linux |

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

## Method 2 — VS Code Extension

**Dependencies:** [VS Code](https://code.visualstudio.com/) 1.85+ (macOS / Windows / Linux).

### Option A — Install from VS Code (recommended)

1. Open VS Code.
2. Go to **Extensions** panel (`Cmd+Shift+X` on Mac, `Ctrl+Shift+X` on Windows/Linux).
3. Search for **"Zen Ambience"**.
4. Click **Install**.
5. Click the headphone icon  in the activity bar (left sidebar) → click "Sound Mixer".

### Option B — Install from VSIX (offline / air-gapped)

1. Clone the repo:
   ```bash
   git clone https://github.com/AayushRajaji-09/zen-code-ambience.git
   ```

2. Package the extension (requires `vsce`):
   ```bash
   npm install -g @vscode/vsce
   cd vscode-extension
   vsce package
   ```

3. Install the generated `.vsix`:
   ```bash
   code --install-extension zen-ambience-1.0.0.vsix
   ```

### Option C — Load unpacked (development)

1. Clone the repo.
2. Open VS Code → **Extensions** panel (`Cmd+Shift+X`).
3. Click `...` (top-right) → **Install from VSIX...** → select `vscode-extension/` folder.
   *Or:* Copy the `vscode-extension/` folder to `~/.vscode/extensions/zen-ambience/` and restart VS Code.

### Usage

| Action | How |
|---|---|
| **Open sidebar** | Click the headphone icon  in the left activity bar |
| **Open in editor** | `Cmd+Shift+P` → "Zen Ambience: Open in Editor" |
| **Volume** | Bottom bar slider |
| **Mute all** | Bottom bar "Mute" button |

The sidebar stays open while you code. Audio continues playing when switching tabs or files. On macOS, VS Code's audio is independent of system alerts — no interruptions.

---

## Method 3 — Chrome Extension

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

## Method 4 — Antigravity IDE Extension

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

## Method 5 — CLI (PowerShell)

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

## Method 6 — macOS Native App

**Dependencies:**
- **macOS** 11 (Big Sur) or later
- **mpv** — [Download](https://mpv.io/installation/)
  ```bash
  brew install mpv
  ```

### Option A — Double-click (simplest)

1. Clone the repo:
   ```bash
   git clone https://github.com/AayushRajaji-09/zen-code-ambience.git
   ```

2. Open Finder, navigate to the repo folder.

3. Double-click **`zen-ambiator-macos.command`**.

   Terminal opens with the Zen Ambience interface.

4. *(Optional)* Drag `zen-ambiator-macos.command` to the **Dock** for one-click access.

### Option B — App Bundle (Dock + Spotlight)

The `zen-ambiator-macos.app` bundle can be placed in your Applications folder.

1. **Copy to Applications:**
   ```bash
   cp -r zen-ambiator-macos.app /Applications/Zen\ Ambience.app
   ```

2. **Launch from Spotlight:** Press `Cmd+Space`, type "Zen Ambience", press Enter.

3. **Launch from Dock:** Drag `/Applications/Zen Ambience.app` to the Dock.

4. *(First launch only)* macOS may show "unidentified developer" warning:
   - Go to **System Settings → Privacy & Security**
   - Scroll down — click **Open Anyway** next to "Zen Ambience"
   - Or run once from Terminal:
     ```bash
     xattr -dr com.apple.quarantine /Applications/Zen\ Ambience.app
     ```

### Controls

| Command | Action |
|---|---|
| `1`–`9` | Toggle play/pause for a channel |
| `s1`–`s9` | Skip to next track |
| `mv70` | Set master volume (0–100) |
| `m` | Mute all |
| `q` | Quit |

### macOS-specific features
- **Track change notifications** — macOS notification centre shows the current track when you skip.
- **Touch Bar support** — works automatically if your Mac has a Touch Bar (Terminal app controls).
- **Low resource usage** — mpv uses minimal CPU/battery compared to a browser tab.

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
├── zen-ambiator.zsh               ← zsh/mpv CLI player (Linux)
├── zen-ambiator-macos.command     ← macOS double-clickable player
├── zen-ambiator-macos.app/        ← macOS app bundle (Dock/Spotlight)
├── vscode-extension/              ← VS Code extension
│   ├── package.json
│   ├── extension.js
│   └── media/                     ← Icons
└── INSTALL.md                     ← This file
```

---

## License

MIT — free to use, modify, and distribute.
