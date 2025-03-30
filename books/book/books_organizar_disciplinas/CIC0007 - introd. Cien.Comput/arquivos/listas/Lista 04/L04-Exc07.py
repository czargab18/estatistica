def concat(s1,s2):
    if not s1:
        return s2
    else:
        return s1[0:1]+concat(s1[1:],s2)
def rev(s):
    if not s:
        return s
    else:
        return concat(rev(s[1:]),s[0:1])
def prefix(s1,s2):
    if s1 == ''and s2 == '':
        return False
    elif s1 == s2:
        return True
    elif s1 == '' and s2!='':
        return True
    elif s1 == concat(s1[0:1],s1[1:]):
        return prefix(s1[1:],s2[1:])
    else:
        return False
s1=str(input())
s2=str(input())
print(concat(s1,s2))
print(rev(s1))
print(prefix(s1,s2))