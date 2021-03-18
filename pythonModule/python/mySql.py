# -*- coding: utf-8 -*-
import face_recognition
import numpy as  np
import cv2
import sys
import re
import time
import MySQLdb
import numpy as np
mydb = MySQLdb.connect("localhost","root","kk","t_imgs",charset="utf8")
cursor = mydb.cursor()
def getFaceInfo(imgpath,known_face_encodings,known_face_ids):
    rectangle = []
    keypoint = []
    scale = 1
    #  解决中文路径的问题
    ## imdecode读取的是rgb，如果后续需要opencv处理的话，需要转换成bgr，转换后图片颜色会变化
    img=cv2.imdecode(np.fromfile(imgpath,dtype=np.int8),-1)
    # img = cv2.imread(imgpath) # 0.22s
    if(img.shape[0]<2000):
        img = cv2.resize(img,(3000,int(img.shape[0]/(img.shape[1])*3000)))
        scale = 3000.0/img.shape[1]
    img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

    face_locations = face_recognition.face_locations(img_rgb,1)
    faceNum = len(face_locations)
    faceDic = {}
    faceDic['faceNum'] = faceNum
    if(faceNum == 0):
        print("无人脸",imgpath)
        return
    face_landmarks = face_recognition.face_landmarks(img,face_locations) #72个点
    face_encodings = face_recognition.face_encodings(img,face_locations)

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
    return faceDic

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
    sql = "SELECT face_name_id,face_encoding FROM t_face"
    try:
        cursor.execute(sql)
        results =  np.array(cursor.fetchall(),dtype=str)
        if len(results)==0:
            return [],[]
        know_0 = results[:,0]
        know_1 = results[:,1]
        know_encodings = []
        know_ids = []
        for know_id,know_encoding in zip(know_0,know_1):
            know_encodings.append(np.asarray(eval(know_encoding)))
            know_ids.append(eval(know_id))
    except:
        print ("Error: unable to fetch data")
    return know_encodings,know_ids
def insert_new_label():
    sql = "SELECT MAX(labelId) FROM t_label"
    max_label_id = sqlSelect(sql,())[0][0]+1
    insertSql = "INSERT INTO t_label (labelId,label_name,tags,href) VALUES (%s, %s, %s, %s)"
    insertVal = (max_label_id,"faceName_"+str(max_label_id),1,"label/selectByLabel?labelName=faceName_"+str(max_label_id))
    return sqlBase(insertSql,insertVal),max_label_id
def update_t_pic(pic_id,label_id):
    sql = "SELECT plabel FROM t_pic where pid = %s"
    plabel = sqlSelect(sql,(pic_id,))[0][0]
    sql = "UPDATE t_pic SET plabel = %s WHERE pid = %s"
    if plabel is None or plabel == "":
        val = (","+str(label_id)+",",pic_id)
    else:
        val = (plabel+str(label_id)+",",pic_id)
    sqlBase(sql,val)
def insert_t_face(pic_id,face_name_id,face_encoding):
    insertSql = "INSERT INTO t_face (face_name_id,face_encoding,pic_id) VALUES (%s, %s, %s)"
    insertVal = (face_name_id,face_encoding,pic_id)
    return sqlBase(insertSql,insertVal)
def insert_t_face_pic(pic_id,faceDic,label_ids):
    if faceDic is None:
        sql = "INSERT INTO t_face_pic (pic_id,face_num) VALUES (%s, %s)"
    #  特殊字符插入有bug
        val = (pic_id,0)
        print("插入t_face_pic 人脸数量：",0)
    else:
        sql = "INSERT INTO t_face_pic (pic_id,face_num,locations,face_ids,landmarks) VALUES (%s, %s, %s, %s, %s)"
        #  特殊字符插入有bug
        val = (pic_id,faceDic['faceNum'],faceDic['face_locations'],str(label_ids),faceDic['face_landmarks'])
        print("插入t_face_pic 人脸数量：",faceDic['faceNum'])
    return sqlBase(sql,val)
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
        baseDir = "D:\\MyJava\\mylifeImg\\target\\mylifeImg-1.0-SNAPSHOT\\"
        imgpath = baseDir + sqlSelect(sql,val)[0][1]
        faceDic = getFaceInfo(imgpath,know_encodings,np.asarray(know_ids))


    # imgpath = "img\\2020\\12\\2020_12_21T19_35_22.jpg"
    label_ids = []
    try:
        if faceDic is not None:
            face_encodings = faceDic['face_encodings']

            for face_name_id,face_encoding in zip(eval(faceDic['face_name_ids']),eval(face_encodings)):
                sql = "SELECT *  FROM t_label where labelId = %s"
                labels = sqlSelect(sql,(face_name_id,))
                if len(labels) == 0:
                    insert_row,face_name_id = insert_new_label()
                    print("新建人脸 face_name_id ",face_name_id)
                else:
                    print("增加 ",labels[0][1],"tags ")
                    sql = "UPDATE t_label SET tags = %s WHERE labelId = %s"
                    val = (labels[0][4]+1,face_name_id)
                    sqlBase(sql,val)
                label_ids.append(face_name_id)
                update_t_pic(pic_id,face_name_id)
                insert_t_face(pic_id,face_name_id,str(face_encoding))
            # i = 10/0 # 模拟回滚
        insert_t_face_pic(pic_id,faceDic,label_ids)
        mydb.commit()
        print(cursor.rowcount, "--成功--增删改影响数量")
    except:
        mydb.rollback()
        print("出现错误进行回滚....")

# pic_id = "1111111110000011100100111101011111000000001010010000010001010000"
#
sql = "select pid from t_pic"
pids = sqlSelect(sql,())
count = 100
# pids[119]
# pids[110]
#
# writeToMySql(pids[125])
for pic_id in pids[200:]:
    print(count,"开始检测...")
    writeToMySql(pic_id)
    count +=1


