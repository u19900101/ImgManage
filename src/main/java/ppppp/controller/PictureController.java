package ppppp.controller;

import com.drew.imaging.ImageProcessingException;
import com.google.gson.Gson;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import ppppp.bean.Picture;
import ppppp.bean.PictureExample;
import ppppp.dao.PictureMapper;
import ppppp.service.PictureService;

import java.io.File;

import java.io.IOException;
import java.text.ParseException;
import java.time.LocalDateTime;
import java.util.*;

import static ppppp.service.PictureService.*;

/**
 * @author lppppp
 * @create 2021-02-01 10:24
 */
@Controller
@RequestMapping("/picture")
public class PictureController {
    static public final double IMAGE_SIMILARITY = 0.95;
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
    static String imgpath = "D:\\MyJava\\mylifeImg\\src\\main\\webapp\\img\\";
    @RequestMapping(value = "/upload",method = RequestMethod.POST)
    public String up(@RequestParam(value = "img",required = false) MultipartFile multipartFile,
                     Model model) throws ParseException, IOException, ImageProcessingException {
        System.out.println(multipartFile.getOriginalFilename());

        File temp = new File("D:\\Temp\\"+multipartFile.getOriginalFilename());
        multipartFile.transferTo(temp);

        HashMap<String, String> imgInfo = getImgInfo(temp);

        String create_time = imgInfo.get("create_time");
        String destDir;
        // 将照片移入日期类文件夹
        //照片包含时间信息的 移入照片创建的日期文件夹
        if(create_time!=null){
            // 创建文件夹
            File file = new File(imgpath+create_time.split(" ")[0].replace("-","\\"));
            if(!file.exists() || !file.isDirectory()) {
                file.mkdirs();
            }
            destDir = imgpath+create_time.split(" ")[0].replace("-","\\");
        }
        //照片不包含时间信息的 移入导入时间的文件夹
        else {
            destDir = imgpath+LocalDateTime.now().toString().split("T")[0].replace("-","\\");
        }

        // 将上传的文件保存
        // 保存之前先进行去重检查
            //1.检查是否存在同名的文件
            // 2.若同名，在检查两个文件大小和时间信息是否一致

        move_file(temp.getAbsolutePath(),destDir);
        System.out.println(multipartFile.getSize());

        // 完成上传后 将照片信息写入数据库中
        /*try {
            // 按上传的日期做文件夹名称

            multipartFile.transferTo(new File("D:\\fileupload\\"+multipartFile.getOriginalFilename()));
            model.addAttribute("msg", "文件上传成功鸟！！！");
        } catch (IOException e) {
            model.addAttribute("msg", "文件上传失败鸟！！！"+e.toString());
        }*/
        return "redirect:/demo.jsp";
    }

    // 照片去重
    @Test
    public void T_get_dir_file() throws ParseException, IOException, ImageProcessingException {
        String destDir = "D:\\MyJava\\mylifeImg\\src\\main\\webapp\\img\\";
        File file = new File(destDir);
        // File srcFile = new File("D:\\MyJava\\mylifeImg\\src\\main\\webapp\\2020\\10\\06\\0E4A2352.jpg");
        File srcFile = new File("C:\\Users\\Administrator\\Desktop\\中文.jpg");
        String srcFileName = srcFile.getName();

        //在整个数据库中进行 照片去重检查
        ArrayList<String> stringList = new ArrayList<>();
        getallpath(destDir,stringList);
        boolean exist = false;
        //判断图片在数据库中是否存在相似的照片
        long l = System.currentTimeMillis();
        int count = 0;
        for (String s : stringList) {
            //1. 比较两个文件的大小
            File fileExist = new File(s);
            // long fileExist_length = fileExist.length();
            // long srcFile_length = srcFile.length();
           /* 此种判断可靠性不强.*/
            // if(fileExist_length==srcFile_length){
            //     System.out.println("大小相等");
            //     HashMap<String, String> srcFile_imgInfo = getImgInfo(srcFile);
            //     HashMap<String, String> fileExist_imgInfo = getImgInfo(fileExist);
            //     // 2.尺寸
            //     if(srcFile_imgInfo.get("width").equalsIgnoreCase(fileExist_imgInfo.get("width"))&&
            //             srcFile_imgInfo.get("height").equalsIgnoreCase(fileExist_imgInfo.get("height"))){
            //         System.out.println("尺寸相等");
            //         if(srcFile_imgInfo.get("create_time")!=null&&fileExist_imgInfo.get("create_time")!=null){
            //
            //             if(srcFile_imgInfo.get("create_time").equalsIgnoreCase(fileExist_imgInfo.get("create_time"))){
            //                 System.out.println("创建日期相等，照片相同鸟....");
            //                 exist = true;
            //                 break;
            //             }
            //         }else {
            //             System.out.println("无创建日期，判定为图片相同");
            //             exist = true;
            //             break;
            //         }
            //     }else {
            //         continue;
            //     }
            //
            // }else {
            //     continue;
            // }
            // 照片的 大小、尺寸、创建日期 都不相同，则判断  是否重名
            // 只对图片文件进行判断
            String fileType = s.substring(s.indexOf(".")+1);
            if(isImgType(fileType)){
                double imageSimilar = pictureService.getImageSimilar(fileExist.getAbsolutePath(), srcFile.getAbsolutePath());
                System.out.println("图片 ："+s+"与原图的相似度为： "+imageSimilar);
                count++;
                if(imageSimilar>IMAGE_SIMILARITY){
                    exist = true;
                    break;
                }
            }
        }
        //存在
        if(exist){
            System.out.println("存在相同照片.....");
        }
        // 不存在，按照片信息建立文件夹上传
        else {
            createImgFile(srcFile);
        }

        System.out.println(("耗时："+(System.currentTimeMillis()-l)/1000)+" s 共检测照片 "+count+" 张");
    }

    public static void createImgFile(File img) throws ParseException, IOException, ImageProcessingException {
        HashMap<String, String> imgInfo = getImgInfo(img);

        String create_time = imgInfo.get("create_time");
        String destDir;
        // 将照片移入日期类文件夹
        //照片包含时间信息的 移入照片创建的日期文件夹
        if(create_time!=null){
            // 创建文件夹
            File file = new File(imgpath+create_time.split(" ")[0].replace("-","\\"));
            if(!file.exists() || !file.isDirectory()) {
                file.mkdirs();
            }
            destDir = imgpath+create_time.split(" ")[0].replace("-","\\");
        }
        //照片不包含时间信息的 移入导入时间的文件夹
        else {
            destDir = imgpath+LocalDateTime.now().toString().split("T")[0].replace("-","\\");
        }
        move_file(img.getAbsolutePath(),destDir);
    }
    @Test
    public void T_get_img_len_hig() throws IOException, ImageProcessingException, ParseException {

        String picture = "D:\\MyJava\\mylifeImg\\src\\main\\webapp\\2020\\10\\06\\0E4A2352.jpg";
        HashMap<String, String> imgInfo = getImgInfo(new File(picture));
        System.out.println(imgInfo);
    }



    public static boolean move_file(String scrpath,String destDir){
        //判断当前文件夹下是否有重名的文件
        String[] list = new File(destDir).list();
        File file = new File(scrpath);
        String newFileName = file.getName();
        for (String s : list) {
            if(file.getName().equalsIgnoreCase(s)){
                newFileName = file.getName().split("\\.")[0]+"_."+file.getName().split("\\.")[1];
            }
        }
        boolean b = file.renameTo(new File(destDir+"\\" + newFileName));
        if(b){
            System.out.println("移动照片： "+scrpath+ "到文件夹 ："
            +destDir +" 下");
        }else {
            System.out.println("移动图片失败.....");
        }
        return b;
    }



    @RequestMapping("/setDesc")
    public String setDesc(){
        // 修改文件名  要解决重名问题
        PictureExample example = new PictureExample();
        List<Picture> pictures = mapper.selectByExample(example);
        for (Picture picture : pictures) {
            picture.setPdesc("");
            // 这种修改不了.....
            // mapper.updateByPrimaryKey(picture);
            int i = mapper.updateByPrimaryKeySelective(picture);
        }

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
