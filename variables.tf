# variables.tf
variable "instance_type" {
  default     = "t3.nano"
  description = "type d'instance pour le serveur web"
}
variable "region" {
  default     = "eu-central-1"
  description = "region choisie"
}
variable "ami" {
  default     = "ami-074dd8e8dac7651a5"
  description = "ami pour la region choisie"
}

variable "environment" {
  default     = "min"
  description = "environnement choisi"
}
