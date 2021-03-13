import sys
import re
import numpy as np

def strToList(str,y):
    M = list(map(int, (re.compile(r'\d+')).findall(str)))# 查找数字
    res =[]
    for i in range(int(len(M)/y)):
        res.append( np.asarray(M[i*y:(i+1)*y]))
    return res

if __name__ == '__main__':
    res = []
    for i in range(1, len(sys.argv)):
        res.append(strToList(sys.argv[i],3))
    face_encodings = res[0]
    face_to_compare = res[1][0]
    print(face_encodings,face_to_compare)