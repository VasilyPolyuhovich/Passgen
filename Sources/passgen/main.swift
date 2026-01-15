import AppKit
import HotKey
import Security

// MARK: - Password Generator

struct PasswordConfig {
    var length: Int = 16
    var uppercase: Bool = true
    var lowercase: Bool = true
    var digits: Bool = true
    var special: Bool = true
    var specialChars: String = "!@#$%^&*"
}

func generatePassword(config: PasswordConfig) -> String? {
    var charset = ""
    if config.uppercase { charset += "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    if config.lowercase { charset += "abcdefghijklmnopqrstuvwxyz" }
    if config.digits { charset += "0123456789" }
    if config.special { charset += config.specialChars }

    guard !charset.isEmpty else { return nil }

    let chars = Array(charset)
    var bytes = [UInt8](repeating: 0, count: config.length)
    guard SecRandomCopyBytes(kSecRandomDefault, config.length, &bytes) == errSecSuccess else {
        return nil
    }

    return String(bytes.map { chars[Int($0) % chars.count] })
}

// MARK: - App Delegate

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var hotKey: HotKey?

    private var config = PasswordConfig()

    // Hotkey options
    private let hotkeyOptions: [(name: String, key: Key, modifiers: NSEvent.ModifierFlags)] = [
        ("⌘⇧P", .p, [.command, .shift]),
        ("^⌥P", .p, [.control, .option]),
        ("⌘⌥G", .g, [.command, .option]),
    ]
    private var selectedHotkeyIndex = 0

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupStatusItem()
        setupHotKey()
    }

    // MARK: - Status Item

    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "key.fill", accessibilityDescription: "Password Generator")
        }

        rebuildMenu()
    }

    private func rebuildMenu() {
        let menu = NSMenu()

        // Generate
        let genItem = NSMenuItem(title: "Generate Password", action: #selector(generate), keyEquivalent: "")
        genItem.target = self
        menu.addItem(genItem)

        menu.addItem(NSMenuItem.separator())

        // Length submenu
        let lengthMenu = NSMenu()
        for len in [12, 16, 20, 24, 32] {
            let item = NSMenuItem(title: "\(len) characters", action: #selector(setLength(_:)), keyEquivalent: "")
            item.target = self
            item.tag = len
            item.state = config.length == len ? .on : .off
            lengthMenu.addItem(item)
        }
        let lengthItem = NSMenuItem(title: "Length", action: nil, keyEquivalent: "")
        lengthItem.submenu = lengthMenu
        menu.addItem(lengthItem)

        // Characters submenu
        let charsMenu = NSMenu()

        let upperItem = NSMenuItem(title: "Uppercase (A-Z)", action: #selector(toggleUpper), keyEquivalent: "")
        upperItem.target = self
        upperItem.state = config.uppercase ? .on : .off
        charsMenu.addItem(upperItem)

        let lowerItem = NSMenuItem(title: "Lowercase (a-z)", action: #selector(toggleLower), keyEquivalent: "")
        lowerItem.target = self
        lowerItem.state = config.lowercase ? .on : .off
        charsMenu.addItem(lowerItem)

        let digitItem = NSMenuItem(title: "Digits (0-9)", action: #selector(toggleDigits), keyEquivalent: "")
        digitItem.target = self
        digitItem.state = config.digits ? .on : .off
        charsMenu.addItem(digitItem)

        let specialItem = NSMenuItem(title: "Special (!@#$%^&*)", action: #selector(toggleSpecial), keyEquivalent: "")
        specialItem.target = self
        specialItem.state = config.special ? .on : .off
        charsMenu.addItem(specialItem)

        let charsItem = NSMenuItem(title: "Characters", action: nil, keyEquivalent: "")
        charsItem.submenu = charsMenu
        menu.addItem(charsItem)

        // Hotkey submenu
        let hotkeyMenu = NSMenu()
        for (index, opt) in hotkeyOptions.enumerated() {
            let item = NSMenuItem(title: opt.name, action: #selector(setHotkey(_:)), keyEquivalent: "")
            item.target = self
            item.tag = index
            item.state = selectedHotkeyIndex == index ? .on : .off
            hotkeyMenu.addItem(item)
        }
        let hotkeyItem = NSMenuItem(title: "Hotkey", action: nil, keyEquivalent: "")
        hotkeyItem.submenu = hotkeyMenu
        menu.addItem(hotkeyItem)

        menu.addItem(NSMenuItem.separator())

        // Quit
        let quitItem = NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        menu.addItem(quitItem)

        statusItem.menu = menu
    }

    // MARK: - HotKey

    private func setupHotKey() {
        let opt = hotkeyOptions[selectedHotkeyIndex]
        hotKey = HotKey(key: opt.key, modifiers: opt.modifiers)
        hotKey?.keyDownHandler = { [weak self] in
            self?.generate()
        }
    }

    // MARK: - Actions

    @objc private func generate() {
        guard let password = generatePassword(config: config) else {
            NSSound.beep()
            return
        }

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(password, forType: .string)
        NSSound(named: "Morse")?.play()
    }

    @objc private func setLength(_ sender: NSMenuItem) {
        config.length = sender.tag
        rebuildMenu()
    }

    @objc private func toggleUpper() {
        config.uppercase.toggle()
        rebuildMenu()
    }

    @objc private func toggleLower() {
        config.lowercase.toggle()
        rebuildMenu()
    }

    @objc private func toggleDigits() {
        config.digits.toggle()
        rebuildMenu()
    }

    @objc private func toggleSpecial() {
        config.special.toggle()
        rebuildMenu()
    }

    @objc private func setHotkey(_ sender: NSMenuItem) {
        selectedHotkeyIndex = sender.tag
        hotKey = nil
        setupHotKey()
        rebuildMenu()
    }
}

// MARK: - Main

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()
