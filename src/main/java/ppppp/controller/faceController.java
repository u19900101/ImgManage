package ppppp.controller;

import com.google.gson.Gson;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import ppppp.bean.Face;
import ppppp.bean.FacePictureWithBLOBs;
import ppppp.bean.Label;
import ppppp.bean.Picture;
import ppppp.dao.FaceMapper;
import ppppp.dao.FacePictureMapper;
import ppppp.dao.LabelMapper;
import ppppp.dao.PictureMapper;
import ppppp.util.MyUtils;

import javax.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * @author lppppp
 * @create 2021-03-11 13:01
 */
@Controller
@RequestMapping("/face")
public class faceController {
    String baseDir = "D:\\MyJava\\mylifeImg\\target\\mylifeImg-1.0-SNAPSHOT\\";
    @Autowired
    LabelMapper labelMapper;
    @Autowired
    PictureMapper pictureMapper;
    @Autowired
    FaceMapper faceMapper;
    @Autowired
    FacePictureMapper facePictureMapper;



    @ResponseBody
    @RequestMapping(value = "/getFace",method = RequestMethod.POST)
    public String getFace(String imgPath,String pId,HttpServletRequest request){
        HashMap map = new HashMap();
        // 查看当前照片是否已经经过检测（判断图片路径）
        // String imgAbsPath= "D:\\MyJava\\mylifeImg\\pythonModule\\face\\d\\9.jpg";
        String imgAbsPath =  baseDir+imgPath;
        FacePictureWithBLOBs facePicture = getFacePictureMapper().selectByPrimaryKey(imgPath);
        if(facePicture != null){
            System.out.println("该照片已进行过人脸检测");

            /*map.put("faceNum", facePicture.getFaceNum());
            map.put("face_locations", facePicture.getLocations());
            map.put("face_ids", facePicture.getFaceIds());
            map.put("face_landmarks", facePicture.getLandmarks());
            request.getSession().setAttribute("map", map);*/
            // 将faceIds


            String[] faceIds = facePicture.getFaceIds().replace("[", "").replace("]","").replace(" ", "").split(",");
            ArrayList<String> faceNames = new ArrayList<>();
            for (String faceId : faceIds) {
                Label label = labelMapper.selectByPrimaryKey(Integer.valueOf(faceId));
                faceNames.add("\""+label.getLabelName()+"\"");
            }
            facePicture.setPicId(facePicture.getPicId().replace("\\", "/"));
            map.put("facePicture", facePicture);
            map.put("faceNamesList", faceNames);
            request.getSession().setAttribute("map", map);
            return  new Gson().toJson(map);
        }

        List face_encoding = new ArrayList();
        List face_name_id = new ArrayList();
        List<Face> faces = getFaceMapper().selectAllFaceEncoding();
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
            List faceNamesList = new ArrayList<>();
            String faceNum = null;

            if ((line = in.readLine()) != null) {
                faceNum = line;
            }else {
                System.out.println("未检测到人脸");
                return "未检测到人脸";
            }

            if ((line = in.readLine()) != null) {
                face_name_ids = line.replace(" ","").replace("[", "").replace("]", "").replace(",", " ").trim().split(" ");
                // 初始化 人脸标签库 得到人脸 id
                for (String name_id : face_name_ids) {
                    Integer labelId =Integer.valueOf(name_id);
                    Label label1 = labelMapper.selectByPrimaryKey(labelId);
                    String faceName = null;
                    if(label1 == null){
                        // 新的人脸 创建 label
                        faceName = "faceName_" + name_id;
                        Label label = new Label(faceName);
                        int insert = labelMapper.insert(label);
                        if(insert != 1){
                            System.out.println("失败--插入人脸到t_label");
                            return "失败--插入人脸到t_label";
                        }
                        labelId = label.getLabelid();

                    }else {
                        // 已存在的人脸 数量+1
                        label1.setTags(label1.getTags()+1);
                        int insert = labelMapper.updateByPrimaryKey(label1);
                        Picture picture = pictureMapper.selectByPrimaryKey(pId);
                        picture.setPlabel(picture.getPlabel() == null || picture.getPlabel().length()<=1?","+labelId+",":picture.getPlabel()+labelId+",");
                        // 1.更新 t_pic 表
                        // 不存在标签 向数据库中插入该标签
                        int updatePic = pictureMapper.updateByPrimaryKeySelective(picture);
                        if(insert != 1 || updatePic != 1){
                            System.out.println("失败--插入人脸到t_label");
                            return "失败--插入人脸到t_label";
                        }
                        faceName = label1.getLabelName();
                    }
                    face_name_ids_List.add(labelId);
                    faceNamesList.add(faceName);
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
                faceMapper.insert(new Face(face_name_ids_List.get(i), imgPath, (String) face_encodings.get(i)));
            }

            // 2.插入到 t_face_pic
            FacePictureWithBLOBs facePicture2 = new FacePictureWithBLOBs(imgPath, Integer.valueOf(faceNum), face_name_ids_List.toString(), face_locations, face_landmarks);

            int insert = facePictureMapper.insert(facePicture2);
            if(insert != 1){
                System.out.println("失败....插入到 t_face_pic");
            }else {
                System.out.println("成功....插入到 t_face_pic");
            }
            facePicture2.setPicId(facePicture2.getPicId().replace("\\", "/"));
            map.put("facePicture", facePicture2);
            map.put("faceNamesList", faceNamesList);


        } catch (IOException e) {
            e.printStackTrace();
        }
        request.getSession().setAttribute("map", map);

        return  new Gson().toJson(map);
    }





    @Test
    public void T(){
       // init();

    }
    @RequestMapping("/init")
    public void init(){
        String imgAbsPath= "D:\\MyJava\\mylifeImg\\pythonModule\\face\\d\\9.jpg";
        FacePictureWithBLOBs facePicture = getFacePictureMapper().selectByPrimaryKey(imgAbsPath);
        if(facePicture != null){
            System.out.println("该照片已进行过人脸检测");
            System.out.println(facePicture);
            return;
        }
        String pyAbsFilePath = "D:\\MyJava\\mylifeImg\\pythonModule\\python\\init.py";
        init(pyAbsFilePath, imgAbsPath);
    }
//    用一张照片初始化数据库
    public void init(String pyAbsFilePath,String imgAbsPath){
        try {
            String[] args = new String[] { "python",pyAbsFilePath ,imgAbsPath};
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
                faceNum = line;
            }
            if ((line = in.readLine()) != null) {

                face_name_ids = line.replace(" ","").replace("[", "").replace("]", "").replace(",", " ").trim().split(" ");
                // 初始化 人脸标签库 得到人脸 id
                for (String name_id : face_name_ids) {
                    Label label = new Label("faceName_" + name_id);
                    int insert = getLabelMapper().insert(label);
                    if(insert != 1){
                        System.out.println("初始化失败");
                        return;
                    }
                    face_name_ids_List.add(label.getLabelid());
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
                getFaceMapper().insert(new Face(face_name_ids_List.get(i), imgAbsPath, (String) face_encodings.get(i)));
            }

            // 2.初始化 t_face_pic
            FacePictureWithBLOBs facePicture = new FacePictureWithBLOBs(imgAbsPath, Integer.valueOf(faceNum), face_name_ids_List.toString(), face_locations, face_landmarks);

            int insert = getFacePictureMapper().insert(facePicture);
            if(insert != 1){
                System.out.println("初始化失败....");
            }else {
                System.out.println("初始化成功....");
            }

            in.close();
            proc.waitFor();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }


    public LabelMapper getLabelMapper(){
        ApplicationContext context = new ClassPathXmlApplicationContext("spring.xml");
        return context.getBean(LabelMapper.class);
    }
    public FaceMapper getFaceMapper(){
        ApplicationContext context = new ClassPathXmlApplicationContext("spring.xml");
        return context.getBean(FaceMapper.class);
    }
    public FacePictureMapper getFacePictureMapper(){
        ApplicationContext context = new ClassPathXmlApplicationContext("spring.xml");
        return context.getBean(FacePictureMapper.class);
    }
}
