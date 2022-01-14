{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cadvisor";
  version = "0.39.2";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cadvisor";
    rev = "v${version}";
    sha256 = "sha256-nZC0MnDtSYQnGhXWxUla71fbpUYdrC9Ot+aIYnSqbFM=";
  };

  modRoot = "./cmd";

  vendorSha256 = "sha256-oIdjPWGAjXA2SHfNFscWrCQyo27dzCHYO1Oi2A5mR7c=";

  ldflags = [ "-ldflags=-s -w -X github.com/google/cadvisor/version.Version=${version}" ];

  postInstall = ''
    mv $out/bin/{cmd,cadvisor}
    rm $out/bin/example
  '';

  preCheck = ''
    rm internal/container/mesos/handler_test.go
  '';

  meta = with lib; {
    description = "Analyzes resource usage and performance characteristics of running docker containers";
    homepage = "https://github.com/google/cadvisor";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
