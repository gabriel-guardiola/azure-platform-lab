variable "subscription_id" {
  type = string
}
variable "prefix" {
  type    = string
  default = "gglab"
}
variable "location" {
  type    = string
  default = "eastus"
}
variable "tags" {
  type    = map(string)
  default = { owner = "gabriel", env = "lab" }
}