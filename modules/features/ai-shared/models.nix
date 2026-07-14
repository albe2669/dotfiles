{
  models = [
    {
      id = "corti-s1";
      name = "Corti S1 (GLM5.2)";
      reasoning = true;
      input = [ "text" ];
      contextWindow = 524288;
      cost = { input = 2; output = 8; cacheRead = 0.2; cacheWrite = 0; };
    }
    {
      id = "corti-s1-instant";
      name = "Corti S1 Instant (GLM5.2-nothinking)";
      reasoning = false;
      input = [ "text" ];
      contextWindow = 524288;
      cost = { input = 2; output = 8; cacheRead = 0.2; cacheWrite = 0; };
    }
    {
      id = "corti-s1-mini";
      name = "Corti S1 Mini (Qwen3.6)";
      reasoning = true;
      input = [ "text" ];
      contextWindow = 262144;
      cost = { input = 1; output = 4; cacheRead = 0.1; cacheWrite = 0; };
    }
    {
      id = "corti-s1-mini-instant";
      name = "Corti S1 Mini Instant (Qwen3.6-nothinking)";
      reasoning = false;
      input = [ "text" ];
      contextWindow = 262144;
      cost = { input = 1; output = 4; cacheRead = 0.2; cacheWrite = 0; };
    }
  ];
}
