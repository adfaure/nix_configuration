{
  lib,
  pkgs,
  python3,
  python3Packages,
  fetchPypi,
  fetchFromGitHub,
  mailman,
  nixosTests,
}: let
  mozjpeg_lossless_optimization = python3Packages.buildPythonApplication rec {
    pname = "mozjpeg_lossless_optimization";
    version = "1.1.3";

    src = fetchPypi {
      inherit version;
      pname = "mozjpeg-lossless-optimization";
      sha256 = "sha256-cl2Ydy6UP8oYsIAcuU5kXEd/9S5WrQsnvdt23fCRyj4=";
    };

    nativeBuildInputs = [pkgs.mozjpeg pkgs.cmake];
    propagatedBuildInputs = [python3Packages.cffi];
    dontUseCmakeConfigure = true;
  };
in
  python3Packages.buildPythonPackage rec {
    version = "5.7.0";
    pname = "kcc";

    src = fetchFromGitHub {
      owner = "ciromattia";
      repo = "${pname}";
      rev = "v${version}";
      hash = "sha256-LUUKCSjVrqlnkMnnx1h0BUZ/0rO/ezlIwgXE9wq9uQQ=";
    };

    nativeBuildInputs = with python3Packages; [
      pip
      raven
      requests
      # Tests fail because they need this package which doesn't build
      # pyside6
    ];
    propagatedBuildInputs =
      [pkgs.p7zip]
      ++ (with python3Packages; [
        psutil
        pillow
        python-slugify
        natsort
        mozjpeg_lossless_optimization
        distro
      ]);

    # There is an AssertionError
    doCheck = false;

    meta = with lib; {
      description = "";
      homepage = "";
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [qyliss];
    };
  }
