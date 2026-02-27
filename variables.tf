# variables.tf
variable "ami" {
  description = "ami pour la region choisie"
  default     = "ami-074dd8e8dac7651a5"
}

variable "environment" {
  description = "environnement choisi"
  default     = "min"
}

variable "instance_type" {
  description = "type d'instance pour le serveur web"
  default     = "t3.nano"
}

variable "region" {
  description = "region choisie"
  default     = "eu-central-1"
}
