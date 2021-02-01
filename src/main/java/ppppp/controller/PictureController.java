package ppppp.controller;

import com.drew.imaging.ImageProcessingException;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import ppppp.service.PictureService;

import java.io.File;

/**
 * @author lppppp
 * @create 2021-02-01 10:24
 */
@Controller
@RequestMapping("/picture")
public class PictureController {
    @Autowired
    PictureService pictureService;

    //
    @RequestMapping("/page")
    public String page(){
        // 遍历文件夹下所有文件路径

        return "success";
    }
    @RequestMapping("/init")
    public String insertInfo(){
        // 遍历文件夹下所有文件路径
        String dir = "D:\\MyJava\\mylifeImg\\src\\main\\webapp\\static\\";
        File dirfile = new File(dir);
        String[] list = dirfile.list();
        for (String s : list) {
            String filepath = dir+s;
            try {
                pictureService.insertInfo(filepath);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return "success";
    }
}
