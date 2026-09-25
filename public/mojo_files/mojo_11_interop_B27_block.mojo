# Missing library → try/except fallback:
try:
    var lib = OwnedDLHandle(LIBCURL)
    # use the optional feature
except:
    # fall back
    pass
