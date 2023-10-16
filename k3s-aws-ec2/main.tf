resource "aws_instance" "k3s-master-1" {

    ami = lookup(var.ami,var.aws_region)
    instance_type = var.type
    tags = {
        Name = "K3s Master 1"
    }
    key_name = var.key_name
    security_groups = var.security_groups
    root_block_device {
      volume_size = var.root_block_device
    }

    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file("./credentials/terraform.pem")
      host = aws_instance.k3s-master-1.public_ip
    }

    provisioner "remote-exec" {
    inline =[
      "sudo curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=\"v1.25.5+k3s1\" sh -s - server --token=dfXagzaueZM8Ye --cluster-init",

    ]
  }
  
}

resource "aws_instance" "k3s-master-2" {

    depends_on = [
      aws_instance.k3s-master-1
    ]
    ami = lookup(var.ami,var.aws_region)
    instance_type = var.type
    tags = {
        Name = "K3s Master 2"
    }
    key_name = var.key_name
    security_groups = var.security_groups
    root_block_device {
      volume_size = var.root_block_device
    }

    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file("./credentials/terraform.pem")
      host = aws_instance.k3s-master-2.public_ip
    }

    provisioner "remote-exec" {
      inline = [
        "sudo curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=\"v1.25.5+k3s1\" sh -s - server --server https://${aws_instance.k3s-master-1.private_ip}:6443  --token=dfXagzaueZM8Ye"

      ]
    }
  
}

resource "aws_instance" "k3s-master-3" {
    depends_on = [
    aws_instance.k3s-master-1,
    aws_instance.k3s-master-2
    ]

    ami = lookup(var.ami,var.aws_region)
    instance_type = var.type
    tags = {
        Name = "K3s Master 3"
    }
    key_name = var.key_name
    security_groups = var.security_groups
    root_block_device {
      volume_size = var.root_block_device
    }

    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file("./credentials/terraform.pem")
      host = aws_instance.k3s-master-3.public_ip
    }

    provisioner "remote-exec" {
      inline = [
        "sudo curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=\"v1.25.5+k3s1\" sh -s - server --server https://${aws_instance.k3s-master-1.private_ip}:6443  --token=dfXagzaueZM8Ye",
      ]
    }
}

resource "null_resource" "configuration" {
  depends_on = [
    aws_instance.k3s-master-1,
    aws_instance.k3s-master-2,
    aws_instance.k3s-master-3
  ]

    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file("./credentials/terraform.pem")
      host = aws_instance.k3s-master-1.public_ip
    }

    provisioner "remote-exec" {
    inline = [
        "sudo chmod 777 /etc/rancher/k3s/k3s.yaml",
        "sudo cp /etc/rancher/k3s/k3s.yaml /usr/local/bin/",
        "export KUBECONFIG=/usr/local/bin/k3s.yaml",
        "sudo kubectl get nodes"
    ]
    }
}
