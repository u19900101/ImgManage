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
    print(faceDic['faceNum'])
    if(faceNum == 0):
        return
    faceDic['face_locations'] = (np.array(rectangle)/scale).astype(int).tolist()
    faceDic['face_landmarks'] = (np.array(keypoint)/scale).astype(int).tolist()
    faceDic['face_encodings'] = np.asarray(face_encodings).tolist()


    # 与数据库比对  得到人脸 id  新人脸就在原有人脸最大id上+1，得到新id
    faceDic['face_ids'] = getFaceIndex(known_face_encodings,known_face_ids,face_encodings)
    # pic_id,face_num,locations,face_ids,landmarks

    print([a for a in  faceDic['face_locations']])
    print(faceDic['face_ids'])
    print([a for a in  faceDic['face_landmarks']])
    print([a for a in  faceDic['face_encodings']])


    # return faceDic

def getFaceIndex(known_face_encodings,known_face_ids,face_encodings):

    known_face_encodings = strToList(known_face_encodings,128)

    # 计算 面孔编码两两之间的距离 来判断是否为同一人
    faceId = []
    known_face_ids = list(map(int, (re.compile(r'\d+')).findall(known_face_ids)))# 查找数字
    max_faceId = np.asarray(known_face_ids).max()

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
            max_faceId +=1
            face_id = max_faceId
        faceId.append(face_id)
    return faceId
def strToList(str,y):
    M = (np.array(str.replace("[","").replace("]","").split(','))).astype(float).tolist()# 查找数字
    res =[]
    for i in range(int(len(M)/y)):
        res.append( np.asarray(M[i*y:(i+1)*y]))
    return res
# imgpath = "../face/6.jpg"
# # faceDic = init(imgpath)
# # print(faceDic)
# k_en = "[[-0.022834885865449905, -0.013802939094603062, 0.0029389522969722748, -0.042331527918577194, -0.036763351410627365, -0.06913075596094131, -0.04332069307565689, -0.11545366048812866, 0.12632925808429718, -0.0907406359910965, 0.23085357248783112, -0.09232445061206818, -0.2305309772491455, -0.10378826409578323, -0.057692039757966995, 0.18100687861442566, -0.13906297087669373, -0.12566958367824554, -0.05405247211456299, 0.030917704105377197, 0.09482577443122864, -0.02022041380405426, 0.0053490400314331055, 0.06884001195430756, -0.1259840577840805, -0.34013086557388306, -0.13103780150413513, -0.08421936631202698, -0.05631003901362419, -0.07067498564720154, -0.045991212129592896, 0.11862901598215103, -0.13752105832099915, 0.009470473974943161, 0.041768819093704224, 0.04796783998608589, 0.03485319763422012, -0.05196763575077057, 0.16419541835784912, 0.014049118384718895, -0.2810373306274414, 0.02937339060008526, 0.025483455508947372, 0.2228596806526184, 0.1734302043914795, 0.006144563667476177, -0.0075507014989852905, -0.15715812146663666, 0.10663694143295288, -0.1399655044078827, 0.02266889251768589, 0.10937392711639404, 0.09286586195230484, 0.039662349969148636, 0.012870749458670616, -0.09817356616258621, 0.012453965842723846, 0.1209140419960022, -0.16984297335147858, -0.031018204987049103, 0.015731502324342728, -0.13375996053218842, -0.044117819517850876, -0.11635033041238785, 0.1727331131696701, 0.07557569444179535, -0.12115654349327087, -0.190398707985878, 0.14663854241371155, -0.15190596878528595, -0.05025138705968857, 0.11840397119522095, -0.1535266935825348, -0.1887577623128891, -0.3106735348701477, -0.011321647092700005, 0.341266930103302, 0.08348941802978516, -0.23574550449848175, 0.04638682305812836, -0.0630284994840622, 0.015792790800333023, 0.14515501260757446, 0.1287955641746521, 0.04141320660710335, 0.019672930240631104, -0.10981252789497375, -0.01749645173549652, 0.21438078582286835, -0.11450610309839249, -0.017947107553482056, 0.2067253738641739, -0.03470892831683159, 0.08493780344724655, 0.006373962387442589, 0.01252283900976181, -0.0457242988049984, 0.055555276572704315, -0.1166352778673172, -0.012638650834560394, 0.03447915241122246, 0.024171169847249985, -0.005052044987678528, 0.08594578504562378, -0.11098217964172363, 0.07693938910961151, 0.037946466356515884, 0.009359689429402351, 0.0562986359000206, -0.004606084898114204, -0.07443134486675262, -0.11625683307647705, 0.10372993350028992, -0.27965906262397766, 0.1578962802886963, 0.13240957260131836, 0.08105415850877762, 0.07586409151554108, 0.03973495960235596, 0.0873270034790039, -0.06345000118017197, -0.07950236648321152, -0.23084065318107605, 0.04661783576011658, 0.15054501593112946, 0.009585132822394371, 0.03438431769609451, -0.053176186978816986], [-0.11825861036777496, 0.04915862902998924, 0.06903685629367828, -0.05819728225469589, -0.08897768706083298, -0.07185576856136322, -0.046024177223443985, -0.057649292051792145, 0.15126483142375946, -0.09419794380664825, 0.2461787611246109, -0.12812389433383942, -0.2592028081417084, -0.09480959177017212, -0.025718316435813904, 0.21543969213962555, -0.21477481722831726, -0.07726842910051346, 0.0126909539103508, 0.01519523561000824, 0.13964277505874634, 0.0017896723002195358, 0.03144191578030586, 0.05953390151262283, -0.11791184544563293, -0.42182785272598267, -0.10884703695774078, -0.0725506842136383, 0.03154096007347107, -0.051472507417201996, -0.06291381269693375, 0.02651319094002247, -0.1882096529006958, -0.07922888547182083, 0.0029536783695220947, 0.06672757118940353, -0.002278439234942198, -0.07611808180809021, 0.18582786619663239, 0.009779013693332672, -0.290788471698761, -0.015116099268198013, 0.029516976326704025, 0.23993287980556488, 0.17168456315994263, 0.08887393027544022, 0.03002234920859337, -0.11360159516334534, 0.06645035743713379, -0.19399502873420715, 0.024545123800635338, 0.11290828138589859, 0.08012722432613373, 0.006480492651462555, -0.012488525360822678, -0.13372091948986053, 0.05424286425113678, 0.10679683089256287, -0.22681382298469543, -0.026030708104372025, 0.09847485274076462, -0.0906519740819931, 0.05620303750038147, -0.0034779682755470276, 0.26015040278434753, 0.044274214655160904, -0.10519144684076309, -0.17828619480133057, 0.13565678894519806, -0.16894714534282684, -0.037980686873197556, 0.10181944817304611, -0.12010770291090012, -0.17593519389629364, -0.4007662832736969, -0.04275020211935043, 0.4299006462097168, 0.08757861703634262, -0.1626228243112564, 0.04045096039772034, -0.1241329163312912, -0.00195382721722126, 0.19166743755340576, 0.13449473679065704, -0.0008216984570026398, 0.024199917912483215, -0.15272094309329987, -0.016157254576683044, 0.21668848395347595, -0.07670328766107559, -0.056074343621730804, 0.2123553454875946, 0.04272289574146271, 0.08253134042024612, 0.017842618748545647, 0.03899769484996796, -0.08220463991165161, 0.032945021986961365, -0.0822468250989914, -0.015029087662696838, 0.03663666918873787, -0.00619914848357439, 0.008278325200080872, 0.14852744340896606, -0.2229294627904892, 0.1248430460691452, 0.016504459083080292, -0.010622246190905571, 0.010256370529532433, 0.006239213049411774, -0.10829469561576843, -0.07655877619981766, 0.10261870920658112, -0.29181498289108276, 0.12983360886573792, 0.22180181741714478, 0.06778649985790253, 0.13137762248516083, 0.0912918895483017, 0.03684549033641815, -0.04259098693728447, -0.061904631555080414, -0.22649110853672028, 0.0025956295430660248, 0.08619814366102219, -0.029610704630613327, 0.15119017660617828, 0.024150971323251724], [-0.022834885865449905, -0.013802939094603062, 0.0029389522969722748, -0.042331527918577194, -0.036763351410627365, -0.06913075596094131, -0.04332069307565689, -0.11545366048812866, 0.12632925808429718, -0.0907406359910965, 0.23085357248783112, -0.09232445061206818, -0.2305309772491455, -0.10378826409578323, -0.057692039757966995, 0.18100687861442566, -0.13906297087669373, -0.12566958367824554, -0.05405247211456299, 0.030917704105377197, 0.09482577443122864, -0.02022041380405426, 0.0053490400314331055, 0.06884001195430756, -0.1259840577840805, -0.34013086557388306, -0.13103780150413513, -0.08421936631202698, -0.05631003901362419, -0.07067498564720154, -0.045991212129592896, 0.11862901598215103, -0.13752105832099915, 0.009470473974943161, 0.041768819093704224, 0.04796783998608589, 0.03485319763422012, -0.05196763575077057, 0.16419541835784912, 0.014049118384718895, -0.2810373306274414, 0.02937339060008526, 0.025483455508947372, 0.2228596806526184, 0.1734302043914795, 0.006144563667476177, -0.0075507014989852905, -0.15715812146663666, 0.10663694143295288, -0.1399655044078827, 0.02266889251768589, 0.10937392711639404, 0.09286586195230484, 0.039662349969148636, 0.012870749458670616, -0.09817356616258621, 0.012453965842723846, 0.1209140419960022, -0.16984297335147858, -0.031018204987049103, 0.015731502324342728, -0.13375996053218842, -0.044117819517850876, -0.11635033041238785, 0.1727331131696701, 0.07557569444179535, -0.12115654349327087, -0.190398707985878, 0.14663854241371155, -0.15190596878528595, -0.05025138705968857, 0.11840397119522095, -0.1535266935825348, -0.1887577623128891, -0.3106735348701477, -0.011321647092700005, 0.341266930103302, 0.08348941802978516, -0.23574550449848175, 0.04638682305812836, -0.0630284994840622, 0.015792790800333023, 0.14515501260757446, 0.1287955641746521, 0.04141320660710335, 0.019672930240631104, -0.10981252789497375, -0.01749645173549652, 0.21438078582286835, -0.11450610309839249, -0.017947107553482056, 0.2067253738641739, -0.03470892831683159, 0.08493780344724655, 0.006373962387442589, 0.01252283900976181, -0.0457242988049984, 0.055555276572704315, -0.1166352778673172, -0.012638650834560394, 0.03447915241122246, 0.024171169847249985, -0.005052044987678528, 0.08594578504562378, -0.11098217964172363, 0.07693938910961151, 0.037946466356515884, 0.009359689429402351, 0.0562986359000206, -0.004606084898114204, -0.07443134486675262, -0.11625683307647705, 0.10372993350028992, -0.27965906262397766, 0.1578962802886963, 0.13240957260131836, 0.08105415850877762, 0.07586409151554108, 0.03973495960235596, 0.0873270034790039, -0.06345000118017197, -0.07950236648321152, -0.23084065318107605, 0.04661783576011658, 0.15054501593112946, 0.009585132822394371, 0.03438431769609451, -0.053176186978816986], [-0.11825861036777496, 0.04915862902998924, 0.06903685629367828, -0.05819728225469589, -0.08897768706083298, -0.07185576856136322, -0.046024177223443985, -0.057649292051792145, 0.15126483142375946, -0.09419794380664825, 0.2461787611246109, -0.12812389433383942, -0.2592028081417084, -0.09480959177017212, -0.025718316435813904, 0.21543969213962555, -0.21477481722831726, -0.07726842910051346, 0.0126909539103508, 0.01519523561000824, 0.13964277505874634, 0.0017896723002195358, 0.03144191578030586, 0.05953390151262283, -0.11791184544563293, -0.42182785272598267, -0.10884703695774078, -0.0725506842136383, 0.03154096007347107, -0.051472507417201996, -0.06291381269693375, 0.02651319094002247, -0.1882096529006958, -0.07922888547182083, 0.0029536783695220947, 0.06672757118940353, -0.002278439234942198, -0.07611808180809021, 0.18582786619663239, 0.009779013693332672, -0.290788471698761, -0.015116099268198013, 0.029516976326704025, 0.23993287980556488, 0.17168456315994263, 0.08887393027544022, 0.03002234920859337, -0.11360159516334534, 0.06645035743713379, -0.19399502873420715, 0.024545123800635338, 0.11290828138589859, 0.08012722432613373, 0.006480492651462555, -0.012488525360822678, -0.13372091948986053, 0.05424286425113678, 0.10679683089256287, -0.22681382298469543, -0.026030708104372025, 0.09847485274076462, -0.0906519740819931, 0.05620303750038147, -0.0034779682755470276, 0.26015040278434753, 0.044274214655160904, -0.10519144684076309, -0.17828619480133057, 0.13565678894519806, -0.16894714534282684, -0.037980686873197556, 0.10181944817304611, -0.12010770291090012, -0.17593519389629364, -0.4007662832736969, -0.04275020211935043, 0.4299006462097168, 0.08757861703634262, -0.1626228243112564, 0.04045096039772034, -0.1241329163312912, -0.00195382721722126, 0.19166743755340576, 0.13449473679065704, -0.0008216984570026398, 0.024199917912483215, -0.15272094309329987, -0.016157254576683044, 0.21668848395347595, -0.07670328766107559, -0.056074343621730804, 0.2123553454875946, 0.04272289574146271, 0.08253134042024612, 0.017842618748545647, 0.03899769484996796, -0.08220463991165161, 0.032945021986961365, -0.0822468250989914, -0.015029087662696838, 0.03663666918873787, -0.00619914848357439, 0.008278325200080872, 0.14852744340896606, -0.2229294627904892, 0.1248430460691452, 0.016504459083080292, -0.010622246190905571, 0.010256370529532433, 0.006239213049411774, -0.10829469561576843, -0.07655877619981766, 0.10261870920658112, -0.29181498289108276, 0.12983360886573792, 0.22180181741714478, 0.06778649985790253, 0.13137762248516083, 0.0912918895483017, 0.03684549033641815, -0.04259098693728447, -0.061904631555080414, -0.22649110853672028, 0.0025956295430660248, 0.08619814366102219, -0.029610704630613327, 0.15119017660617828, 0.024150971323251724]]"
# k_enId = "[0, 1, 0, 1]"
# getFaceInfo(imgpath,k_en,k_enId)

if __name__ == '__main__':
    # print(sys.argv[1],sys.argv[2],sys.argv[3])
    getFaceInfo(sys.argv[1],sys.argv[2],sys.argv[3])


