package ppppp.controller;

import com.drew.imaging.ImageProcessingException;
import com.google.gson.Gson;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import ppppp.bean.Picture;
import ppppp.bean.PictureExample;
import ppppp.dao.PictureMapper;
import ppppp.service.PictureService;
import ppppp.util.MyUtils;

import javax.servlet.http.HttpServletRequest;
import java.io.*;

import java.text.ParseException;
import java.util.*;

import static org.springframework.test.web.client.match.MockRestRequestMatchers.header;
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
    // 直接上传到的服务器路径
    public static String uploadimgDir = "D:\\MyJava\\mylifeImg\\target\\mylifeImg-1.0-SNAPSHOT\\img";

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

    // 图片上传
    @RequestMapping(value = "/upload",method = RequestMethod.POST)
    public String uploadImg(@RequestParam(value = "img",required = false) MultipartFile multipartFile,
                      HttpServletRequest request) throws ParseException, IOException, ImageProcessingException {
        String path = request.getSession().getServletContext().getRealPath("temp");

        File temp = new File(path,multipartFile.getOriginalFilename());
        // 若父文件夹不存在则创建
        if(!temp.getParentFile().exists() || !temp.getParentFile().isDirectory()){
            temp.getParentFile().mkdirs();
        }
        // 将上传的文件写入到 到文件夹
        multipartFile.transferTo(temp);
        String  descDir= request.getSession().getServletContext().getRealPath("img");
        HashMap<String, Object> map = pictureService.checkAndCreateImg(descDir, temp);

        // 若成功  金色字体
        // 若失败  红色字体
        String s = multipartFile.getOriginalFilename();

        pictureService.setMapInfo(s,map,temp);

        return "forward:/demo.jsp";
    }

    @RequestMapping("/uploadDir")
    public String uploadDir(HttpServletRequest request,
            @RequestParam(value = "imgList",required = false) MultipartFile[] multipartFiles) throws IOException, ImageProcessingException, ParseException   {
        // 遍历文件夹下所有文件路径
        // 若父文件夹不存在则创建
        MyUtils.creatDir(uploadimgDir);
        String path = request.getSession().getServletContext().getRealPath("temp");
        MyUtils.creatDir(path);
        // 将所有检测出 重复的照片 路径保存到 list中
        ArrayList<HashMap<String, Object>> hashMaps = new ArrayList<>();
        for (MultipartFile multipartFile : multipartFiles) {
            // 先只处理图片文件
            if(!isImgType(multipartFile.getOriginalFilename())){
                System.out.println(multipartFile.getOriginalFilename());
                continue;
            }
            File temp = new File(path,multipartFile.getOriginalFilename());
            // 将上传的文件写入到 到文件夹
            multipartFile.transferTo(temp);

            HashMap<String, Object> map = pictureService.checkAndCreateImg(uploadimgDir, temp);

            // 若成功  金色字体
            // 若失败  红色字体
            String s = multipartFile.getOriginalFilename();
            pictureService.setMapInfo(s, map, temp);
            hashMaps.add(map);

        }
        // 防止页面重复提交
        request.getSession().setAttribute("failedList", hashMaps);
        return "redirect:/demo.jsp";
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
    public String before_edit_picture(String pid,Model model){
        Picture picture = mapper.selectByPrimaryKey(pid);

        //不带后缀名显示
        String[] split = picture.getPname().split("\\.");
        picture.setPname(split[0]);
        model.addAttribute("picture",picture);
        model.addAttribute("type","."+split[1]);
        return "forward:/pages/edit_picture.jsp";
    }


    // 实时监测文件是否重名
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
    
    // 对相同单个照片进行处理
    @ResponseBody
    @RequestMapping(value = "/ajaxHandleSamePic",method = RequestMethod.POST)
    public String ajaxHandleSamePic(String handleMethod,String uploadImgPath,String existImgPath,HttpServletRequest req) throws ParseException, ImageProcessingException, IOException {

        HashMap<String,Object> map = new HashMap<>();

        String absUploadImgPath = uploadimgDir.replace("img", "")+uploadImgPath;
        String absExistImgPath = uploadimgDir.replace("img", "")+existImgPath;
        String successMsg = "";
        boolean isSucceed = false;
        switch (handleMethod){
            case "saveBoth":
                System.out.println("saveBoth");
                String destDir = absExistImgPath.substring(0,absExistImgPath.lastIndexOf("\\"));
                String move_absUploadImgPath = MyUtils.move_file(absUploadImgPath, destDir);
                int i = pictureService.insertPicture(move_absUploadImgPath);
                successMsg = "成功保存两张照片";
                isSucceed = move_absUploadImgPath!=null && i==1;
                break;
            case "deleteBoth":
                System.out.println("deleteBoth");
                isSucceed = MyUtils.deleteFile(absUploadImgPath, absExistImgPath);
                // 将数据库中的 保存文件也删除
                i = pictureService.deletePicture(mapper,absExistImgPath.substring(absExistImgPath.indexOf("img")));
                isSucceed = isSucceed && i==1;
                successMsg = "成功删除两张照片";
                break;
            case "saveExistOnly":
                System.out.println("saveExistOnly");
                // 不操作数据库
                isSucceed = MyUtils.deleteFile(absUploadImgPath);
                successMsg = "成功保存已存在的照片";
                break;
            case "saveUploadOnly":
                System.out.println("saveUploadOnly");
                // 先删除 存在的文件 和 数据库中的内容
                isSucceed = MyUtils.deleteFile(absExistImgPath);
                i = pictureService.deletePicture(mapper,absExistImgPath.substring(absExistImgPath.indexOf("img")));
                // 将 上传的文件写入数据库中
                // 1.移动数据到img文件夹下  2.写入到数据库中
                boolean moveSuccess = pictureService.moveImgToDirByAbsPathAndInsert(absUploadImgPath);

                isSucceed = isSucceed && i==1 && moveSuccess;
                successMsg = "成功保存上传的照片";
                break;
            default:
                map.put("status", "fail");
        }
        pictureService.insertMsg(map, isSucceed,successMsg);

        // 单张照片操作完毕后 要将 session中的list值进行更新,删除 list中的 uploadImgPath 和 existImgPath
        ArrayList<HashMap<String, Object>> failedList = (ArrayList<HashMap<String, Object>>) req.getSession().getAttribute("failedList");
        failedList.removeIf(
                mapp -> mapp.get("existImgPath").equals(existImgPath)
        );
        return new Gson().toJson(map);
    }


    // 批量处理
    @ResponseBody
    @RequestMapping(value = "/ajaxHandleSamePicAll",method = RequestMethod.POST)
    public String ajaxHandleSamePicAll(String handleMethod,HttpServletRequest req){

        HashMap map = new HashMap();
        ArrayList<HashMap<String, Object>> failedList = (ArrayList<HashMap<String, Object>>) req.getSession().getAttribute("failedList");

        ArrayList<String> errorInfoList = new ArrayList<>();
        String successMsg = "";
        switch (handleMethod){
            case "saveBoth":
                for (HashMap<String, Object> hashMap : failedList) {
                    Object uploadImgPath = hashMap.get("uploadImgPath");
                    Object existImgPath = hashMap.get("existImgPath");
                    String absUploadImgPath = uploadimgDir.replace("img", "")+uploadImgPath;
                    String absExistImgPath = uploadimgDir.replace("img", "")+existImgPath;
                    String destDir = absExistImgPath.substring(0,absExistImgPath.lastIndexOf("\\"));
                    String move_file = MyUtils.move_file(absUploadImgPath, destDir);
                    if(move_file==null){
                        errorInfoList.add((String) uploadImgPath);
                    }
                }
                successMsg = "成功保存了本地和上传所有照片";
                break;
            case "deleteBoth":
                for (HashMap<String, Object> hashMap : failedList) {
                    Object uploadImgPath = hashMap.get("uploadImgPath");
                    Object existImgPath = hashMap.get("existImgPath");
                    String absUploadImgPath = uploadimgDir.replace("img", "")+uploadImgPath;
                    String absExistImgPath = uploadimgDir.replace("img", "")+existImgPath;
                    boolean isDelete = MyUtils.deleteFile(absExistImgPath,absUploadImgPath);
                    if(isDelete==false){
                        // 随便写一个吧
                        errorInfoList.add((String) uploadImgPath);
                    }
                }
                successMsg = "成功删除了本地和上传的所有照片";
                break;
            case "saveExistOnly":
                for (HashMap<String, Object> hashMap : failedList) {
                    Object uploadImgPath = hashMap.get("uploadImgPath");
                    String absUploadImgPath = uploadimgDir.replace("img", "")+uploadImgPath;
                    boolean isDelete = MyUtils.deleteFile(absUploadImgPath);
                    if(isDelete==false){
                        // 随便写一个吧
                        errorInfoList.add((String) uploadImgPath);
                    }
                }
                successMsg = "成功只保存了所有本地照片";
                break;
            case "saveUploadOnly":
                for (HashMap<String, Object> hashMap : failedList) {
                    Object existImgPath = hashMap.get("existImgPath");
                    String absExistImgPath = uploadimgDir.replace("img", "")+existImgPath;
                    boolean isDelete = MyUtils.deleteFile(absExistImgPath);
                    if(isDelete==false){
                        // 随便写一个吧
                        errorInfoList.add((String) absExistImgPath);
                    }
                }
                successMsg = "成功只保存所有上传照片";
                break;
            default:
                map.put("status", "fail");
        }
        pictureService.insertMsg(map,errorInfoList,successMsg);
        return new Gson().toJson(map);
    }

    // 可以改写成为  对文件夹进行上传
    @RequestMapping("/init")
    public String init(HttpServletRequest request){
        // 遍历文件夹下所有文件路径
        // 若父文件夹不存在则创建
        MyUtils.creatDir(uploadimgDir);
        String scrDir = "C:\\Users\\Administrator\\Desktop\\demo\\img";
        List<String> stringList = new ArrayList<>();
        MyUtils.getallpath(scrDir,stringList);
        if(stringList.size()>0){
            for (String s : stringList) {
                try {
                    File src = new File(s);
                    String copypath = request.getSession().getServletContext().getRealPath("temp")+"\\"+src.getName();
                    MyUtils.copyFileUsingFileStreams(s,copypath);
                    File temp = new File(copypath);
                    HashMap<String, Object> map = pictureService.checkAndCreateImg(uploadimgDir, temp);
                    boolean forward = pictureService.setMapInfo(s, map,temp);
                    // 只要一存在 检测出的照片 相似 就进行转发 显示到页面
                    if(forward){
                        request.getSession().setAttribute("failedList", map);
                        return "forward:/demo.jsp";
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        return "forward:/demo.jsp";
    }
}
