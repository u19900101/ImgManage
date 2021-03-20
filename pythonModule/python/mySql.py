# -*- coding: utf-8 -*-
import dlib

import face_recognition
import numpy as  np
import cv2
import sys
import re
import time
import MySQLdb
import numpy as np
import  os
mydb = MySQLdb.connect("localhost","root","kk","t_imgs",charset="utf8")
baseDir = "D:\\MyJava\\mylifeImg\\target\\mylifeImg-1.0-SNAPSHOT\\"
cursor = mydb.cursor()
def getFaceInfo(imgpath,known_face_encodings,known_face_ids):
    print("当前检测图片为：",imgpath)
    rectangle = []
    keypoint = []
    scale = 1

    predicter_path ='shape_predictor_68_face_landmarks.dat'
    detector = dlib.get_frontal_face_detector()
    sp = dlib.shape_predictor(predicter_path)   # 导入检测人脸特征点的模型
    # 读入图片  解决中文路径问题
    bgr_img=cv2.imdecode(np.fromfile(imgpath,dtype=np.int8),-1)
    if bgr_img is None:
        print("Sorry, we could not load '{}' as an image".format(imgpath))
        return
    # opencv的颜色空间是BGR，需要转为RGB才能用在dlib中
    rgb_img = cv2.cvtColor(bgr_img, cv2.COLOR_BGR2RGB)
    # bgr_img = cv2.imread(face_file_path)
    if(rgb_img.shape[0]<2000):
        scale = 3000.0/rgb_img.shape[1]
        rgb_img = cv2.resize(rgb_img,(3000,int(rgb_img.shape[0]/(rgb_img.shape[1])*3000)))

    dets = detector(rgb_img, 1)
    # 检测到的人脸数量
    faceNum = len(dets)
    print(faceNum)
    if faceNum == 0:
        print("Sorry, there were no faces found in '{}'".format(imgpath))
        return
    # 坐标转化
    face_locations = []
    for det in dets:
        face_locations.append((det.top(),det.right(),det.bottom(),det.left()))

    faceDic = {}
    faceDic['faceNum'] = faceNum
    face_landmarks = face_recognition.face_landmarks(rgb_img,face_locations) #72个点
    face_encodings = face_recognition.face_encodings(rgb_img,face_locations)
    for (top, right, bottom, left),face_landmark  in zip(face_locations,face_landmarks):
        rectangle.append([left,top,right-left,bottom-top])
        pointTemp = []
        for value in face_landmark.values():
            for point in value:
                pointTemp.append([point[0], point[1]])
        keypoint.append(pointTemp)

    faceDic['face_locations'] = str((np.array(rectangle)/scale).astype(int).tolist())
    faceDic['face_landmarks'] = str((np.array(keypoint)/scale).astype(int).tolist())
    faceDic['face_encodings'] = str(np.asarray(face_encodings).tolist())

    # 与数据库比对  得到人脸 id  新人脸就在原有人脸最大id上+1，得到新id
    faceDic['face_name_ids'] = str(getFaceIndex(known_face_encodings,known_face_ids,face_encodings))


    # 人脸对齐
    faces = dlib.full_object_detections()
    for det in dets:
        faces.append(sp(rgb_img, det))
    images = dlib.get_face_chips(rgb_img, faces, size=320)
    return faceDic,images

def getFaceIndex(known_face_encodings,known_face_ids,face_encodings):
    new_faceId = -10 # -1 是未分类的id
    faceId = []
    if len(known_face_encodings) == 0 :
        for face_encoding in  face_encodings:
            new_faceId -=1
            face_id = new_faceId
            faceId.append(face_id)
        return faceId
    for face_encoding in  face_encodings:
        #  找到差距小于 0.2 的所有位置 true false
        compare_faces = face_recognition.compare_faces(known_face_encodings,face_encoding,0.5)
        #  -1 表示为 在已有 中找不到 误差小于 0.2 的人脸
        face_distances = face_recognition.face_distance(known_face_encodings, face_encoding)
        # 取出这个最近人脸的评分
        best_match_index = np.argmin(face_distances)
        if compare_faces[best_match_index]:
            face_id = known_face_ids[best_match_index]
        else:
            new_faceId -=1
            face_id = new_faceId
        faceId.append(face_id)
    return faceId

def sqlBase(sql,val):
    # try:
    cursor.execute(sql,val)
    # 最新插入行的主键id
    # insert_id = mydb.insert_id()
    # mydb.commit()    # 数据表内容有更新，必须使用到该语句
    # print(cursor.rowcount, "成功--增删改影响数量")
    return cursor.rowcount
    # except:
    #     print ("Error: 插入失败")

def sqlSelect(sql,val):
    try:
        cursor.execute(sql,val)
        return cursor.fetchall()
    except:
        print ("Error: unable to fetch data")

def getFaceData():
    sql = "SELECT face_name_ids,face_encodings FROM t_face_pic where face_num >0"
    know_face_encodings =[]
    know_face_name_ids =[]
    try:
        cursor.execute(sql)
        results =  np.array(cursor.fetchall(),dtype=str)
        if len(results)==0:
            return [],[]
        know_0 = results[:,0]
        know_1 = results[:,1]
        know_face_encodings = []
        know_face_name_ids = []
        for ids,encodings in zip(know_0,know_1):
            ids,encodings = eval(ids),eval(encodings)
            for know_id,know_encoding in zip(ids,encodings):
                know_face_encodings.append(np.asarray(know_encoding))
                know_face_name_ids.append(know_id)
    except:
        print ("Error: unable to fetch data")
    return know_face_encodings,know_face_name_ids
def insert_new_label():
    sql = "SELECT MAX(labelId) FROM t_label"
    max_label_id = sqlSelect(sql,())[0][0]+1
    insertSql = "INSERT INTO t_label (labelId,label_name,tags,href) VALUES (%s, %s, %s, %s)"
    insertVal = (max_label_id,"faceName_"+str(max_label_id),1,"label/selectByLabel?labelName=faceName_"+str(max_label_id))
    sqlBase(insertSql,insertVal)
    mydb.commit()
    face_name = "faceName_"+str(max_label_id)
    return cursor.rowcount,max_label_id,face_name
# 1.更新t_pic 表
# 2.更新未分类标签的数量
def update_t_pic(pic_id,label_id):
    sql = "SELECT plabel FROM t_pic where pid = %s"
    plabel = sqlSelect(sql,(pic_id,))[0][0]

    if plabel is None or plabel == "":
        sql = "SELECT tags FROM t_label where labelId = %s"
        tags = sqlSelect(sql,(-1,))[0][0]
        update_t_label_sql = "UPDATE t_label SET tags = %s WHERE labelId = %s"
        update_t_label_sql_val = (tags-1,-1)
        rowcount = sqlBase(update_t_label_sql,update_t_label_sql_val)
        val = (","+str(label_id)+",",pic_id)
    else:
        val = (plabel+str(label_id)+",",pic_id)
    sql = "UPDATE t_pic SET plabel = %s WHERE pid = %s"
    sqlBase(sql,val)
def insert_t_face(pic_id,face_name_id,face_encoding):
    insertSql = "INSERT INTO t_face (face_name_id,face_encoding,pic_id) VALUES (%s, %s, %s)"
    insertVal = (face_name_id,face_encoding,pic_id)
    return sqlBase(insertSql,insertVal)
def insert_t_face_pic(pic_id,faceDic,label_ids,face_paths):
    if faceDic is None:
        sql = "INSERT INTO t_face_pic (pic_id,face_num) VALUES (%s, %s)"
    #  特殊字符插入有bug
        val = (pic_id,0)
        print("插入t_face_pic 人脸数量：",0)
    else:
        sql = "INSERT INTO t_face_pic (pic_id,face_num,locations," \
              "face_name_ids,landmarks,face_encodings,face_paths) VALUES (%s, %s, %s, %s, %s, %s, %s)"
        #  特殊字符插入有bug
        res = "["
        for face_path in face_paths:
            res +=face_path + ","
        res +="]"
        val = (pic_id,faceDic['faceNum'],faceDic['face_locations'],str(label_ids),
               faceDic['face_landmarks'],faceDic['face_encodings'],res)
        # print("插入t_face_pic 人脸数量：",faceDic['faceNum'],faceDic['face_encodings'],str(face_paths))
    return sqlBase(sql,val)
def writeFaceToLocal(face_names,images):
    face_paths = []
    for face_name,image in zip(face_names,images):
        dirs = baseDir+"img\\face\\"+face_name
        if not os.path.exists(dirs):
            os.makedirs(dirs)
        faceids = os.listdir(dirs)
        # 得到最大的一个数字 +1 作为新的名称
        if len(faceids)>0:
            newid = int(faceids[-1].split('.')[0])+1
        else:
            newid = 0

        cv_rgb_image = np.array(image).astype(np.uint8)# 先转换为numpy数组
        cv_bgr_image = cv2.cvtColor(cv_rgb_image, cv2.COLOR_RGB2BGR)# opencv下颜色空间为bgr，所以从rgb转换为bgr
        path = dirs+'\\'+str(newid).zfill(5)+'.jpg'
        print("正在保存图片 ：" ,path)
        cv2.imwrite(path,cv_bgr_image)
        face_paths.append(path[path.index("img"):])
    return face_paths
def writeToMySql(pic_id):
    know_encodings,know_ids = getFaceData()
    sql = "select * from t_face_pic where pic_id = %s"
    val = (pic_id,)
    if len(sqlSelect(sql,val))>0:
        print("该图片已检测过",pic_id)
        return
    else:
        sql = "select * from t_pic where pid = %s"
        val = (pic_id,)

        imgpath = baseDir + sqlSelect(sql,val)[0][1]
        faceDic,images = getFaceInfo(imgpath,know_encodings,np.asarray(know_ids))

    label_ids = []
    try:
        if faceDic is not None:
            face_encodings = faceDic['face_encodings']
            face_names = []
            for face_name_id,face_encoding in zip(eval(faceDic['face_name_ids']),eval(face_encodings)):
                sql = "SELECT *  FROM t_label where labelId = %s"
                labels = sqlSelect(sql,(face_name_id,))
                if len(labels) == 0:
                    insert_row,face_name_id,face_name = insert_new_label()
                    print("新建人脸 face_name_id ",face_name_id)
                else:
                    print("增加 ",labels[0][1],"tags ")
                    sql = "UPDATE t_label SET tags = %s WHERE labelId = %s"
                    val = (labels[0][4]+1,face_name_id)
                    sqlBase(sql,val)
                    face_name = labels[0][1]
                label_ids.append(face_name_id)

                update_t_pic(pic_id,face_name_id)
                # insert_t_face(pic_id,face_name_id,str(face_encoding))
                # 截取人脸存到本地
                face_names.append(face_name)
            # i = 10/0 # 模拟回滚
        face_paths = writeFaceToLocal(face_names,images)
        insert_t_face_pic(pic_id,faceDic,label_ids,face_paths)
        mydb.commit()
        print(cursor.rowcount, "--成功--增删改影响数量")
        # mydb.close()
    except:
        mydb.rollback()
        print("出现错误进行回滚....")
def f():
    sql = "select pid from t_pic"
    pids = sqlSelect(sql,())
    count = 0
    for pic_id in pids:
        print(count,"开始检测...")
        writeToMySql(pic_id)
        count +=1
# pic_id = "1111111110000011100100111101011111000000001010010000010001010000"
#
# sql = "select pid from t_pic"
# pids = sqlSelect(sql,())
# writeToMySql(pids[5])

f()

# getFaceData()



