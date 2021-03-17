import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import ppppp.bean.Face;
import ppppp.bean.FacePictureWithBLOBs;
import ppppp.bean.Label;
import ppppp.bean.Picture;
import ppppp.dao.FaceMapper;
import ppppp.dao.FacePictureMapper;
import ppppp.dao.LabelMapper;
import ppppp.dao.PictureMapper;
import ppppp.util.MyUtils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * @author lppppp
 * @create 2021-03-16 16:23
 */
public class 数据库调用测试 {

    String baseDir = "D:\\MyJava\\mylifeImg\\target\\mylifeImg-1.0-SNAPSHOT\\";

    @Test
    public void T_(){

        // List<Picture> pictures = pictureMapper().selectAllPic().subList(30, 40);
        //
        // for (Picture picture : pictures) {
        //     getFaceMethod(picture.getPath(),picture.getPid());
        // }
        long l = System.currentTimeMillis();
        ArrayList<Picture> pictureArrayList = pictureMapper().selectAllPic();
        System.out.println(System.currentTimeMillis()-l);

    }
    public HashMap getFaceMethod(String imgPath, String pId){
        HashMap map = new HashMap();
        // 查看当前照片是否已经经过检测（判断图片路径）
        // String imgAbsPath= "D:\\MyJava\\mylifeImg\\pythonModule\\face\\d\\9.jpg";
        String imgAbsPath =  baseDir+imgPath;
        FacePictureWithBLOBs facePicture = new FacePictureWithBLOBs();
        ArrayList<String> faceNamesList = new ArrayList<>();
        facePicture = facePictureMapper().selectByPrimaryKey(imgPath);
        //该照片已进行过人脸检测 直接查询结果进行封装
        if(facePicture != null){
            System.out.println("该照片已进行过人脸检测");
            if(facePicture.getFaceIds() == null){
                map.put("faceNum", 0);
                return map;
            }
            String[] faceIds = facePicture.getFaceIds().replace("[", "").replace("]","").replace(" ", "").split(",");
            for (String faceId : faceIds) {
                Label label = labelMapper().selectByPrimaryKey(Integer.valueOf(faceId));
                faceNamesList.add(label.getLabelName());
            }
        }else {
            List face_encoding = new ArrayList();
            List face_name_id = new ArrayList();
            List<Face> faces = faceMapper().selectAllFaceEncoding();
            for (Face face : faces) {
                face_encoding.add(face.getFaceEncoding());
                face_name_id.add(face.getFaceNameId());
            }
            String known_face_encodings = face_encoding.toString();
            String known_face_ids = face_name_id.toString();
            try {
                String pyFilePath = "D:\\MyJava\\mylifeImg\\pythonModule\\python\\getFaceInfo.py";
                String[] args = new String[]{"python", pyFilePath, imgAbsPath,known_face_encodings,known_face_ids};
                Process proc = Runtime.getRuntime().exec(args);// 执行py文件
                BufferedReader in = new BufferedReader(new InputStreamReader(proc.getInputStream()));
                String line = null;

                // 1.初始化 t_face
                List  face_encodings = new ArrayList<>();
                String  face_landmarks = null;
                String  face_locations = null;
                String[]   face_name_ids = null;
                List<Integer> face_name_ids_List = new ArrayList();

                String faceNum = null;

                if ((line = in.readLine()) != null) {
                    if(Integer.valueOf(line) == 0){
                        System.out.println("未检测到人脸");
                        // 2.插入到 t_face_pic
                        FacePictureWithBLOBs facePicture2 = new FacePictureWithBLOBs(imgPath);

                        int insert = facePictureMapper().insert(facePicture2);
                        if(insert != 1){
                            System.out.println("失败....插入到 t_face_pic");
                        }else {
                            System.out.println("成功....插入到 t_face_pic");
                        }
                        map.put("faceNum", 0);
                        return map;
                    }
                    faceNum = line;
                }

                if ((line = in.readLine()) != null) {
                    face_name_ids = line.replace(" ","").replace("[", "").replace("]", "").replace(",", " ").trim().split(" ");
                    // 初始化 人脸标签库 得到人脸 id
                    for (String name_id : face_name_ids) {
                        Integer labelId =Integer.valueOf(name_id);
                        Label label1 = labelMapper().selectByPrimaryKey(labelId);
                        String faceName = null;
                        int insert = 0;
                        if(label1 == null){
                            // 新的人脸 创建 label
                            faceName = "faceName_" + name_id;
                            Label label = new Label(faceName);
                            insert = labelMapper().insert(label);
                            if(insert != 1){
                                System.out.println("失败--插入人脸到t_label");
                                map.put("msg", "失败--插入人脸到t_label");
                                return map;
                            }
                            labelId = label.getLabelid();

                        }else {
                            // 已存在的人脸 数量+1
                            label1.setTags(label1.getTags()+1);
                            insert = labelMapper().updateByPrimaryKey(label1);

                            faceName = label1.getLabelName();
                        }
                        face_name_ids_List.add(labelId);
                        faceNamesList.add(faceName);
                        Picture picture = pictureMapper().selectByPrimaryKey(pId);
                        picture.setPlabel(picture.getPlabel() == null || picture.getPlabel().length()<=1?","+labelId+",":picture.getPlabel()+labelId+",");
                        // 1.更新 t_pic 表
                        // 不存在标签 向数据库中插入该标签
                        int updatePic = pictureMapper().updateByPrimaryKeySelective(picture);
                        if(insert != 1 || updatePic != 1){
                            System.out.println("失败--插入人脸到t_label");
                            map.put("msg", "失败--插入人脸到t_label");
                            return map;
                        }
                    }
                }
                if ((line = in.readLine()) != null) {
                    face_encodings = MyUtils.strToList(line,128);
                }
                if ((line = in.readLine()) != null) {
                    face_locations = line;
                }
                if ((line = in.readLine()) != null) {
                    face_landmarks = line;
                }

                // 1.face_id	2.face_name_id	3.face_code	 4.pic_id
                for (int i = 0; i < Integer.valueOf(faceNum); i++) {
                    faceMapper().insert(new Face(face_name_ids_List.get(i), imgPath, (String) face_encodings.get(i)));
                }

                // 2.插入到 t_face_pic
                facePicture = new FacePictureWithBLOBs(imgPath, Integer.valueOf(faceNum), face_name_ids_List.toString(), face_locations, face_landmarks);

                int insert = facePictureMapper().insert(facePicture);
                if(insert != 1){
                    System.out.println("失败....插入到 t_face_pic");
                }else {
                    System.out.println("成功....插入到 t_face_pic");
                }
                facePicture.setPicId(facePicture.getPicId().replace("\\", "/"));
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        map.put("faceNamesList", faceNamesList);
        map.put("faceNum", facePicture.getFaceNum());
        map.put("face_locations", facePicture.getLocations());
        map.put("face_landmarks", facePicture.getLandmarks());
        map.put("srcImgPath", facePicture.getPicId().replace("\\", "/"));

        return map;
    }

    private FacePictureMapper facePictureMapper() {
        ApplicationContext context = new ClassPathXmlApplicationContext("spring.xml");
        return context.getBean(FacePictureMapper.class);
    }
    public PictureMapper pictureMapper(){
        ApplicationContext context = new ClassPathXmlApplicationContext("spring.xml");
        return context.getBean(PictureMapper.class);
    }
    public FaceMapper faceMapper(){
        ApplicationContext context = new ClassPathXmlApplicationContext("spring.xml");
        return context.getBean(FaceMapper.class);
    }
    public LabelMapper labelMapper(){
        ApplicationContext context = new ClassPathXmlApplicationContext("spring.xml");
        return context.getBean(LabelMapper.class);
    }

}
