variable tenancy_ocid {}
variable region {}
variable user_ocid {
    default = null
}
variable user_name {
    type = string
}
variable user_description {
    type = string
}
variable group_ocid {
    default = null
}
variable group_name {
    type = string
}
variable group_description {
    type = string
}
variable policies {
    type = list(any)
}
variable generate_api_key {
    type = bool
}
variable generate_auth_token {
    type = bool
}
