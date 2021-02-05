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
import ppppp.bean.MonthPicture;
import ppppp.bean.Picture;
import ppppp.bean.PictureExample;
import ppppp.dao.PictureMapper;
import ppppp.service.PictureService;

import java.awt.print.Book;
import java.io.File;
import java.util.*;

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

        // PageHelper.startPage(pageNum, 10);
        //紧跟着的第一条查询语句才有用  后面的无分页功能

        // 查询时间不为空的图片
        PictureExample pictureExample = new PictureExample();
        pictureExample.setOrderByClause("pcreatime");// 单月中照片升序显示  按月  照片逆序显示
        PictureExample.Criteria criteria = pictureExample.createCriteria();
        criteria.andPcreatimeIsNotNull();

        List<Picture> pictures = mapper.selectByExample(pictureExample);

        //将带时间的照片按月进行分组
        TreeMap<String,ArrayList<Picture>> map = new TreeMap<>(new Comparator<String>() {
            // 月份按照降序排列
            @Override
            public int compare(String o1, String o2) {
                return -o1.compareTo(o2);
            }
        });
        for (Picture picture : pictures) {
            String month = picture.getPcreatime().substring(0, 7);
            if(!map.containsKey(month)){
                ArrayList<Picture> pictureArrayList = new ArrayList<>();
                pictureArrayList.add(picture);
                map.put(month,pictureArrayList);
            }else {
                ArrayList<Picture> pictureArrayList = map.get(month);
                pictureArrayList.add(picture);
            }
        }

        //将map 写进 MonthPic
        model.addAttribute("info", map);
        // PageInfo<Picture> info = new PageInfo<>(pictures, 5);
        // // 带上当前的权限 路径  以便分页 区分跳转前缀
        // model.addAttribute("url", "picture/page?");
        return "picture";
    }
    //修改图片信息
    @RequestMapping("/update")
    public String updateInfo(Picture picture,String pictype){
        // 修改文件名  要解决重名问题
        picture.setPname(picture.getPname()+pictype);
        int i = mapper.updateByPrimaryKeySelective(picture);
        System.out.println(i);
        return "redirect:/picture/page";
    }

    @RequestMapping("/before_edit_picture")
    public String before_edit_picture(Integer pid,Model model){
        Picture picture = mapper.selectByPrimaryKey(pid);

        //不带后缀名显示
        String[] split = picture.getPname().split("\\.");
        picture.setPname(split[0]);
        model.addAttribute("picture",picture);
        model.addAttribute("type","."+split[1]);
        return "forward:/pages/edit_picture.jsp";
    }

    // 实时验证是否重名
    @ResponseBody
    @RequestMapping(value = "/ajaxexistPname",method = RequestMethod.POST)
    public String ajaxexistPname(String pname,String picpath,String pictype){
        // 修改本地文件名  要解决重名问题

        //1.查看是否 存在同名的pname，不存在则可用，存在 则查看path的上一层文件是否同名
        PictureExample pictureExample = new PictureExample();
        PictureExample.Criteria criteria = pictureExample.createCriteria();
        criteria.andPnameEqualTo(pname+pictype);
        List<Picture> pictures = mapper.selectByExample(pictureExample);
        HashMap<String,Object> map = new HashMap<>();


        if(pictures.size()>0){
            // 存在同名的pname  查看path的父路径是否同名
            //获取修改图片的父路径
            int index = picpath.lastIndexOf("\\");
            String o_parent = picpath.substring(0, index);
            for (Picture picture : pictures) {
                //获取父路径
                String parentpath = picture.getPath().substring(0, picture.getPath().lastIndexOf("\\"));
                if(o_parent.equalsIgnoreCase(parentpath)){
                    map.put("existpname",true);
                    break;
                }
            }
        }else {
            map.put("existpname",false);
        }

        return new Gson().toJson(map);
    }

    @RequestMapping("/init")
    public String insertInfo(){
        // 遍历文件夹下所有文件路径
        String dir = "D:\\MyJava\\mylifeImg\\src\\main\\webapp\\img\\";
        List<String> stringList = new ArrayList<>();
        getallpath(dir,stringList);
        for (String s : stringList) {
            try {
                pictureService.insertInfo(s);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return "success";
    }

    @Test
    public void T_(){
        String dir = "D:\\MyJava\\mylifeImg\\src\\main\\webapp\\img";
        List<String> stringList = new ArrayList<>();
        getallpath(dir,stringList);
        for (String s : stringList) {
            try {
                String img = s.substring(s.indexOf("img"));

                System.out.println(img);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    @Test
    public void T(){
        String dir = "D:\\MyJava\\mylifeImg\\src\\main\\webapp\\img\\";
        List<String> stringList = new ArrayList<>();
        getallpath(dir, stringList);
        for (String s : stringList) {
            if(s.contains(" ")){
                File file = new File(s);
                file.renameTo(new File(s.replace(" ", "_")));
            }
        }

    }

    public static void getallpath(String dir,List<String> stringList){
        File dirfile = new File(dir);
        if(dirfile.isDirectory()){
            String[] list = dirfile.list();
            for (String s : list) {
                getallpath(dirfile.getAbsolutePath() + "\\" + s,stringList);
            }
        }else {
            // System.out.println(dir);
            stringList.add(dir);
        }
    }
}
