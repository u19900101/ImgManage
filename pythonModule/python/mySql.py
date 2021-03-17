import face_recognition
import numpy as  np
import cv2
import sys
import re
import time
import MySQLdb
import numpy as np
mydb = MySQLdb.connect("localhost","root","kk","t_imgs")
def getFaceInfo(imgpath,known_face_encodings,known_face_ids):
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
    if(faceNum == 0):
        return
    faceDic['face_locations'] = str((np.array(rectangle)/scale).astype(int).tolist())
    faceDic['face_landmarks'] = str((np.array(keypoint)/scale).astype(int).tolist())
    faceDic['face_encodings'] = str(np.asarray(face_encodings).tolist())

    # 与数据库比对  得到人脸 id  新人脸就在原有人脸最大id上+1，得到新id
    faceDic['face_name_ids'] = str(getFaceIndex(known_face_encodings,known_face_ids,face_encodings))
    return faceDic

def getFaceIndex(known_face_encodings,known_face_ids,face_encodings):
    new_faceId = -10 # -1 是未分类的id
    faceId = []
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
    cursor = mydb.cursor()
    try:
        cursor.execute(sql,val)
        # 最新插入行的主键id
        # insert_id = mydb.insert_id()
        mydb.commit()    # 数据表内容有更新，必须使用到该语句
        print(cursor.rowcount, "成功--增删改影响数量")
        return cursor.rowcount
    except:
        print ("Error: 插入失败")

def sqlSelect(sql,val):
    cursor = mydb.cursor()
    try:
        cursor.execute(sql,val)
        return cursor.fetchall()
    except:
        print ("Error: unable to fetch data")

def getFaceData():
    cursor = mydb.cursor()
    sql = "SELECT face_name_id,face_encoding FROM t_face"
    try:
        cursor.execute(sql)
        results =  np.array(cursor.fetchall(),dtype=str)
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
def update_t_pic(imgpath,label_id):
    sql = "SELECT plabel FROM t_pic where path = %s"
    plabel = sqlSelect(sql,(imgpath,))[0][0]
    sql = "UPDATE t_pic SET plabel = %s WHERE path = %s"
    if plabel is None or plabel == "":
        val = (","+str(label_id)+",",imgpath)
    else:
        val = (plabel+str(label_id)+",",imgpath)
    sqlBase(sql,val)
def insert_t_face(imgpath,face_name_id,face_encoding):
    insertSql = "INSERT INTO t_face (face_name_id,face_encoding,pic_id) VALUES (%s, %s, %s)"
    insertVal = (face_name_id,face_encoding,imgpath)
    return sqlBase(insertSql,insertVal)
def insert_t_face_pic(imgpath,faceDic,label_ids):
    sql = "INSERT INTO t_face_pic (pic_id,face_num,locations,face_ids,landmarks) VALUES (%s, %s, %s, %s, %s)"
    #  特殊字符插入有bug
    val = (imgpath.replace("\\","/"),faceDic['faceNum'],faceDic['face_locations'],str(label_ids),faceDic['face_landmarks'])
    return sqlBase(sql,val)

know_encodings,know_ids = getFaceData()
imgpath = "img/2020/11/2020_11_11T12_26_09.jpg"
sql = "select * from t_face_pic where pic_id = %s"
val = (imgpath,)
if len(sqlSelect(sql,val))>0:
    print("该图片已检测过")
else:
    faceDic = getFaceInfo(imgpath,know_encodings,np.asarray(know_ids))







sql = "SELECT *  FROM t_label where labelId = %s"
# imgpath = "img\\2020\\12\\2020_12_21T19_35_22.jpg"
label_ids = []
face_encodings = faceDic['face_encodings']
for face_name_id,face_encoding in zip(eval(faceDic['face_name_ids']),eval(face_encodings)):
    labels = sqlSelect(sql,(face_name_id,))
    if(len(labels) == 0):
        print("新建人脸 face_name_id ",face_name_id)
        insert_row,face_name_id = insert_new_label()
    else:
        print("增加 ",labels[0][1],"tags ")
        sql = "UPDATE t_label SET tags = %s WHERE labelId = %s"
        val = (labels[0][4]+1,face_name_id)
        sqlBase(sql,val)
    label_ids.append(face_name_id)
    update_t_pic(imgpath,face_name_id)
    insert_t_face(imgpath,face_name_id,str(face_encoding))
insert_t_face_pic(imgpath,faceDic,label_ids)