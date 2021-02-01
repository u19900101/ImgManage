package ppppp.controller;

import com.drew.imaging.ImageProcessingException;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import ppppp.bean.Picture;
import ppppp.bean.PictureExample;
import ppppp.dao.PictureMapper;
import ppppp.service.PictureService;

import java.io.File;
import java.util.List;

/**
 * @author lppppp
 * @create 2021-02-01 10:24
 */
@Controller
@RequestMapping("/picture")
public class PictureController {
    @Autowired
    PictureService pictureService;

    @Autowired
    PictureMapper mapper;

    // 查询数据库中的图片信息  在页面中显示
    @RequestMapping("/page")
    public String page(Model model){
        //
        List<Picture> pictures = mapper.selectByExample(new PictureExample());
        model.addAttribute("picture", pictures.get(0));

        return "picture";
    }

    //修改图片信息
    @RequestMapping("/update")
    public String updateInfo(Picture picture){
        // 修改本地文件名  要解决重名问题
        File file = new File(picture.getPath());
        String newFilepath = file.getParentFile() + "\\" + picture.getPname();
        boolean b = file.renameTo(new File(newFilepath));
        System.out.println(b);
        picture.setPath(newFilepath);
        int i = mapper.updateByPrimaryKeySelective(picture);
        System.out.println(i);
        return "redirect:/picture/page";
    }

    @Test
    public void T(){
        File file = new File("2.jpg");
        String parent = file.getParent();
        System.out.println(parent);
        boolean b = file.renameTo(new File("3.jpg"));
        System.out.println(b);
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
