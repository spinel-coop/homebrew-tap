class Rv < Formula
  desc "Ruby version management, but fast"
  homepage "https://spinel.coop/rv"
  version "0.1.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/spinel-coop/rv/releases/download/v0.1.1/rv-aarch64-apple-darwin.tar.xz"
    sha256 "3634bb756c19f534bc281ec5f43e8210564bf8888dab0a76e19c56c695eead2c"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/spinel-coop/rv/releases/download/v0.1.1/rv-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3d4aaa4de059ddb365240be9a8f8d4cbe9afe477be5820e2fd7196e095c65982"
    end
    if Hardware::CPU.intel?
      url "https://github.com/spinel-coop/rv/releases/download/v0.1.1/rv-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1467e871946e47b81fa3faaa1c1fd1a178be65bedacb924a6f5105b76df5cd38"
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
