{
  services.openssh = { 
    enable = true;
    settings = {
      AllowAgentForwarding = true;
    };
  };
}