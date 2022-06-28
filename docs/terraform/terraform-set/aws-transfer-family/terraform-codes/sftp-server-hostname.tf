resource "null_resource" "service_managed_sftp_custom_hostname" {
  depends_on = [aws_transfer_server.service_managed_sftp]

  provisioner "local-exec" {
    command = <<EOF
aws transfer tag-resource \
  --arn '${aws_transfer_server.service_managed_sftp.arn}' \
  --tags 'Key=aws:transfer:customHostname,Value=sftp.rocket.dev' \
  --region 'ap-northeast-2'
EOF
  }
}