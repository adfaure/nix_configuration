{
  lib,
  python3,
  fetchPypi,
  mailman,
  nixosTests,
}:
with python3.pkgs;
  buildPythonPackage rec {
    pname = "simplematch";
    version = "1.4";
    format = "pyproject";

    disabled = pythonOlder "3.9";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-VadyeLPQaGyzjj/+WjJqX1nCmV8bofoaT2iHLBfK9Ms=";
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
