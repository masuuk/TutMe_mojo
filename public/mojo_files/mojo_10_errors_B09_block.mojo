try:
    print(open_file("/secret"))
except e:
    if e == FileError.not_found:
        print("Not found:", e)
    elif e == FileError.permission_denied:
        print("Permission denied:", e)
