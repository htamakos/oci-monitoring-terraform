data "template_file" "grafana_datasources" {
  template = "${file("templates/oci_datasource.yaml")}"

  vars = {
    region       = "${var.region}"
    tenancy_ocid = "${var.tenancy_ocid}"
  }
}

data "template_file" "oci_config" {
  template = "${file("templates/oci_cli_config.tmp")}"

  vars = {
    region         = "${var.region}"
    tenancy_ocid   = "${var.tenancy_ocid}"
    user           = "${var.user_ocid}"
    fingerprint    = "${var.fingerprint}"
    region         = "${var.region}"
    compartment_id = "${oci_identity_compartment.compartment.id}"
  }
}

data "template_file" "post_oci_stream" {
  template = "${file("templates/post_oci_stream.rb.tmp")}"

  vars = {
    stream_id = "${module.streaming.streaming_id}"
  }
}

resource "null_resource" "oci_private_key" {
  count = "${var.provision ? 1 : 0}"

  triggers {
    build_number = "${timestamp()}"
  }

  provisioner "file" {
    connection {
      agent       = false
      timeout     = "30m"
      host        = "${module.compute_web.instance_gip}"
      user        = "opc"
      private_key = "${var.ssh_private_key}"
    }

    content     = "${file("${var.private_key_path}")}"
    destination = "/tmp/oci_api_key.pem"
  }
}

resource "null_resource" "oci_config" {
  count = "${var.provision ? 1 : 0}"

  triggers {
    build_number = "${timestamp()}"
  }

  provisioner "file" {
    connection {
      agent       = false
      timeout     = "30m"
      host        = "${module.compute_web.instance_gip}"
      user        = "opc"
      private_key = "${var.ssh_private_key}"
    }

    content     = "${data.template_file.oci_config.rendered}"
    destination = "/tmp/oci_config"
  }
}

resource "null_resource" "post_oci_stream" {
  count = "${var.provision ? 1 : 0}"

  triggers {
    build_number = "${timestamp()}"
  }

  provisioner "file" {
    connection {
      agent       = false
      timeout     = "30m"
      host        = "${module.compute_web.instance_gip}"
      user        = "opc"
      private_key = "${var.ssh_private_key}"
    }

    content     = "${data.template_file.post_oci_stream.rendered}"
    destination = "/tmp/post_oci_stream.rb"
  }
}

resource "null_resource" "grafana_datasources" {
  count = "${var.provision ? 1 : 0}"

  triggers {
    build_number = "${timestamp()}"
  }

  provisioner "file" {
    connection {
      agent       = false
      timeout     = "30m"
      host        = "${module.compute_grafana.instance_gip}"
      user        = "opc"
      private_key = "${var.ssh_private_key}"
    }

    content     = "${data.template_file.grafana_datasources.rendered}"
    destination = "/tmp/oci_datasource.yaml"
  }
}

resource "null_resource" "provision_grafana" {
  count = "${var.provision ? 1 : 0}"

  triggers {
    build_number = "${timestamp()}"
  }

  depends_on = [
    "null_resource.grafana_datasources",
  ]

  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "30m"
      host        = "${module.compute_grafana.instance_gip}"
      user        = "opc"
      private_key = "${var.ssh_private_key}"
    }

    script = "scripts/provision_grafana.sh"
  }
}

resource "null_resource" "provision_web" {
  count = "${var.provision ? 1 : 0}"

  triggers {
    build_number = "${timestamp()}"
  }

  depends_on = [
    "null_resource.oci_private_key",
    "null_resource.oci_config",
  ]

  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "30m"
      host        = "${module.compute_web.instance_gip}"
      user        = "opc"
      private_key = "${var.ssh_private_key}"
    }

    script = "scripts/provision_web.sh"
  }
}

resource "null_resource" "exec_web_request" {
  count = "${var.exec_web_request ? 1 : 0}"

  triggers {
    build_number = "${timestamp()}"
  }

  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "30m"
      host        = "${module.compute_web.instance_gip}"
      user        = "opc"
      private_key = "${var.ssh_private_key}"
    }

    inline = [
      "sudo yum install -y httpd",
      "ab -n ${var.exec_web_request_count} http://localhost/",
    ]
  }
}
