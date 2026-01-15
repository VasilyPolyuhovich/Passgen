# PassGen

Lightweight menu bar password generator for macOS with global hotkey support.

![macOS](https://img.shields.io/badge/macOS-12%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![License](https://img.shields.io/badge/License-MIT-green)

## Features

- Menu bar app (no Dock icon)
- Global hotkey (⌘⇧P by default)
- Cryptographically secure passwords (SecRandomCopyBytes)
- Configurable length (12-32 characters)
- Character options (uppercase, lowercase, digits, special)
- Instant copy to clipboard
- No dependencies, no Xcode required

## Installation

### Homebrew (recommended)

```bash
brew tap VasilyPolyuhovich/Passgen
brew install passgen
```

Then start the app:
```bash
open $(brew --prefix)/opt/passgen/PasswordGen.app
```

### Manual

```bash
git clone https://github.com/VasilyPolyuhovich/Passgen.git
cd passgen
./build.sh
open PasswordGen.app
```

### One-liner

```bash
curl -sL https://raw.githubusercontent.com/vasily/passgen/main/install.sh | bash
```

## Usage

1. Click the 🔑 icon in menu bar to access settings
2. Press **⌘⇧P** (or your configured hotkey) anywhere to generate password
3. Password is automatically copied to clipboard

### Hotkey Options

- ⌘⇧P (Cmd+Shift+P) — default
- ^⌥P (Ctrl+Option+P)
- ⌘⌥G (Cmd+Option+G)

### Settings

- **Length**: 12, 16, 20, 24, 32 characters
- **Characters**: Uppercase, Lowercase, Digits, Special (!@#$%^&*)

## Requirements

- macOS 12.0+
- Accessibility permission (for global hotkey)

Grant permission in: **System Preferences → Privacy & Security → Accessibility**

## Building from Source

Requires Xcode Command Line Tools:

```bash
xcode-select --install
```

Build:
```bash
swift build -c release
./build.sh  # Creates PasswordGen.app bundle
```

## License

MIT License. See [LICENSE](LICENSE) for details.
