resource "aws_instance" "dynamic_template_server" {
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = "t2.micro"
  key_name               = "ServersKey"
  vpc_security_group_ids = [aws_security_group.sg_rule.id]
  user_data = templatefile("template.sh.tpl", {
    f_name  = "Valerii"
    l_name  = "Vasianovych"
    email   = "valerii.vasianovych.2003@gmail.com"
    age     = "20"
    team = ["Marcin", "Anna", "Krzysztof"]
  })

  tags = merge(var.common_tags, {
    Name = "Dynamic Template Ubuntu Instance"
    Year = 2024})
  }