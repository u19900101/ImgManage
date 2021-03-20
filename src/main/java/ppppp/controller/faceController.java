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
import ppppp.bean.FacePictureWithBLOBs;
import ppppp.bean.Label;
import ppppp.bean.Picture;
import ppppp.dao.FacePictureMapper;
import ppppp.dao.LabelMapper;
import ppppp.dao.PictureMapper;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;

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
    FacePictureMapper facePictureMapper;

    @RequestMapping(value = "/detectAllPicFace",method = RequestMethod.POST)
    public void detectAllPicFace(){
        ArrayList<Picture> pictureArrayList = pictureMapper.selectAllPic();
        for (Picture picture : pictureArrayList) {
            // getFaceMethod(picture.getPath(),picture.getPid());
        }
    }




    @ResponseBody
    @RequestMapping(value = "/getFace",method = RequestMethod.POST)
    public String getFace(String imgPath,String pId,HttpServletRequest request){
        // 直接从数据库查询结果返回
        HashMap map = getFaceMethod2(imgPath,pId);
        // request.getSession().setAttribute("map", map);
        return  new Gson().toJson(map);
    }

    @Test
    public void T__(){
        String pid = "0110010001000001000001000101111100101000111011001010100100000000";
        String imgPath = "";
        HashMap map = getFaceMethod2(imgPath,pid);
    }
    public HashMap getFaceMethod2(String imgPath,String pId){
        HashMap map = new HashMap();

        ArrayList<String> faceNamesList = new ArrayList<>();
        ArrayList<String> face_pathsList = new ArrayList<>();
        FacePictureWithBLOBs facePicture =  getFacePictureMapper().selectByPrimaryKey(pId);
        //该照片已进行过人脸检测 直接查询结果进行封装
        if(facePicture != null){
            System.out.println("该照片已进行过人脸检测");
            if(facePicture.getFaceIds() == null){
                map.put("faceNum", 0);
                return map;
            }
            String[] faceIds = facePicture.getFaceIds().replace("[", "").replace("]","").replace(" ", "").split(",");
            String[] face_paths = facePicture.getFacePaths().replace("[", "").replace("]","").replace(",", " ").trim().split(" ");
            for (int i = 0; i < faceIds.length; i++) {
                Label label = getLabelMapper().selectByPrimaryKey(Integer.valueOf(faceIds[i]));
                faceNamesList.add(label.getLabelName());
                face_pathsList.add(face_paths[i]);
            }

        }
        map.put("faceNamesList", faceNamesList);
        map.put("faceNum", facePicture.getFaceNum());
        map.put("face_locations", facePicture.getLocations());
        map.put("face_landmarks", facePicture.getLandmarks());

        map.put("face_paths", face_pathsList);
        map.put("srcImgPath", imgPath.replace("\\", "/"));
        return map;
    }

   /* public HashMap getFaceMethod(String imgPath, String pId){
        HashMap map = new HashMap();
        // 查看当前照片是否已经经过检测（判断图片路径）
        // String imgAbsPath= "D:\\MyJava\\mylifeImg\\pythonModule\\face\\d\\9.jpg";
        String imgAbsPath =  baseDir+imgPath;
        FacePictureWithBLOBs facePicture = new FacePictureWithBLOBs();
        ArrayList<String> faceNamesList = new ArrayList<>();
        facePicture = getFacePictureMapper().selectByPrimaryKey(imgPath);
        //该照片已进行过人脸检测 直接查询结果进行封装
        if(facePicture != null){
            System.out.println("该照片已进行过人脸检测");
            if(facePicture.getFaceIds() == null){
                map.put("faceNum", 0);
                return map;
            }
            String[] faceIds = facePicture.getFaceIds().replace("[", "").replace("]","").replace(" ", "").split(",");
            for (String faceId : faceIds) {
                Label label = labelMapper.selectByPrimaryKey(Integer.valueOf(faceId));
                faceNamesList.add(label.getLabelName());
            }
        }else {
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

                String faceNum = null;

                if ((line = in.readLine()) != null) {
                    if(Integer.valueOf(line) == 0){
                        System.out.println("未检测到人脸");
                        // 2.插入到 t_face_pic
                        FacePictureWithBLOBs facePicture2 = new FacePictureWithBLOBs(imgPath);

                        int insert = facePictureMapper.insert(facePicture2);
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
                        Label label1 = labelMapper.selectByPrimaryKey(labelId);
                        String faceName = null;
                        int insert = 0;
                        if(label1 == null){
                            // 新的人脸 创建 label
                            faceName = "faceName_" + name_id;
                            Label label = new Label(faceName);
                            insert = labelMapper.insert(label);
                            if(insert != 1){
                                System.out.println("失败--插入人脸到t_label");
                                map.put("msg", "失败--插入人脸到t_label");
                                return map;
                            }
                            labelId = label.getLabelid();

                        }else {
                            // 已存在的人脸 数量+1
                            label1.setTags(label1.getTags()+1);
                            insert = labelMapper.updateByPrimaryKey(label1);

                            faceName = label1.getLabelName();
                        }
                        face_name_ids_List.add(labelId);
                        faceNamesList.add(faceName);
                        Picture picture = pictureMapper.selectByPrimaryKey(pId);
                        picture.setPlabel(picture.getPlabel() == null || picture.getPlabel().length()<=1?","+labelId+",":picture.getPlabel()+labelId+",");
                        // 1.更新 t_pic 表
                        // 不存在标签 向数据库中插入该标签
                        int updatePic = pictureMapper.updateByPrimaryKeySelective(picture);
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
                    faceMapper.insert(new Face(face_name_ids_List.get(i), imgPath, (String) face_encodings.get(i)));
                }

                // 2.插入到 t_face_pic
                facePicture = new FacePictureWithBLOBs(imgPath, Integer.valueOf(faceNum), face_name_ids_List.toString(), face_locations, face_landmarks);

                int insert = facePictureMapper.insert(facePicture);
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
    }*/


    @Test
    public void T(){
       // init();

    }
    /*@RequestMapping("/init")
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
    }*/
//    用一张照片初始化数据库
   /* public void init(String pyAbsFilePath,String imgAbsPath){
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
    }*/



    public LabelMapper getLabelMapper(){
        ApplicationContext context = new ClassPathXmlApplicationContext("spring.xml");
        return context.getBean(LabelMapper.class);
    }

    public FacePictureMapper getFacePictureMapper(){
        ApplicationContext context = new ClassPathXmlApplicationContext("spring.xml");
        return context.getBean(FacePictureMapper.class);
    }
}
