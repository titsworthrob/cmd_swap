class CmdSwap < Formula
  desc "Swap selected text with clipboard contents (macOS)"
  homepage "https://github.com/titsworthrob/cmd_swap"
  url "https://github.com/titsworthrob/cmd_swap/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "48d90aee30f5e806cc563aa920502a239c7062e1a7e07e6beb5b987592096a21"
  license "MIT"

  depends_on :macos

  def install
    bin.install "cmd_swap.rb" => "cmd_swap"
  end

  test do
    system "#{bin}/cmd_swap", "--help"
  end
end
