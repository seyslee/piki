resource "aws_ssm_parameter" "mynewparameter" {
  name  = "/myapp/myparameter"
  type  = "String"
  value = "myvalue"
}
