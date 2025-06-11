{
  hostname = "argo";
  description = "thinkpad x1 carbon daily driver";

  system = "x86_64-linux";
  modules = [ ./nixos ];

  users = [
    {
      user = "henrym";
      name = "Henry Moore";
      email = "henrydmoore23@gmail.com";
      homeModules = [ ./home ];
    }
  ];
}




