output "webserver-public_ip" {
  value = module.webserver.ws-instance.public_ip
}