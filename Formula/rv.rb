class Rv < Formula
  desc "Ruby version management, but fast"
  homepage "https://spinel.coop/rv"
  version "0.1.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/spinel-coop/rv/releases/download/v0.1.0/rv-aarch64-apple-darwin.tar.xz"
    sha256 "20aeb23f6661197380f2b8d0c86e6c8716b5d870b5276c05640f5fc2a8b6447c"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/spinel-coop/rv/releases/download/v0.1.0/rv-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bbb8d14e83aa3352f0dc17af1f1f250ee18ac47eb06532c5beb4ef13ba7a76c2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/spinel-coop/rv/releases/download/v0.1.0/rv-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "73c78c8cbb892a976313c07d5682cf01333d4938832e6ba0de72305a8cdbeb42"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
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
    bin.install "rv" if OS.mac? && Hardware::CPU.arm?
    bin.install "rv" if OS.linux? && Hardware::CPU.arm?
    bin.install "rv" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
