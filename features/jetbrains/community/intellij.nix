{ pkgs, ... }:

{
  environment = {
    variables = {
      JDK_HOME = "/etc/jdk11/lib/openjdk/";
      JAVA_HOME = "/etc/jdk11/lib/openjdk/";
    }; 

    systemPackages = (with pkgs; [
      jetbrains.idea-community
    ]);
  };
}
