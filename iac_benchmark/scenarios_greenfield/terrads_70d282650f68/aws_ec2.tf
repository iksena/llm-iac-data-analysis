# variable "subnet_ids" {
#     default = {
#       "0" = "${aws_subnet.main-publicsubnet-1.id}"
#       "1" = "${aws_subnet.main-publicsubnet-2.id}"
#     }
# }
 
resource "aws_instance" "web" {
    count = 2
    ami = "${var.images.ap-northeast-1}"
    instance_type = "t2.micro"
    key_name = "${aws_key_pair.sshkey.id}"
    vpc_security_group_ids = [
        "${aws_security_group.default.id}",
        "${aws_security_group.ssh.id}",
        "${aws_security_group.http.id}"
    ]
    #subnet_id = "${lookup(var.subnet_ids, count.index%2)}"
    subnet_id = "${aws_subnet.main-publicsubnet-1.id}"
    tags = {
        Name = "${var.app_name}-${format("web%02d", count.index + 1)}"
    }
}