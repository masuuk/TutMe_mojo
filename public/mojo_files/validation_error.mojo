# Extracted from tutorials on this site (source: praxis/drill_12.html)
# https://github.com/masuuk/TutMe/blob/main/tui/public/praxis/drill_12.html

@fieldwise_init
struct ValidationError(Copyable, Writable):
    var field: String
    var reason: String

def validate_username(username: String) raises -> String:
    if username.byte_length() == 0:
        raise ValidationError("username", "cannot be empty")
    return username

# A minimal context manager: CM tracks enter/exit (ch10)
@fieldwise_init
struct CM(ImplicitlyCopyable):
    var tag: String

    def __enter__(mut self) -> Self:
        print("--enter--")
        return self

    def __exit__(mut self):
        print("--exit--")

def main():
    try:
        validate_username("")
    except err:
        print(err.field)   # username
        print(err.reason)  # cannot be empty

    with CM(tag="cm"):
        print("body")      # --body--
    # after the with block: exit already ran
