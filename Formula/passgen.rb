class Passgen < Formula
  desc "Menu bar password generator with global hotkey"
  homepage "https://github.com/VasilyPolyuhovich/Passgen"
  url "https://github.com/VasilyPolyuhovich/Passgen/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "PLACEHOLDER_SHA256"
  license "MIT"
  head "https://github.com/VasilyPolyuhovich/Passgen.git", branch: "main"

  depends_on xcode: ["14.0", :build]
  depends_on :macos

  def install
    # Build the executable
    system "swift", "build", "-c", "release", "--disable-sandbox"

    # Install binary
    bin.install ".build/release/passgen"

    # Create .app bundle structure
    app_contents = prefix/"PasswordGen.app/Contents"
    (app_contents/"MacOS").mkpath
    (app_contents/"Resources").mkpath

    # Copy executable to .app bundle
    cp bin/"passgen", app_contents/"MacOS/passgen"

    # Create Info.plist
    (app_contents/"Info.plist").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleExecutable</key>
        <string>passgen</string>
        <key>CFBundleIdentifier</key>
        <string>com.vasily.passgen</string>
        <key>CFBundleName</key>
        <string>PasswordGen</string>
        <key>CFBundleDisplayName</key>
        <string>PasswordGen</string>
        <key>CFBundleVersion</key>
        <string>#{version}</string>
        <key>CFBundleShortVersionString</key>
        <string>#{version}</string>
        <key>CFBundlePackageType</key>
        <string>APPL</string>
        <key>LSMinimumSystemVersion</key>
        <string>12.0</string>
        <key>LSUIElement</key>
        <true/>
        <key>NSHighResolutionCapable</key>
        <true/>
      </dict>
      </plist>
    XML
  end

  def caveats
    <<~EOS
      To start PasswordGen:
        open #{opt_prefix}/PasswordGen.app

      To start automatically at login:
        1. Open System Preferences → Users & Groups → Login Items
        2. Add #{opt_prefix}/PasswordGen.app

      For global hotkey to work, grant Accessibility permission:
        System Preferences → Privacy & Security → Accessibility
        Add and enable PasswordGen

      Default hotkey: ⌘⇧P (Cmd+Shift+P)
    EOS
  end

  test do
    assert_predicate bin/"passgen", :exist?
    assert_predicate bin/"passgen", :executable?
  end
end
