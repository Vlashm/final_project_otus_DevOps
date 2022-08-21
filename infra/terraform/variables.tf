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
variable "service_account_id" {
  description = "Service account ID"
}
variable "node_service_account_id" {
  description = "Node service account ID"
}
variable "ssh_username" {
  description = "SSH user name"
}
variable "public_key_path" {
  description = "Path to the public key used for ssh access"
}
variable "v4_cidr" {
  description = "v4_cidr_blocks"
}
variable "image_id_mongo" {
  description = "Id image mongodb"
}
variable "image_id_gitlab" {
  description = "Id image mongodb"
}
variable "version_k8s" {
  description = "Version kubernetes"
}
variable "zone_compute_instance" {
  description = "Zone compute instance"
  default     = "ru-central1-a"
}
variable "app_zone" {
  description = "App zone"
}
