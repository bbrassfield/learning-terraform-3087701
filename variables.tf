variable "instance_type" {
  description = "Type of EC2 instance to provision"
  default     = "t2.2xlarge"
}

variable "idmc_sa_installer_user" {
  description = "Username passed into the idmc_secure_agent_installer.py script"
  type        = string
  sensitive   = true
  default     = "joe_user"
}

variable "idmc_sa_installer_pass" {
  description = "Password passed into the idmc_secure_agent_installer.py script"
  type        = string
  sensitive   = true
  default     = "joe_pass"
}

variable "idmc_sa_installer_group" {
  description = "Group passed into the idmc_secure_agent_installer.py script"
  type        = string
  sensitive   = true
  default     = "joe_group"
}
