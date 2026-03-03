{ pkgs }: {
  deps = [
    pkgs.python312
  ];
  env = {
    PYTHONPATH = "${pkgs.python312.sitePackages}";
  };
}
