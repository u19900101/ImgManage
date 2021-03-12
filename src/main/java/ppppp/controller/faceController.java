package ppppp.controller;

import com.google.gson.Gson;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

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
    @ResponseBody
    @RequestMapping("/getFace")
    public String getFace(HttpServletRequest request){
        String imgpath = "D:\\MyJava\\mylifeImg\\pythonModule\\face\\6.jpg";
        String landmarkpath = "D:\\MyJava\\mylifeImg\\pythonModule\\python\\shape_predictor_68_face_landmarks.dat";
        HashMap map = new HashMap();
        try {
            String pyFilePath = "D:\\MyJava\\mylifeImg\\pythonModule\\python\\myDlib.py";
            String[] args = new String[] { "python",pyFilePath ,imgpath,landmarkpath};
            Process proc = Runtime.getRuntime().exec(args);// 执行py文件

            BufferedReader in = new BufferedReader(new InputStreamReader(proc.getInputStream()));
            String line = null;

            line = in.readLine();
            if(line != null){
                map.put("faceNum", Integer.valueOf(line));
                line = in.readLine();
            }

            if(line != null){
                // map.put("rects", line.replaceAll("\\s+", " ").trim().replaceAll(" ", ","));
                map.put("rects", line.trim().replaceAll(" ", ""));
                line = in.readLine();
            }

            if(line != null){
                // map.put("points", line.replaceAll("\\s+", " ").trim().replaceAll(" ", ","));
                map.put("points", line.trim().replaceAll(" ", ""));
            }
            in.close();
            proc.waitFor();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        request.getSession().setAttribute("map", map);
        return  new Gson().toJson(map);
    }


    @ResponseBody
    @RequestMapping("/getFaceData")
    public String getFaceData(){
        String s = "  [[[294 110]  [294 117]  [295 124]] [[294 110]  [294 117]  [295 124]]]";
        String regEx="[\\D]+";
        String[] cs = s.replaceAll(regEx, " ").trim().split(" ");

        // 每4个一组装进数组中
        int [][][] point = new int[cs.length/3/2][3][2];

        for (int i = 0; i < point.length;i++ ) {

            for (int j = 0; j < point[0].length; j++) {
                point[i][j][0] = Integer.valueOf(cs[i*point[0].length*point[0][0].length+j*2]);
                point[i][j][1] = Integer.valueOf(cs[i*point[0].length*point[0][0].length+j*2+1]);
            }
        }
        System.out.println( new Gson().toJson(point));
        return  new Gson().toJson(point);
    }


}
