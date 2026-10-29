#!/bin/bash
set -euo pipefail

exec > >(tee -a /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1
trap 'status=$?; echo "Provisioning failed at line $LINENO (exit $status)." >&2; exit "$status"' ERR

if [[ "$(id -u)" -ne 0 ]]; then
	echo "Run this script as root." >&2
	exit 1
fi

if ! command -v dnf >/dev/null 2>&1; then
	echo "This user-data script requires Amazon Linux 2023 (dnf)." >&2
	exit 1
fi

architecture="$(uname -m)"
case "$architecture" in
	x86_64) kubectl_arch="amd64" ;;
	aarch64) kubectl_arch="arm64" ;;
	*) echo "Unsupported architecture: $architecture" >&2; exit 1 ;;
esac

dnf install -y docker
systemctl enable --now docker
usermod -aG docker ec2-user

kubectl_version="$(curl -fsSL https://dl.k8s.io/release/stable.txt)"
download_dir="$(mktemp -d)"
trap 'rm -rf "$download_dir"' EXIT

kubectl_url="https://dl.k8s.io/release/${kubectl_version}/bin/linux/${kubectl_arch}/kubectl"
curl -fsSLo "${download_dir}/kubectl" "$kubectl_url"
curl -fsSLo "${download_dir}/kubectl.sha256" "${kubectl_url}.sha256"
printf '%s  %s\n' \
	"$(cat "${download_dir}/kubectl.sha256")" \
	"${download_dir}/kubectl" \
	| sha256sum --check --status
install -m 0755 "${download_dir}/kubectl" /usr/local/bin/kubectl

docker --version
systemctl is-active --quiet docker
kubectl version --client=true
