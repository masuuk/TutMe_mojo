def validate_with_error(value: Int) raises -> Int:
    if value < 0:
        raise "value cannot be negative"
    return value

def wrapped_validate(value: Int) raises ValidationError -> Int:
    try:
        return validate_with_error(value)
    except e:
        raise ValidationError(field="value", reason=String(e))
