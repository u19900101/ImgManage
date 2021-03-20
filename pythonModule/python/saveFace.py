# coding: utf-8
import cv2
import dlib
import sys

import face_recognition
import numpy as np
import os
def getdemo(face_file_path):
    # 导入人脸检测模型
    print("当前检测图片为：",face_file_path)
    predicter_path ='shape_predictor_68_face_landmarks.dat'
    detector = dlib.get_frontal_face_detector()
    # 导入检测人脸特征点的模型
    sp = dlib.shape_predictor(predicter_path)
    # 读入图片
    bgr_img=cv2.imdecode(np.fromfile(face_file_path,dtype=np.int8),-1)
    # bgr_img = cv2.imread(face_file_path)
    if bgr_img is None:
        print("Sorry, we could not load '{}' as an image".format(face_file_path))
        return
    # opencv的颜色空间是BGR，需要转为RGB才能用在dlib中
    rgb_img = cv2.cvtColor(bgr_img, cv2.COLOR_BGR2RGB)
    # bgr_img = cv2.imread(face_file_path)
    if(rgb_img.shape[0]<2000):
        scale = 3000.0/rgb_img.shape[1]
        rgb_img = cv2.resize(rgb_img,(3000,int(rgb_img.shape[0]/(rgb_img.shape[1])*3000)))

    # opencv的颜色空间是BGR，需要转为RGB才能用在dlib中
    # rgb_img = cv2.cvtColor(bgr_img, cv2.COLOR_BGR2RGB)
    # 检测图片中的人脸
    dets = detector(rgb_img, 1)
    # (top, right, bottom, left)  803  982  892  892
    # (left,top, right, bottom) 892  803  982  892
    # 检测到的人脸数量
    faceNum = len(dets)
    print(faceNum)
    if faceNum == 0:
        print("Sorry, there were no faces found in '{}'".format(face_file_path))
        return

    face_locations = []
    for det in dets:
        face_locations.append((det.top(),det.right(),det.bottom(),det.left()))

    faceDic = {}
    faceDic['faceNum'] = faceNum
    face_landmarks = face_recognition.face_landmarks(rgb_img,face_locations) #72个点
    face_encodings = face_recognition.face_encodings(rgb_img,face_locations)


    # 识别人脸特征点，并保存下来
    faces = dlib.full_object_detections()
    for det in dets:
        faces.append(sp(rgb_img, det))

    # 人脸对齐
    images = dlib.get_face_chips(rgb_img, faces, size=320)
    # 显示计数，按照这个计数创建窗口
    image_cnt = 0
    # 显示对齐结果
    for image in images:
        image_cnt += 1
        cv_rgb_image = np.array(image).astype(np.uint8)# 先转换为numpy数组
        cv_bgr_image = cv2.cvtColor(cv_rgb_image, cv2.COLOR_RGB2BGR)# opencv下颜色空间为bgr，所以从rgb转换为bgr
        print("正在保存图片 ：" + str(image_cnt)+'.jpg')
        cv2.imwrite('./'+str(image_cnt)+'.jpg',cv_bgr_image)

# face_file_path = 'D:/py/My_work/6_27_facebook/mtcnn-keras-master/img1/M/静.jpg'# 要使用的图片，图片放在当前文件夹中
# face_file_path = '../face/d/静.jpg'# 要使用的图片，图片放在当前文件夹中
face_file_path = '../face/9.jpg'# 要使用的图片，图片放在当前文件夹中
getdemo(face_file_path)
print("写入完毕..")
