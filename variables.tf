variable "resource_group_name" {
  default = "week5"
}

variable "virtual_network_name" {
  default = "week5Vent"

}
variable "location" {
  default = "australiaeast"
}
variable "application_port" {
  default = 8080
}

variable "secret" {
  default = "smoecoolpassword"
}

variable "admin_user" {
  default = "secretadmin"
}
variable "db_admin_user" {
  default = "secretadmin"
}
