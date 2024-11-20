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
  format = "pyproject";

  # disabled = python3.pythonOlder "3.9";

  # TODO:How could I handle that better ?
  #  - Ask upstream to loosen the version
  #  - Create a package with the deps ?
  patchPhase = ''
    substituteInPlace pyproject.toml --replace \
      'pdfminer-six = "^20231228"' 'pdfminer-six = "^20240706"'
  '';

  src = fetchFromGitHub {
    owner = "tfeldmann";
    repo = "${pname}";
    rev = "v${version}";
    hash = "sha256-C68S1AFfiOAMuvEU2sBHIgdQkPX6ydied4Kq4ChmLP8=";
  };

  # All requirements are pinned
  pythonRelaxDeps = false;

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = (with python3.pkgs; [
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

  ]) ++ [
    simplematch
    ExifRead
  ];

  pythonImportsCheck = [
    "poetry.core"
  ];

  # Allow for package to use pep420's native namespaces
  pythonNamespaces = [
    "poetry"
  ];

  # https://codeload.github.com/tfeldmann/organize/tar.gz/refs/tags/v3.2.1

  # Tests do not pass
  doCheck = false;
  meta = with lib; {
    description = "";
    homepage = https://github.com/tfeldmann;
    platforms = python3Packages.pyinotify.meta.platforms;
    licence = licenses.gpl2;
    longDescription = ''
    '';
  };
}
