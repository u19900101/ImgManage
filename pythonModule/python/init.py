import face_recognition
import numpy as  np
import cv2
import sys
import re
def getFaceIndex(face_encodings):
    # face_encodings = strToList(face_encodings,128)
    # 计算 面孔编码两两之间的距离 来判断是否为同一人
    faceId = []

    for i in  range(len(face_encodings)):
        #  找到差距小于 0.2 的所有位置 true false
        compare_faces = face_recognition.compare_faces(face_encodings,face_encodings[i],0.1)
        if True in compare_faces:
            faceId.append(compare_faces.index(True))
    return faceId

def init(imgpath):
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

    faceDic['face_name_ids'] = getFaceIndex(face_encodings)

    for (top, right, bottom, left),face_landmark  in zip(face_locations,face_landmarks):
        rectangle.append([left,top,right-left,bottom-top])
        pointTemp = []
        for value in face_landmark.values():
            for point in value:
                pointTemp.append([point[0], point[1]])
        keypoint.append(pointTemp)

    faceNum = len(face_locations)

    faceDic['faceNum'] = faceNum

    if(faceNum == 0):
        print("faceNum is 0")
        return
    faceDic['face_encodings'] = np.asarray(face_encodings).tolist()
    faceDic['face_locations'] = (np.array(rectangle)/scale).astype(int).tolist()
    faceDic['face_landmarks'] = (np.array(keypoint)/scale).astype(int).tolist()


    print(faceDic['face_name_ids'])
    print([a for a in  faceDic['face_encodings']])
    print(faceDic['faceNum'])
    print([a for a in  faceDic['face_locations']])
    print([a for a in  faceDic['face_landmarks']])
if __name__ == '__main__':
    init(sys.argv[1])
# imgpath = "../face/6.jpg"
# init(imgpath)
