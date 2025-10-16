{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  installShellFiles,
  procps,
}:

python3Packages.buildPythonPackage rec {
  pname = "canokey-manager";
  version = "2025-10-16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "canokeys";
    repo = "yubikey-manager";
    rev = "b8459b788d8de40867173a50b7bdc7640e5b8afe";
    hash = "sha256-mYMe7fTIEXE9nc3NM8aCyUXtYBUrF5W8+1TEksQ+rEg=";
  };

  postPatch = ''
    substituteInPlace "ykman/pcsc/__init__.py" \
      --replace-fail 'pkill' '${if stdenv.hostPlatform.isLinux then procps else "/usr"}/bin/pkill'
  '';

  nativeBuildInputs = with python3Packages; [
    installShellFiles
    pythonRelaxDepsHook
  ];

  build-system = with python3Packages; [
    poetry-core
  ];

  pythonRelaxDeps = [
    "keyring"
    "cryptography"
    "fido2"
  ];

  dependencies = with python3Packages; [
    cryptography
    pyscard
    fido2
    click
    keyring
  ];

  postInstall = ''
    installManPage man/ykman.1

    # installShellCompletion --cmd ckman \
    #   --bash <(_YKMAN_COMPLETE=bash_source "$out/bin/ckman") \
    #   --zsh  <(_YKMAN_COMPLETE=zsh_source  "$out/bin/ckman") \
    #   --fish <(_YKMAN_COMPLETE=fish_source "$out/bin/ckman") \
  '';

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    makefun
  ];

  meta = {
    homepage = "https://developers.yubico.com/yubikey-manager";
    changelog = "https://github.com/Yubico/yubikey-manager/releases/tag/${src.tag}";
    description = "Command line tool for configuring any YubiKey over all USB transports";

    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      benley
      lassulus
      pinpox
      nickcao
    ];
    mainProgram = "ckman";
  };
}
