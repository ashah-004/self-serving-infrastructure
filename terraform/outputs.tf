output "vm_public_ip" {
    value = aws_instance.web.public_ip
}