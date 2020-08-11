variable "test_count" {
  type    = number
  default = 4
}

locals {
  test_names = range(test_count)
}

output "test_names" {
  value = local.test_names
}