class CmdSwap < Formula
  desc "Swap selected text with clipboard contents (macOS)"
  homepage "https://github.com/titsworthrob/cmd_swap"
  url "https://github.com/titsworthrob/cmd_swap/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "d5558cd419c8d46bdc958064cb97f963d1ea793866414c025906ec15033512ed"
  license "MIT"

  depends_on :macos

  def install
    bin.install "cmd_swap.rb" => "cmd_swap"
  end

  test do
    system "#{bin}/cmd_swap", "--help"
  end
end
