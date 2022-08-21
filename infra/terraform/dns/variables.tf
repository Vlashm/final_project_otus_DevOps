variable "cloud_id" {
  description = "Cloud"
}
variable "folder_id" {
  description = "Folder"
}
variable "zone" {
  description = "Zone"
  default     = "ru-central1-a"
}
variable "service_account_key_file" {
  description = "key .json"
}
variable "app_zone" {
  description = "App zone"
}
variable "app_records_name"{
    description = "App records name"
    type = list(string)
}
variable "loadbalancer_external_ip" {
    description = "External IP LoadBalancer"
}