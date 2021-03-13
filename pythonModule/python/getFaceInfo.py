import face_recognition
import numpy as  np
import cv2
import sys
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
    faceDic['face_locations'] = (np.array(rectangle)/scale).astype(int)
    faceDic['face_landmarks'] = (np.array(keypoint)/scale).astype(int)
    faceDic['face_encodings'] = face_encodings
    faceDic['face_id'] = getFaceIndex(face_encodings)
    print(faceNum)
    print(faceDic['face_locations'].tolist())

    print(np.asarray(face_encodings).flatten())
    print(faceDic['face_id'])

    # return faceDic
def getFaceIndex(face_encodings):
    # 计算 面孔编码两两之间的距离 来判断是否为同一人
    faceId = []
    for i in range(len(face_encodings)):
        #  找到差距小于 0.2 的所有位置 true false
        compare_faces = face_recognition.compare_faces(face_encodings,face_encodings[i],0.1)
        #  -1 表示为 在已有 中找不到 误差小于 0.2 的人脸
        faceidTemp = -1
        if True in compare_faces:
            faceidTemp = compare_faces.index(True)
        faceId.append(faceidTemp)
    return faceId

# imgpath = "../face/d/9.jpg"
# faceDic = init(imgpath)
# print(faceDic)

if __name__ == '__main__':
    init(sys.argv[1])

