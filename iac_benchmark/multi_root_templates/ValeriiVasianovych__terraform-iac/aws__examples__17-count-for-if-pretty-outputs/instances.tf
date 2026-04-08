resource "aws_instance" "ubuntu_instance" {
    count         = 2
    ami           = data.aws_ami.latest_ubuntu.id
    instance_type = "t2.micro"
    tags = {
        Name = "Server Number: ${count.index + 1}"
    }
}