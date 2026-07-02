# Zen Code Ambience 🧘

A premium, highly-customizable sidebar sound mixer extension for your IDE designed to help you focus, relax, and code in peace.

## Features

- **14 Audio Channels**: Organized into collapsible categories (Nature, Weather, Cozy, Music).
- **⏭ Skip Track**: Each channel contains a library of 3-5 alternate tracks. Cycle through them instantly.
- **🔊 Master Volume**: Proportional global volume scaling.
- **📻 Web Audio White Noise**: Procedurally generated continuous white noise (no files, zero-latency).
- **Smooth Fade Transitions**: 300ms volume fade when toggling play/pause to prevent sudden audio pops.
- **Vibrant Aesthetics**: Glassmorphic dark-theme design with pulsing borders and equalizer visualizers.

---

## 🧠 The Science of Sound & Productivity

Listening to music and ambient noise has been scientifically proven to boost focus, efficiency, and creative problem-solving:

- **State Positive Affect & Efficiency**: In a study by **Dr. Teresa Lesiuk** (University of Miami), software developers who listened to music completed tasks more quickly and produced higher-quality ideas compared to working in silence. The music acts as a mood regulator, elevating positive affect, which in turn enhances cognitive thinking and systematic problem-solving.
- **Creative Abstract Thinking**: Research published by **Dr. Ravi Mehta** (University of Illinois) shows that moderate ambient noise (~70 dB, similar to café chatter or soft rain) triggers a slight cognitive challenge that fosters abstract processing, leading to higher creative output compared to absolute silence or loud environments.

By mixing natural sounds, rain, and instrumental music, you can design the optimal acoustic sweet-spot for your brain to trigger a flow state.

---


## Workspace Setup

This repository contains the configuration and tools for the **Zen Code Ambience** extension:
- `zen-code-ambience/` — Extension source code.
- `zen-ambiator.ps1` — Standalone, interactive PowerShell CLI version of the mixer.
- `.agents/` & `.opencode/` — Development configuration and agent templates.
- `opencode.json` — Workspace skill manifest.

---

## 💻 CLI Version (`zen-ambiator.ps1`)

If you want to use the mixer directly from your terminal (outside the IDE), run:
```powershell
./zen-ambiator.ps1
```

### CLI Features:
- Fully interactive console HUD with high-tech ASCII art.
- Monospace progress bars displaying channel volumes.
- Toggle channels, skip tracks, and adjust master/channel volumes with simple commands:
  - `[Num]` (e.g. `1`, `2`) — Toggle play/pause for a channel.
  - `s [Num]` (e.g. `s 1`) — Skip track.
  - `v [Num] [Val]` (e.g. `v 1 80`) — Set channel volume (0-100%).
  - `mv [Val]` (e.g. `mv 70`) — Set master gain volume.
  - `m` — Mute all.
  - `q` — Quit.
