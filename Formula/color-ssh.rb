class ColorSsh < Formula
  desc "A Rust-based SSH client with syntax highlighting."
  homepage "https://github.com/karsyboy/color-ssh"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.4.0/color-ssh-aarch64-apple-darwin.tar.xz"
      sha256 "e0d763b21539b3a3f849e4d0ac697a6fce90b8c5e066ee087fb05eff3efcb915"
    end
    if Hardware::CPU.intel?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.4.0/color-ssh-x86_64-apple-darwin.tar.xz"
      sha256 "c26ef64103bd6ccdc499ccb2b4d75ec8c11d6082a36715847e1fffb18478094a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.4.0/color-ssh-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "eec6d6d36f76c43e8ea05675ad31997345fffb9bfe6420a2074c10e9f8659570"
    end
    if Hardware::CPU.intel?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.4.0/color-ssh-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b7232591ece44e0c16c4070a0c366189b7a0d97493449d120d1a81fc0dbeaf8f"
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
