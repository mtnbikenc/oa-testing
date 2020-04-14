locals {
  network      = cidrhost(var.machine_cidr, 0)
  ip_addresses = data.template_file.ip_address.*.rendered
}

data "external" "ip_address" {
  count = var.instance_count

  program = ["bash", "${path.module}/cidr_to_ip.sh"]

  query = {
    hostname   = "${var.name}-${count.index}.${var.cluster_domain}"
    ipam       = var.ipam
    ipam_token = var.ipam_token
  }

  depends_on = [null_resource.ip_address]
}

data "template_file" "ip_address" {
  count = var.instance_count

  template = data.external.ip_address[count.index].result["ip_address"]
}

resource "null_resource" "ip_address" {
  count = var.instance_count

  triggers = {
    ipam           = var.ipam
    name           = var.name
    cluster_domain = var.cluster_domain
    ipam_token     = var.ipam_token
    network        = local.network
  }

  provisioner "local-exec" {
    command = <<EOF
echo '{"network":"${self.triggers.network}","hostname":"${self.triggers.name}-${count.index}.${self.triggers.cluster_domain}","ipam":"${self.triggers.ipam}","ipam_token":"${self.triggers.ipam_token}"}' | ${path.module}/cidr_to_ip.sh
EOF

  }

  provisioner "local-exec" {
    when = destroy

    command = <<EOF
curl -s "http://${self.triggers.ipam}/api/removeHost.php?apiapp=address&apitoken=${self.triggers.ipam_token}&host=${self.triggers.name}-${count.index}.${self.triggers.cluster_domain}"
EOF

  }
}

