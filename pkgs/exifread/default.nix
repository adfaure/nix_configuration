{
  lib,
  python3,
  fetchPypi,
  mailman,
  nixosTests,
}:
with python3.pkgs;
  buildPythonPackage rec {
    pname = "ExifRead";
    version = "2.3.2";
    format = "setuptools";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-oPdK9QQBaNOIO7yYDv4m0GyJ8Cbchroo6zQQdmLVF2Y=";
    };

    nativeBuildInputs = with python3.pkgs; [
      poetry-core
    ];

    nativeCheckInputs = [
    ];

    # There is an AssertionError
    doCheck = false;

    pythonImportsCheck = [
    ];

    meta = with lib; {
      description = "Mailman archiver plugin for HyperKitty";
      homepage = "https://gitlab.com/mailman/mailman-hyperkitty";
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [qyliss];
    };
  }
