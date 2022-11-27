login="xlizic00"
if(login[0] != "x"):print("ERROR!!! Login must start with x")
s=""
for i, x in enumerate(login):
    if x in "0123456789":break
    if x in "ABCDEFGHIJKLMNOPQRSTUVWXYZ":print("ERROR!!! Login should be lowercase")
    if i&1 == 0:
        offset = ord(login[1])-ord("a")+1
    else:
        offset = -(ord(login[2])-ord("a")+1)
    s+=chr((ord(x)-ord("a")+offset)%26+ord("a"))
print(s)