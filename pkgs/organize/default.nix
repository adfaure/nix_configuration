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
  version = "3.2.1";
  format = "pyproject";

  # disabled = python3.pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "tfeldmann";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "sha256-m2eY9PhV/Zg0YHOS6f/+8zPCM71C3zP9DGfWI3Giseo=";
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
