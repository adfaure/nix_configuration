{...}: {
  flake.templates = {
    rust = {
      path = ./templates/rust;
      description = "Rust devshell";
    };
    python = {
      path = ./templates/simple-with-python;
      description = "Simple devshell with python example";
    };
  };
}
