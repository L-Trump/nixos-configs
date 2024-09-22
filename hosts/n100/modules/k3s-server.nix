{
  pkgs,
  myvars,
  ...
}: let
  lib = pkgs.lib;
  package = pkgs.k3s;
  kubeconfigFile = "/home/${myvars.username}/.kube/config";
  kubeletExtraArgs = [
    "--cpu-manager-policy=static"
    # https://kubernetes.io/docs/tasks/administer-cluster/reserve-compute-resources/
    # we have to reserve some resources for for system daemons running as pods or system services
    # when cpu-manager's static policy is enabled
    # the memory we reserved here is also for the kernel, since kernel's memory is not accounted in pods
    "--system-reserved=cpu=1,memory=2Gi,ephemeral-storage=2Gi"
  ];
  nodeLabels = [
    "node-purpose=kubevirt"
  ];
  # kubevirt works well with k3s's flannel,
  # but has issues with cilium(failed to configure vmi network: setup failed, err: pod link (pod6b4853bd4f2) is missing).
  # so we should not disable flannel here.
  disableFlannel = false;
  nodeTaints = [];
in {
  environment.systemPackages = with pkgs; [
    package
    k9s
    # kubectl
    istioctl
    kubernetes-helm
    cilium-cli
    fluxcd
    clusterctl # for kubernetes cluster-api

    skopeo # copy/sync images between registries and local storage
    go-containerregistry # provides `crane` & `gcrane`, it's similar to skopeo
    dive # explore docker layers
  ];

  services.k3s = {
    enable = true;
    inherit package;

    role = "server";
    # https://docs.k3s.io/cli/server
    extraFlags = let
      flagList =
        [
          "--write-kubeconfig=${kubeconfigFile}"
          "--write-kubeconfig-mode=644"
          "--service-node-port-range=80-32767"
          "--kube-apiserver-arg='--allow-privileged=true'" # required by kubevirt
          "--data-dir /var/lib/rancher/k3s"
          "--etcd-expose-metrics=true"
          "--etcd-snapshot-schedule-cron='0 */12 * * *'"
          # disable some features we don't need
          "--disable-helm-controller" # we use fluxcd instead
        ]
        ++ (map (label: "--node-label=${label}") nodeLabels)
        ++ (map (taint: "--node-taint=${taint}") nodeTaints)
        ++ (map (arg: "--kubelet-arg=${arg}") kubeletExtraArgs)
        ++ (lib.optionals disableFlannel ["--flannel-backend=none"]);
    in
      lib.concatStringsSep " " flagList;
  };

  # create symlinks to link k3s's cni directory to the one used by almost all CNI plugins
  # such as multus, calico, etc.
  # https://www.freedesktop.org/software/systemd/man/latest/tmpfiles.d.html#Type
  systemd.tmpfiles.rules = [
    "L+ /opt/cni/bin - - - - /var/lib/rancher/k3s/data/current/bin"
    # If you have disabled flannel, you will have to create the directory via a tmpfiles rule
    "D /var/lib/rancher/k3s/agent/etc/cni/net.d 0751 root root - -"
    # Link the CNI config directory
    "L+ /etc/cni/net.d - - - - /var/lib/rancher/k3s/agent/etc/cni/net.d"
  ];
}
