{
  description = "Personal flake templates";

  outputs = { self, ... }: {
    templates = {
      flake-parts = {
        path = ./flake-parts;
        description = "Simple flake parts flake";
      };
      rust = {
        path = ./rust;
        description = "Simple rust devshell flake";
      };
    };

    defaultTemplate = self.templates.flake-parts;
  };
}
