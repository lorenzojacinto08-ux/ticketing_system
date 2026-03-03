{ pkgs }: {
  deps = [
    pkgs.python312
    pkgs.python312Packages.pip
  ];
  env = {
    PYTHONPATH = "${pkgs.python312.sitePackages}";
  };
}
