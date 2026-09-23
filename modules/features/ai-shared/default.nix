{
  category = "Tools";
  name = "ai";
  software = [
    "openspec"
    "openspecui"
  ];

  homeManager = {
    inputs,
    system,
    ...
  }: {
    home.packages = [
      inputs.llm-agents.packages.${system}.openspec
      inputs.llm-agents.packages.${system}.openspecui
    ];
  };
}
