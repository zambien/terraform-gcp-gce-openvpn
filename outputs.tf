output "openvpn_host" {
  value = ""
}

/* We probably don't need to output these all the time but they are here for debugging
output "ca_crt" {
  value = "${module.pki.ca_crt}"
}

output "certificate_crt" {
  value = "${module.pki.certificate_crt}"
}

output "dh_pem" {
  value = "${module.pki.dh_pem}"
}

output "private_key" {
  value = "${module.pki.private_key}"
}

output "ta_key" {
  value = "${module.pki.ta_key}"
}
*/