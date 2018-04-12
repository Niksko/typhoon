// Install Container Linux to disk
resource "matchbox_group" "container-linux-install" {
  count = "${length(var.controller_names) + length(var.worker_names)}"

  name    = "${format("container-linux-install-%s", element(concat(var.controller_names, var.worker_names), count.index))}"
  profile = "${var.cached_install == "true" ? element(matchbox_profile.cached-container-linux-install.*.name, count.index) : element(matchbox_profile.container-linux-install.*.name, count.index)}"

  selector {
    mac = "${element(concat(var.controller_macs, var.worker_macs), count.index)}"
  }
}

// Set up a new matchbox group(s) here. Basic details:
// * use a custom template that just does the lvm provisioning. This will allow for different devices to have different lvm layouts
// * similar to how worker and controller groups already work, count over a map and line these up with custom profiles for each machine
// * performed after os install, but before worker or controller configuration
// * will need to add "storage=provisioned" (or similar) to the existing worker/controller group selectors
// * new groups will have the "os=installed" selector
// * scripts that currently curl the ignition endpoint with "&os=installed" will use "&os=install&storage=provisioned"
// * new scripts that do the lvm install should pass the "&os=installed" param

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
