{
  lib,
  stdenvNoCC,
  fetchurl,
  fetchFromGitHub,
  makeWrapper,
  openjdk21,
  gnused,
  autoPatchelfHook,
  wrapGAppsHook3,
  gtk3,
  glib,
  webkitgtk_4_1,
  glib-networking,
  maven,
  writers,
  override_xmx ? "2048m",
}:
let
  dbeaver-agent = maven.buildMavenPackage rec {
    pname = "dbeaver-agent";
    version = "25.2";

    src = fetchFromGitHub {
      owner = "wgzhao";
      repo = "dbeaver-agent";
      tag = "v${version}";
      hash = "sha256-m+kkIP9WnNa/sXVuHUuUUnamcAvFE3l68G2sERsAyMw=";
    };

    mvnHash = "sha256-OVZ34S4O/gucb9pR+IpMAsG7+I/3QKa8+Q0ZIc3STpw=";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/dbeaver-agent
      cp -r target/* $out/share/dbeaver-agent/
      cp -rf $out/share/dbeaver-agent/dbeaver-agent-${version}-SNAPSHOT-jar-with-dependencies.jar $out/share/dbeaver-agent/dbeaver-agent.jar

      runHook postInstall
    '';
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dbeaver-ultimate";
  version = "25.2.0";

  src =
    let
      inherit (stdenvNoCC.hostPlatform) system;
      selectSystem = attrs: attrs.${system} or (throw "Unsupported system: ${system}");
      suffix = selectSystem {
        x86_64-linux = "linux.gtk.x86_64-nojdk.tar.gz";
        aarch64-linux = "linux.gtk.aarch64-nojdk.tar.gz";
      };
      hash = selectSystem {
        x86_64-linux = "sha256-qzFOyHay5t3GAyd5YwdlpQ3hsQbceYig40NSiQPQpMo=";
        aarch64-linux = "sha256-ip/EoJHY8mlDv348J0o3CwlqcoAXtpUzMSUyujbDtw0=";
      };
    in
    fetchurl {
      url = "https://dbeaver.com/downloads-ultimate/${finalAttrs.version}/dbeaver-ue-${finalAttrs.version}-${suffix}";
      inherit hash;
    };

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ [
    gnused
    wrapGAppsHook3
    autoPatchelfHook
  ];

  dontConfigure = true;
  dontBuild = true;

  prePatch = ''
    substituteInPlace dbeaver.ini \
      --replace-fail '-Xmx2048m' '-Xmx${override_xmx}'
    echo "-javaagent:${dbeaver-agent}/share/dbeaver-agent/dbeaver-agent.jar" >> dbeaver.ini
    echo "-Xbootclasspath/a:${dbeaver-agent}/share/dbeaver-agent/dbeaver-agent.jar" >> dbeaver.ini
  '';

  preInstall = ''
    # most directories are for different architectures, only keep what we need
    shopt -s extglob
    pushd plugins/com.sun.jna_*/com/sun/jna/
    rm -r !(ptr|internal|linux-x86-64|linux-aarch64)/
    popd
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/dbeaver $out/bin
    cp -r * $out/opt/dbeaver
    makeWrapper $out/opt/dbeaver/dbeaver $out/bin/dbeaver \
      --prefix PATH : "${openjdk21}/bin" \
      --set JAVA_HOME "${openjdk21.home}" \
      --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules" \
      --prefix LD_LIBRARY_PATH : "$out/lib:${
        lib.makeLibraryPath [
          gtk3
          glib
          webkitgtk_4_1
          glib-networking
        ]
      }"

    makeWrapper ${writers.writeBash "dbeaver-gen-license" ''
      ${openjdk21}/bin/java -cp "$DBEAVER_PATH/opt/dbeaver/plugins/*:${dbeaver-agent}/share/dbeaver-agent/dbeaver-agent.jar" com.dbeaver.agent.License
    ''} $out/bin/dbeaver-gen-license \
      --set DBEAVER_PATH $out

    mkdir -p $out/share/icons/hicolor/256x256/apps
    ln -s $out/opt/dbeaver/dbeaver.png $out/share/icons/hicolor/256x256/apps/dbeaver.png

    mkdir -p $out/share/applications
    ln -s $out/opt/dbeaver/dbeaver-ue.desktop $out/share/applications/dbeaver.desktop

    substituteInPlace $out/opt/dbeaver/dbeaver-ue.desktop \
      --replace-fail "/usr/share/dbeaver-ue/dbeaver.png" "dbeaver" \
      --replace-fail "/usr/share/dbeaver-ue/dbeaver" "$out/bin/dbeaver"

    sed -i '/^Path=/d' $out/share/applications/dbeaver.desktop

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://dbeaver.io/";
    changelog = "https://github.com/dbeaver/dbeaver/releases/tag/${finalAttrs.version}";
    description = "Universal SQL Client for developers, DBA and analysts. Supports MySQL, PostgreSQL, MariaDB, SQLite, and more";
    longDescription = ''
      Free multi-platform database tool for developers, SQL programmers, database
      administrators and analysts. Supports all popular databases: MySQL,
      PostgreSQL, MariaDB, SQLite, Oracle, DB2, SQL Server, Sybase, MS Access,
      Teradata, Firebird, Derby, etc.
    '';
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.asl20;
    platforms = with lib.platforms; linux;
    maintainers = with lib.maintainers; [
      gepbird
      mkg20001
      yzx9
    ];
    mainProgram = "dbeaver";
  };
})
