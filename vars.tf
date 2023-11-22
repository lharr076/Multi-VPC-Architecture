
variable "region" {
    default="us-east-1"
}

variable "aws-key" {
    description = "SSH Public Key Name Created in AWS (keys are unique per region)."
    type = string
    default = "US-EAST-1-KEY"

}
