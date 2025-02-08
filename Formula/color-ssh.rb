class ColorSsh < Formula
  desc "A Rust-based SSH client with syntax highlighting."
  homepage "https://github.com/karsyboy/color-ssh"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.4.1/color-ssh-aarch64-apple-darwin.tar.xz"
      sha256 "64719ed321aaf34aad79758f0670d01726dafab745496d0d71402796a175e263"
    end
    if Hardware::CPU.intel?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.4.1/color-ssh-x86_64-apple-darwin.tar.xz"
      sha256 "7cc7390e69956b430dd3c332d836b35f9649f4c5be32acbdfafec88434559a57"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.4.1/color-ssh-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "947b5a8a36c2ac7a0ebeaa4f04b92832f53850e3c8fbf5d31a3d77aeba64e04c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.4.1/color-ssh-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bb4ebf653e4c9a1e6b1f235be00b812a73792f1868bf6158a666c2808de50b34"
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
