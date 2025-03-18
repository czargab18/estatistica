import re
def multiple_replace(text, replacement):
    regex = re.compile("(%s)" % "|".join(map(re.escape, replacement.keys())))
    return regex.sub(lambda mo: replacement[mo.string[mo.start():mo.end()]], text)
