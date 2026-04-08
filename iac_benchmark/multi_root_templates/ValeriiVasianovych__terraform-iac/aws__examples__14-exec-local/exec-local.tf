resource "null_resource" "com1" {
  provisioner "local-exec" {
    command = "touch file.txt;"
  }
}

resource "null_resource" "com2" {
  provisioner "local-exec" {
    command = "mkdir output-files; cd output-files; counter_two=5; while [ $counter_two -gt 0 ]; do counter_two=$((counter_two-1)); touch output-$counter_two.txt; done"
  }
  depends_on = [ null_resource.com1 ]
}

resource "null_resource" "com3" {
  provisioner "local-exec" {
    command = "python3 -c 'print(\"hello world\")'"
  }
  depends_on = [ null_resource.com1, null_resource.com2]
}

resource "null_resource" "com4" {
  provisioner "local-exec" {
    command     = "print(\"hello my lovely friend\")"
    interpreter = ["/bin/python3", "-c"]
  }
  depends_on = [ null_resource.com1, null_resource.com2, null_resource.com3]
}

resource "aws_instance" "ubuntu" {
    ami           = "0866a3c8686eaeeba"
    instance_type = "t2-micro"
    provisioner "local-exec" { # Inside EC2 instance. If I create an instance, I can run this command inside the instance. 
      command = "ping -c 5 www.google.com"
    }

    provisioner "local-exec" {
      command = "hello "
    }
}

resource "null_resource" "com5" {
  provisioner "local-exec" {
    command     = "echo Name: $NAME Surname: $SURNAME > person-info.txt"
    interpreter = ["/bin/bash", "-c"]
    environment = {
      NAME    = "Valerii"
      SURNAME = "Vasianovych"
    }
  }
  depends_on = [ null_resource.com1, null_resource.com2, null_resource.com3, null_resource.com4 ]
}