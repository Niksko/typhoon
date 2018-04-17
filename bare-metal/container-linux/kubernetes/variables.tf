variable "cluster_name" {
  type        = "string"
  description = "Unique cluster name"
}

# bare-metal

variable "matchbox_http_endpoint" {
  type        = "string"
  description = "Matchbox HTTP read-only endpoint (e.g. http://matchbox.example.com:8080)"
}

variable "container_linux_channel" {
  type        = "string"
  description = "Container Linux channel corresponding to the container_linux_version"
}

variable "container_linux_version" {
  type        = "string"
  description = "Container Linux version of the kernel/initrd to PXE or the image to install"
}

# machines
# Terraform's crude "type system" does not properly support lists of maps so we do this.

variable "controller_names" {
  type = "list"
}

variable "controller_macs" {
  type = "list"
}

variable "controller_domains" {
  type = "list"
}

variable "worker_names" {
  type = "list"
}

variable "worker_macs" {
  type = "list"
}

variable "worker_domains" {
  type = "list"
}

# configuration

variable "k8s_domain_name" {
  description = "Controller DNS name which resolves to a controller instance. Workers and kubeconfig's will communicate with this endpoint (e.g. cluster.example.com)"
  type        = "string"
}

variable "ssh_authorized_key" {
  type        = "string"
  description = "SSH public key for user 'core'"
}

variable "asset_dir" {
  description = "Path to a directory where generated assets should be placed (contains secrets)"
  type        = "string"
}

variable "networking" {
  description = "Choice of networking provider (flannel or calico)"
  type        = "string"
  default     = "calico"
}

variable "network_mtu" {
  description = "CNI interface MTU (applies to calico only)"
  type        = "string"
  default     = "1480"
}

variable "pod_cidr" {
  description = "CIDR IPv4 range to assign Kubernetes pods"
  type        = "string"
  default     = "10.2.0.0/16"
}

variable "controller_install_disks" {
  type        = "list"
  description = "Disk device to which the install profiles should install Container Linux on controller machines (e.g. /dev/sda). Prefer persistent block device labels such as /dev/disk/by-id/ type labels"
}

variable "worker_install_disks" {
  type        = "list"
  description = "Disk device to which the install profiles should install Container Linux on worker machines (e.g. /dev/sda). Prefer persistent block device labels such as /dev/disk/by-id/ type labels"
}

variable "controller_network_devices" {
  type        = "list"
  description = "Network device that should be configured for controller machines"
}

variable "worker_network_devices" {
  type        = "list"
  description = "Network device that should be configured for worker machines"
}

variable "controller_static_ips" {
  type        = "list"
  description = "Static IP assignment for controller machines"
}

variable "worker_static_ips" {
  type        = "list"
  description = "Static IP assignment for worker machines"
}

variable "gateway_ip" {
  type        = "string"
  description = "Address of gateway server for all machines"
}

variable "subnet_mask" {
  type        = "string"
  description = "Subnet mask for all machines in number of bits (eg. for 10.0.0.1 and subnet mask of 255.255.255.0, CIDR would be 10.0.0.1/24, so use 24)"
}

variable "dns_servers" {
  type        = "list"
  description = "List of DNS servers for all machines (eg. [8.8.8.8, 8.8.4.4])"
}

variable "service_cidr" {
  description = <<EOD
CIDR IPv4 range to assign Kubernetes services.
The 1st IP will be reserved for kube_apiserver, the 10th IP will be reserved for kube-dns.
EOD

  type    = "string"
  default = "10.3.0.0/16"
}

# optional

variable "cluster_domain_suffix" {
  description = "Queries for domains with the suffix will be answered by kube-dns. Default is cluster.local (e.g. foo.default.svc.cluster.local) "
  type        = "string"
  default     = "cluster.local"
}

variable "cached_install" {
  type        = "string"
  default     = "false"
  description = "Whether Container Linux should PXE boot and install from matchbox /assets cache. Note that the admin must have downloaded the container_linux_version into matchbox assets."
}

variable "container_linux_oem" {
  type        = "string"
  default     = ""
  description = "Specify an OEM image id to use as base for the installation (e.g. ami, vmware_raw, xen) or leave blank for the default image"
}

variable "kernel_args" {
  description = "Additional kernel arguments to provide at PXE boot."
  type        = "list"
  default     = []
}

# unofficial, undocumented, unsupported, temporary

variable "controller_networkds" {
  type        = "list"
  description = "Controller Container Linux config networkd section"
  default     = []
}

variable "worker_networkds" {
  type        = "list"
  description = "Worker Container Linux config networkd section"
  default     = []
}
