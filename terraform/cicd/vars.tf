variable "github_owner" {
  description = "Name of the GitHub Repository Owner."
  type        = string
  default     = "anthonydenecheau"
}

variable "github_repository" {
  description = "Name of the GitHub Repository."
  type        = string
  default     = "cloud-run-hello"
}

variable "branch_name" {
  description = "Example branch name used to trigger builds."
  type        = string
  default     = "master"
}