{ pkgs, ... }:

{
  environment = {
    variables = {
      JDK_HOME = "/etc/jdk11/lib/openjdk/";
      JAVA_HOME = "/etc/jdk11/lib/openjdk/";
    }; 

    # IntelliJ
    etc.jdk11 = with pkgs; {
        source = jdk11;
    };

    systemPackages = (with pkgs; [
      jetbrains.idea-community
    ]);
  };
}
