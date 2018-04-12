// Install Container Linux to disk
resource "matchbox_group" "container-linux-install" {
  count = "${length(var.controller_names) + length(var.worker_names)}"

  name    = "${format("container-linux-install-%s", element(concat(var.controller_names, var.worker_names), count.index))}"
  profile = "${var.cached_install == "true" ? element(matchbox_profile.cached-container-linux-install.*.name, count.index) : element(matchbox_profile.container-linux-install.*.name, count.index)}"

  selector {
    mac = "${element(concat(var.controller_macs, var.worker_macs), count.index)}"
  }
}

// Just need to update container linux configs to create additional partitions
// Follow templates at https://coreos.com/ignition/docs/latest/examples.html#create-a-raid-enabled-data-volume
// Either just format the root as btrfs and expand it across all hds
// Or create a separate data partition on the second hard drive

resource "matchbox_group" "controller" {
  count   = "${length(var.controller_names)}"
  name    = "${format("%s-%s", var.cluster_name, element(var.controller_names, count.index))}"
  profile = "${element(matchbox_profile.controllers.*.name, count.index)}"

  selector {
    mac = "${element(var.controller_macs, count.index)}"
    os  = "installed"
  }
}

resource "matchbox_group" "worker" {
  count   = "${length(var.worker_names)}"
  name    = "${format("%s-%s", var.cluster_name, element(var.worker_names, count.index))}"
  profile = "${element(matchbox_profile.workers.*.name, count.index)}"

  selector {
    mac = "${element(var.worker_macs, count.index)}"
    os  = "installed"
  }
}
