@fieldwise_init
struct ValidationError(Copyable, Writable):
    var field: String
    var reason: String

    def write_to(self, mut writer: Some[Writer]):
        writer.write("ValidationError(", self.field, "): ", self.reason)

def validate_username(username: String) raises ValidationError -> String:
    if username.byte_length() == 0:
        raise ValidationError(field="username", reason="cannot be empty")
    return username
