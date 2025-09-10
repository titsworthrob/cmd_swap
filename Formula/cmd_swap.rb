class CmdSwap < Formula
  desc "Swap selected text with clipboard contents (macOS)"
  homepage "https://github.com/titsworthrob/cmd_swap"
  url "https://github.com/titsworthrob/cmd_swap/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "c3c60e6aaf511a9afd2e50b9b5cfd1b99599ddc0194f38da68463d6619b05749"
  license "MIT"

  depends_on :macos

  def install
    bin.install "cmd_swap.rb" => "cmd_swap"
  end

  test do
    system "#{bin}/cmd_swap", "--help"
  end
end
