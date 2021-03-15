package ppppp.controller;

import com.google.gson.Gson;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import ppppp.bean.Face;
import ppppp.bean.FacePictureWithBLOBs;
import ppppp.bean.Label;
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


    @ResponseBody
    @RequestMapping("/getFace")
    public String getFace(String imgPath,HttpServletRequest request){
        HashMap map = new HashMap();

        ArrayList<HashMap> hashMaps = null;
        List face_encoding = new ArrayList();
        List face_name_id = new ArrayList();
        for (HashMap hashMap : hashMaps) {
            face_encoding.add(hashMap.get("face_encoding"));
            face_name_id.add(hashMap.get("face_name_id"));
        }

        String known_face_encodings = face_encoding.toString();
        String known_face_ids = face_name_id.toString();
        System.out.println(known_face_encodings);
        System.out.println(known_face_ids);
        try {
            String pyFilePath = "D:\\MyJava\\mylifeImg\\pythonModule\\python\\getFaceInfo.py";
            String imgpath =  baseDir+imgPath;

            String[] args = new String[]{"python", pyFilePath, imgpath,known_face_encodings,known_face_ids};
            Process proc = Runtime.getRuntime().exec(args);// 执行py文件
            BufferedReader in = new BufferedReader(new InputStreamReader(proc.getInputStream()));
            String line = null;
            //     print(faceDic['faceNum'])
            //     print([a for a in  faceDic['face_locations']])
            //     print(faceDic['face_ids'])
            //     print([a for a in  faceDic['face_landmarks']])
            //     print([a for a in  faceDic['face_encodings']])
            if ((line = in.readLine()) != null) {
                map.put("faceNum", line);
                System.out.println(line);
            }
            if ((line = in.readLine()) != null) {
                map.put("face_locations", line);
                System.out.println(line);
            }
            if ((line = in.readLine()) != null) {
                //将 face_ids 转化为 name
                map.put("face_ids", line);
                System.out.println(line);
            }
            if ((line = in.readLine()) != null) {
                map.put("face_landmarks", line);
                System.out.println(line);
            }
            if ((line = in.readLine()) != null) {
                map.put("face_encodings", line);
                System.out.println(line);
            }

        } catch (IOException e) {
            e.printStackTrace();
        }
        request.getSession().setAttribute("map", map);
        return  new Gson().toJson(map);
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


    @Test
    public void T(){
       init();
    }
    // @RequestMapping("/init")
    public void init(){
        String imgAbsPath= "D:\\MyJava\\mylifeImg\\pythonModule\\face\\d\\9.jpg";
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
                faceNum = line;
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
}
