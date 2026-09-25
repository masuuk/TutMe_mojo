def show(label: StaticString, s: StringSpan):
    print(label, "bytes=", s.byte_length(),
          "codepoints=", s.count_codepoints(),
          "graphemes=", s.count_graphemes())

def main():
    show("wave ", "👋🏽")
