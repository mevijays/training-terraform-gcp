variable name {
  type        = string
  default     = "name"
  description = "Please provide a name in 5 character"
    validation {
    condition     = length(var.name) <= 5
    error_message = "Error.. name can be 5 charecter long only.."

}
}