class Dmt < Formula
  include Language::Python::Virtualenv

  desc "DMT Council CLI — the governed council chat, in your terminal"
  homepage "https://github.com/Evoost-AI-gov/dmt-ai-services"
  url "https://github.com/Evoost-AI-gov/homebrew-dmt/raw/main/dist/dmt_ai_services-0.5.0-py3-none-any.whl"
  sha256 "da4884352037a2bc1a0a97f68302275e3e94c049dab240bc0f22203b162ffff3"
  license :cannot_represent  # proprietary — DMT internal

  depends_on "python@3.13"

  # The CLI talks to the governed gateway over HTTP; these are its only
  # third-party runtime deps (the gateway itself is NOT installed here).
  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/b8/1f/10f9d47a63d3a2e61b2c43e15bee6b95682aab827018f9a1b97a80787e25/msal-1.38.0.tar.gz"
    sha256 "4f10ff1257bacfd1781f22e85bd2b8d43ad1b490f3b6aafd7906671cadedd464"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dmt --version")
  end
end
