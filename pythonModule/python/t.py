import face_recognition
import numpy as  np
import cv2
import sys
import re
def init(imgpath):
    rectangle = [];
    keypoint = [];
    scale = 1
    img = cv2.imread(imgpath) # 0.22s
    if(img.shape[0]<2000):
        img = cv2.resize(img,(3000,int(img.shape[0]/(img.shape[1])*3000)))
        scale = 3000.0/img.shape[1]
    img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

    face_locations = face_recognition.face_locations(img_rgb,1)
    face_landmarks = face_recognition.face_landmarks(img,face_locations) #72个点
    face_encodings = face_recognition.face_encodings(img,face_locations)

    for (top, right, bottom, left),face_landmark  in zip(face_locations,face_landmarks):
        rectangle.append([left,top,right-left,bottom-top])
        pointTemp = []
        for value in face_landmark.values():
            for point in value:
                pointTemp.append([point[0], point[1]])
        keypoint.append(pointTemp)

    faceNum = len(face_locations)
    faceDic = {}
    faceDic['faceNum'] = faceNum
    faceDic['face_locations'] = (np.array(rectangle)/scale).astype(int).tolist()
    faceDic['face_landmarks'] = (np.array(keypoint)/scale).astype(int).tolist()
    faceDic['face_encodings'] = np.asarray(face_encodings).tolist()


    #  检测照片中是否 存在相同的脸
    faceDic['face_ids'] = getFaceIndex(face_encodings)
    # pic_id,face_num,locations,face_ids,landmarks
    print(faceDic['faceNum'])
    print([a for a in  faceDic['face_locations']])
    print(faceDic['face_ids'])
    print([a for a in  faceDic['face_landmarks']])
    print([a for a in  faceDic['face_encodings']])


    # return faceDic
def getFaceInfo(imgpath,known_face_encodings,known_face_ids):
    rectangle = [];
    keypoint = [];
    scale = 1
    img = cv2.imread(imgpath) # 0.22s
    # if(img.shape[0]<2000):
    #     img = cv2.resize(img,(3000,int(img.shape[0]/(img.shape[1])*3000)))
    #     scale = 3000.0/img.shape[1]
    img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

    face_locations = face_recognition.face_locations(img_rgb,1)
    face_landmarks = face_recognition.face_landmarks(img,face_locations) #72个点
    face_encodings = face_recognition.face_encodings(img,face_locations)
    # 与数据库比对  得到人脸 id  新人脸就在原有人脸最大id上+1，得到新id
    faceDic = {}
    faceDic['face_ids'] = getFaceIndex(known_face_encodings,known_face_ids,face_encodings)

    for (top, right, bottom, left),face_landmark  in zip(face_locations,face_landmarks):
        rectangle.append([left,top,right-left,bottom-top])
        pointTemp = []
        for value in face_landmark.values():
            for point in value:
                pointTemp.append([point[0], point[1]])
        keypoint.append(pointTemp)

    faceNum = len(face_locations)

    faceDic['faceNum'] = faceNum
    print(faceDic['faceNum'])
    if(faceNum == 0):
        return
    faceDic['face_locations'] = (np.array(rectangle)/scale).astype(int).tolist()
    faceDic['face_landmarks'] = (np.array(keypoint)/scale).astype(int).tolist()
    faceDic['face_encodings'] = np.asarray(face_encodings).tolist()



    # pic_id,face_num,locations,face_ids,landmarks

    print([a for a in  faceDic['face_locations']])
    print(faceDic['face_ids'])
    print([a for a in  faceDic['face_landmarks']])
    print([a for a in  faceDic['face_encodings']])

    # return faceDic

def getFaceIndex(known_face_encodings,known_face_ids,face_encodings):

    known_face_encodings = strToList(known_face_encodings,128)
    # face_encodings = strToList(face_encodings,128)
    # 计算 面孔编码两两之间的距离 来判断是否为同一人
    faceId = []
    known_face_ids = list(map(int, (re.compile(r'\d+')).findall(known_face_ids)))# 查找数字
    max_faceId = np.asarray(known_face_ids).max()

    for face_encoding in  face_encodings:
        #  找到差距小于 0.2 的所有位置 true false
        compare_faces = face_recognition.compare_faces(known_face_encodings,face_encoding,0.1)
        if not True in compare_faces:
            max_faceId +=1
            faceId.append(max_faceId)
            continue
        #  -1 表示为 在已有 中找不到 误差小于 0.2 的人脸
        face_distances = face_recognition.face_distance(known_face_encodings, face_encoding)
        # 取出这个最近人脸的评分
        best_match_index = np.argmin(face_distances)
        if compare_faces[best_match_index]:
            max_faceId = known_face_ids[best_match_index]
        else:
            max_faceId +=1
        faceId.append(max_faceId)
    return faceId
def strToList(str,y):
    M = (np.array(str.replace("[","").replace("]","").split(','))).astype(float).tolist()# 查找数字
    res =[]
    for i in range(int(len(M)/y)):
        res.append( np.asarray(M[i*y:(i+1)*y]))
    return res
s = np.random.rand(4,128).tolist()
known_face_encodings = str(s)
known_face_ids = "[1,2,3,4]"
face_encodings = str(s[2:])
# faceId = getFaceIndex(known_face_encodings,known_face_ids,face_encodings)
# print(faceId)
imgpath = "../face/6.jpg"
getFaceInfo(imgpath,known_face_encodings,known_face_ids)