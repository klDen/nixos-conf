{ lib, stdenv, fetchurl, dpkg
, openssl, tpm2-tss, glibc, glib, gtk3
, polkit, polkit_gnome, dbus, gnome, libnotify, libsecret
}:

let
  version = "2.45.0-0";
  name = "beyond-identity";

  src = fetchurl {
    url = "https://packages.beyondidentity.com/public/linux-authenticator/deb/ubuntu/pool/focal/main/b/be/${name}_${version}/${name}_${version}_amd64.deb";
    sha512 = "852689d473b7538cdca60d264295f39972491b5505accad897fd924504189f0a6d8b6481cc0520ee762d4642e0f4fd664a03b5741f9ea513ec46ab16b05158f2";
  };

  libPath = lib.makeLibraryPath ([
    glib
    glibc
    openssl
    tpm2-tss
    dbus
    gnome.gnome-keyring
    gtk3
    libnotify
    libsecret
    polkit
    polkit_gnome
  ]); 
in stdenv.mkDerivation {
  pname = name;

  inherit version;
  inherit src;

  # compilation
  nativeBuildInputs = [
    dpkg
  ];

  dontUnpack = true;

  installPhase = ''
    dpkg -x $src .
    mkdir -p $out/opt/beyond-identity

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

    # /usr/bin/pkcheck is hardcoded in binary. change for buildFHSUserEnv??
    # --replace /usr/bin/pkcheck ${polkit}/bin/pkcheck

    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      --force-rpath \
      $out/bin/byndid
  '';

  meta = with lib; {
    description = "Linux client for beyond-identity";
    homepage = "https://www.beyondidentity.com";
    downloadPage = "https://app.byndid.com/downloads";
    license = licenses.unfree;
    maintainers = with maintainers; [ klden ];
    platforms = [ "x86_64-linux" ];
  };
}

