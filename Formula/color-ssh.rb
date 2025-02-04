class ColorSsh < Formula
  desc "A Rust-based SSH client with syntax highlighting."
  homepage "https://github.com/karsyboy/color-ssh"
  version "0.3.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.3.9/color-ssh-aarch64-apple-darwin.tar.xz"
      sha256 "68b10058f21459ac6bc300c029073fadb8880be9302e5b201406a4e092758c5a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.3.9/color-ssh-x86_64-apple-darwin.tar.xz"
      sha256 "d64771d19aea4e96448174b4fec155e643996ec8fff7d13c32772c183a4d7ea3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.3.9/color-ssh-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2e35d374893d81e12ec5aa4f20aedc871cd6e5362c36b22dedd669e50c14f8f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.3.9/color-ssh-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f48f1268ea4f7f1389b73f7159128b48d967e2e4e2393c4cba10b39a4afd4115"
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
