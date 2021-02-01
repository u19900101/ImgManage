package ppppp.controller;

import com.drew.imaging.ImageProcessingException;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.google.gson.Gson;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import ppppp.bean.Picture;
import ppppp.bean.PictureExample;
import ppppp.dao.PictureMapper;
import ppppp.service.PictureService;

import java.awt.print.Book;
import java.io.File;
import java.util.HashMap;
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
    public String page(Model model,
                       @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum){

        PageHelper.startPage(pageNum, 1);
        //紧跟着的第一条查询语句才有用  后面的无分页功能

        // 查询时间不为空的图片
        PictureExample pictureExample = new PictureExample();
        pictureExample.setOrderByClause("pcreatime DESC");
        PictureExample.Criteria criteria = pictureExample.createCriteria();
        criteria.andPcreatimeIsNotNull();

        List<Picture> pictures = mapper.selectByExample(pictureExample);
        PageInfo<Picture> info = new PageInfo<>(pictures, 5);
        model.addAttribute("info", info);

        // // 带上当前的权限 路径  以便分页 区分跳转前缀
        model.addAttribute("url", "picture/page?");
        System.out.println(info);
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

    // 实时验证是否重名
    @ResponseBody
    @RequestMapping(value = "/ajaxexistPname",method = RequestMethod.POST)
    public String ajaxexistPname(String pname,String picpath){
        // 修改本地文件名  要解决重名问题
        File file = new File(picpath);
        String newpath = file.getParentFile() + "\\" + pname;

        PictureExample pictureExample = new PictureExample();
        PictureExample.Criteria criteria = pictureExample.createCriteria();
        criteria.andPathEqualTo(newpath);
        List<Picture> pictures = mapper.selectByExample(pictureExample);

        HashMap<String,Object> map = new HashMap<>();
        map.put("existpname", pictures.size()>0?true:false);
        return new Gson().toJson(map);
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
