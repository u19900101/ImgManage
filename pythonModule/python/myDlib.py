import cv2
import dlib
import sys
import time
import numpy as np
def getface_dlib(imgpath,landmarkpath):
    s = time.time()
    img = cv2.imread(imgpath)
    img = cv2.resize(img,(3000,int(img.shape[0]/(img.shape[1])*3000)))
    # gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    # 彩色图像识别效果更强一些
    # img = cv2.resize(img,(800,int(img.shape[0]/img.shape[1]*800)))
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

    #人脸分类器
    detector = dlib.get_frontal_face_detector()
    # 获取人脸检测器
    predictor = dlib.shape_predictor(landmarkpath)
    dets = detector(gray, 1)

      # 识别人脸特征点，并保存下来
    faces = dlib.full_object_detections()
    for det in dets:
        faces.append(predictor(img, det))
    # 人脸对齐
    # images = dlib.get_face_chips(img, faces, size=320)
    # print("人脸数量为",len(dets))
    print(len(dets))
    keypoint = [];
    for face in dets:
        shape = predictor(img, face)  # 寻找人脸的68个标定点
        k = shape.parts()
        keypoint.append(k)
    # print("getface_dlib 查找人脸耗时： ",time.time()-s)
    return dets,keypoint
def face_encoding(faceimages):
    s = time.time()
    myface_encodings = []
    for face in faceimages:
        if len(face_recognition.face_encodings(face))>0:
            face_encoding = face_recognition.face_encodings(face)[0]
            myface_encodings.append(face_encoding)
    print("face_encoding 编码图片耗时： ",time.time()-s)
    return myface_encodings
def getFace(face_encodings,known_face_encodings,known_face_names):
    s = time.time()
    face_names = []
    for face_encoding in face_encodings:
        # 取出一张脸并与数据库中所有的人脸进行对比，计算得分
        matches = face_recognition.compare_faces(known_face_encodings, face_encoding, tolerance = 0.4)
        # print(len(matches),matches) # [True, False,] 
        name = "Unknown"
        # 找出距离最近的人脸
        face_distances = face_recognition.face_distance(known_face_encodings, face_encoding)
        # 取出这个最近人脸的评分
        best_match_index = np.argmin(face_distances)
        if matches[best_match_index]:
            name = known_face_names[best_match_index]
        face_names.append(name)
    print(" 有人脸",face_names,"人脸与数据库对比耗时： ",time.time()-s)
# imgpath = "../face/7.jpg";
# landmarkpath = "D:\\MyJava\\mylifeImg\\src\\main\\java\\ppppp\\python\\shape_predictor_68_face_landmarks.dat";
#
# dets,keypoint = getface_dlib(imgpath,landmarkpath)
if __name__ == '__main__':
    a = []
    for i in range(1, len(sys.argv)):
        a.append(sys.argv[i])
    dets,keypoint = getface_dlib(a[0],a[1])
    print(dets)
    print(keypoint)
