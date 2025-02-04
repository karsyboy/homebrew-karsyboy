class ColorSsh < Formula
  desc "A Rust-based SSH client with syntax highlighting."
  homepage "https://github.com/karsyboy/color-ssh"
  version "0.3.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.3.11/color-ssh-aarch64-apple-darwin.tar.xz"
      sha256 "416b170da12da54cd798a4d28fc6942b82e5f91ef189c580faa202a42208cc0f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.3.11/color-ssh-x86_64-apple-darwin.tar.xz"
      sha256 "fba6cef776c1dd7f789a1e6fc8c09f9ea5309a6cb0a0da4010785af4c80fc05c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.3.11/color-ssh-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7e21c6e923a2765a578988a093966785a4a84daa7eb437619acdb5342102f720"
    end
    if Hardware::CPU.intel?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.3.11/color-ssh-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a3db23be7e0543bea2157c711c67f93b00fc8300321207e287a8ad7e98e1e73c"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "csh" if OS.mac? && Hardware::CPU.arm?
    bin.install "csh" if OS.mac? && Hardware::CPU.intel?
    bin.install "csh" if OS.linux? && Hardware::CPU.arm?
    bin.install "csh" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
