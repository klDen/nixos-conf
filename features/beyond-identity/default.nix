{ lib, stdenv, fetchurl, dpkg, buildFHSUserEnv
, glibc, glib, openssl, tpm2-tss
, gtk3, gnome, polkit, polkit_gnome
}:

let
  version = "2.45.0-0";
  name = "beyond-identity";

  src = fetchurl {
    url = "https://packages.beyondidentity.com/public/linux-authenticator/deb/ubuntu/pool/focal/main/b/be/${name}_${version}/${name}_${version}_amd64.deb";
    sha512 = "852689d473b7538cdca60d264295f39972491b5505accad897fd924504189f0a6d8b6481cc0520ee762d4642e0f4fd664a03b5741f9ea513ec46ab16b05158f2";
  };

  libPath = lib.makeLibraryPath ([
    glib glibc openssl tpm2-tss
    gtk3 gnome.gnome-keyring
    polkit polkit_gnome
  ]); 
in let beyond-identity = stdenv.mkDerivation {
  pname = name;

  inherit version;
  inherit src;

  dontUnpack = true;

  nativeBuildInputs = [
    dpkg
  ];

  installPhase = ''
    dpkg -x $src .
    mkdir -p $out/opt/beyond-identity

    rm -rf usr/share/doc

    # https://github.com/NixOS/nixpkgs/issues/42117
    sed -i -e 's/auth_self/yes/g' usr/share/polkit-1/actions/com.beyondidentity.endpoint.stepup.policy

    cp -arv usr/{bin,share} $out
    cp -arv opt/beyond-identity/bin $out/opt/beyond-identity

    ln -s $out/opt/beyond-identity/bin/* $out/bin/
  '';

  postFixup = ''
    substituteInPlace \
      $out/share/applications/com.beyondidentity.endpoint.BeyondIdentity.desktop \
      --replace /usr/bin/ $out/bin/
    substituteInPlace \
      $out/share/applications/com.beyondidentity.endpoint.webserver.BeyondIdentity.desktop \
      --replace /opt/ $out/opt/
    substituteInPlace \
      $out/opt/beyond-identity/bin/byndid-web \
      --replace /opt/ $out/opt/
    substituteInPlace \
      $out/bin/beyond-identity \
      --replace /opt/ $out/opt/ \
      --replace /usr/bin/gtk-launch ${gtk3}/bin/gtk-launch

    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      --force-rpath \
      $out/bin/byndid
  '';

  meta = with lib; {
    description = "Passwordless MFA identities for workforces, customers, and developers";
    homepage = "https://www.beyondidentity.com";
    downloadPage = "https://app.byndid.com/downloads";
    license = licenses.unfree;
    maintainers = with maintainers; [ klden ];
    platforms = [ "x86_64-linux" ];
  };
};
# /usr/bin/pkcheck is hardcoded in binary - we need FHS
in buildFHSUserEnv {
   inherit name;

   targetPkgs = pkgs: [
     beyond-identity
     glib glibc openssl tpm2-tss
     gtk3 gnome.gnome-keyring
     polkit polkit_gnome
   ];

   profile = ''
     ${polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 2>/dev/null || true
   '';

   extraInstallCommands = ''
     ln -s ${beyond-identity}/share $out
   '';

   runScript = "beyond-identity";
}
