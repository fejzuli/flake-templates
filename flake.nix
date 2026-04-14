{
  description = "Personal flake templates";

  outputs = { self, ... }: {
    templates = {
      flake-parts = {
        path = ./flake-parts;
        description = "Simple flake parts flake";
      };
    };

    defaultTemplate = self.templates.flake-parts;
  };
}
