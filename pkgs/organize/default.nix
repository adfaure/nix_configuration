{
  lib,
  python3,
  fetchFromGitHub,
  python3Packages,
  simplematch,
  ExifRead,
}:
python3Packages.buildPythonApplication rec {
  pname = "organize";
  version = "3.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adfaure";
    repo = "${pname}";
    rev = "uv";
    hash = "sha256-7KBpQpkgR9IFPldgrj7t3g2A8bTq3FZZGcp/h/+731k=";
  };

  build-system = [python3.pkgs.setuptools];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
  ];

  buildInputs = with python3.pkgs; [
    # Dev dependencies for test
    coverage
    mypy
    pyfakefs
    pytest-cov
    pytest
    requests
    ruff
    types-pyyaml
  ];

  propagatedBuildInputs =
    (with python3.pkgs; [
      # neo4j
      pyyaml
      pydantic
      rich
      jinja2
      jinja2
      pythonRelaxDepsHook

      arrow
      docopt-ng
      docx2txt
      # macos-tags
      natsort
      pdfminer-six
      platformdirs
      pyyaml
      rich
      send2trash
    ])
    ++ [
      simplematch
      ExifRead
    ];

  doCheck = true;

  meta = {
    description = "";
    broken = true;
    homepage = "https://github.com/tfeldmann";
    platforms = python3Packages.pyinotify.meta.platforms;
    licence = lib.licenses.gpl2;
    longDescription = ''
    '';
  };
}
