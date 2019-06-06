resource"null_resource" "load_cpu" {
  count = "${var.exec_cpu_load ? 1 : 0}"
  triggers {
    build_number = "${timestamp()}"
  }
  
  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "30m"
      host        = "${module.auto_scaling.instance_pool_instance_ip}"
      user        = "opc"
      private_key = "${var.ssh_private_key}"
    }

    inline = [
      "openssl speed -multi `grep processor /proc/cpuinfo|wc -l`" 
    ]
  }
}
