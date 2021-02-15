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
    public static String baseDir = "D:\\MyJava\\mylifeImg\\target\\mylifeImg-1.0-SNAPSHOT";
    public static String tempimgDir = "D:\\MyJava\\mylifeImg\\target\\mylifeImg-1.0-SNAPSHOT\\temp\\img";

    // 查询数据库中的图片信息  在页面中显示
    @RequestMapping("/page")
    public String page(HttpServletRequest req){

        if(req.getSession().getAttribute("monthsTreeMapListPic")!=null){
            return "picture";
        }
        //清空session
        req.getSession().invalidate();
        // 查询时间不为空的图片
        PictureExample pictureExample = new PictureExample();
        pictureExample.setOrderByClause("pcreatime");// 单月中照片升序显示  按月  照片逆序显示

        List<Picture> pictures = mapper.selectByExample(pictureExample);

        TreeMap<String,ArrayList<Picture>> map = pictureService.groupPictureByMonth(pictures);
        //将map 写进 MonthPic
        req.getSession().setAttribute("monthsTreeMapListPic", map);
        return "picture";
    }


    //修改图片信息
    @ResponseBody
    @RequestMapping("/ajaxUpdateInfo")
    public String ajaxUpdateInfo(String pname,String pictype,String picpath,String pdesc,HttpServletRequest req){
        // 修改文件名  要解决重名问题
        HashMap map = new HashMap();
        String status = "";
        String msg = "";
        Picture picture = mapper.selectByPrimaryKey(picpath);
        String originName = picture.getPname();
        String originDesc = picture.getPdesc();
        String newName = pname+pictype;
        String newPath =null;
        boolean  descChange= false;
        if(originDesc != null && pdesc !=null){
            descChange = originDesc.equals(pdesc);
        }
        if(originName.equals(newName)|| descChange){
            map.put("status",  "unchange");
            return new Gson().toJson(map);
        }
        picture.setPath(picpath);
        if(pname!=null){
            int i = 0;boolean rename =false;
            boolean isNameExist = existPname(picpath,newName);
            picture.setPname(pname+pictype);
            if(!isNameExist){
                // 修改本地照片的名称
                File file = new File(baseDir, picpath);
                rename = file.renameTo(new File(file.getParent()+"\\"+ newName));
                // 要改主键
                newPath = picpath.substring(0,picpath.lastIndexOf("\\"))+"\\"+newName;
                i = mapper.MyUpdateByPrimaryKey(newPath,picture);
            }
            if(1==i&& rename){
                status = "success";
                msg = "成功修改照片名称";
                map.put("newPath", newPath);

                //要将 monthsTreeMapListPic中相应的字段进行修改
                TreeMap<String,ArrayList<Picture>> monthsTreeMapListPic = (TreeMap<String, ArrayList<Picture>>) req.getSession().getAttribute("monthsTreeMapListPic");
                Set<String> strings = monthsTreeMapListPic.keySet();
                outterLoop: for (String key : strings) {
                    ArrayList<Picture> pictures = monthsTreeMapListPic.get(key);
                    for (Picture p  : pictures) {
                        if(p.getPath().equals(picpath)){
                            p.setPath(newPath);
                            break outterLoop;
                        }
                    }
                }
            }else {
                status = "fail";
                msg = "照片重名，修改名称失败";
            }
        }else {
            if(pdesc!=null){
                picture.setPdesc(pdesc);
            }
            if(mapper.updateByPrimaryKeySelective(picture)==1){
                status = "success";
                msg = "成功修改照片描述";
            }else {
                status = "fail";
                msg = "照片重名，修改照片描述失败";
            }
        }
        map.put("status", status);
        map.put("msg", msg);
        return new Gson().toJson(map);
    }


    @RequestMapping("/uploadDir")
    public String uploadDir(HttpServletRequest request,
            @RequestParam(value = "imgList",required = false) MultipartFile[] multipartFiles) throws IOException, ImageProcessingException, ParseException   {
        // 遍历文件夹下所有文件路径
        // 若父文件夹不存在则创建
        String path = request.getSession().getServletContext().getRealPath("temp//img");
        MyUtils.creatDir(path);
        // 将所有检测出 重复的照片 路径保存到 list中
        ArrayList<HashMap<String, Object>> successMapList = new ArrayList<>();
        ArrayList<HashMap<String, Object>> failedMapList = new ArrayList<>();
        for (MultipartFile multipartFile : multipartFiles) {
            // 先只处理图片文件
            if(!MyUtils.isImgType(multipartFile.getOriginalFilename())){
                System.out.println(multipartFile.getOriginalFilename());
                continue;
            }
            File uploadImgTemp = new File(path,multipartFile.getOriginalFilename());
            // 将上传的文件写入到 到文件夹
            multipartFile.transferTo(uploadImgTemp);
            // 此处的 信息可以简写
            pictureService.checkAndCreateImg(tempimgDir, uploadImgTemp,successMapList,failedMapList);

        }
        // 防止页面重复提交
        // 上传成功的照片 按月进行显示
        ArrayList<Picture> successPicturesList = new ArrayList<>();
        for (HashMap<String, Object> map : successMapList) {
            successPicturesList.add((Picture) map.get("uploadPicture"));
        }
        request.getSession().setAttribute("successPicturesList", successPicturesList);

        request.getSession().setAttribute("failedPicturesList", failedMapList);
        return "redirect:/picture/showUploadInfo?page=p2";
        // return "redirect:/demo.jsp";
    }
    // 批量处理
    @ResponseBody
    @RequestMapping(value = "/ajaxHandleSamePicAll",method = RequestMethod.POST)
    public String ajaxHandleSamePicAll(String handleMethod,HttpServletRequest req) throws ParseException, ImageProcessingException, IOException {

        HashMap map = new HashMap();
        ArrayList<HashMap<String, Object>> failedMapList = (ArrayList<HashMap<String, Object>>) req.getSession().getAttribute("failedPicturesList");
        ArrayList<Picture> successPicturesList = (ArrayList<Picture>) req.getSession().getAttribute("successPicturesList");

        ArrayList<String> errorInfoList = new ArrayList<>();
        ArrayList<Picture> picturesList = new ArrayList<>();
        String successMsg = "";
        int i = 0;
        switch (handleMethod){
            case "saveBoth":
                saveAllFailedPicture(failedMapList,errorInfoList,picturesList);
                saveAllPicture(successPicturesList,errorInfoList,picturesList);
                successMsg = "成功保存了本地和上传所有照片";
                break;
            case "deleteBoth":
                for (HashMap<String, Object> hashMap : failedMapList) {
                    String uploadImgPath = ((Picture)hashMap.get("uploadPicture")).getPath();
                    String existImgPath = ((Picture)hashMap.get("existPicture")).getPath();

                    String absUploadImgPath = baseDir+"\\"+uploadImgPath;
                    String absExistImgPath =baseDir+"\\"+existImgPath;
                    boolean isDelete = MyUtils.deleteFile(absExistImgPath,absUploadImgPath);
                    i = pictureService.deletePicture(mapper,existImgPath);
                    isDelete = isDelete && i==1;
                    if(isDelete==false){
                        // 随便写一个吧
                        errorInfoList.add(uploadImgPath);
                    }
                }
                deleteAllPicture(successPicturesList,errorInfoList);
                successMsg = "成功删除了本地和上传的所有照片";
                break;
            case "saveExistOnly":
                for (HashMap<String, Object> hashMap : failedMapList) {
                    String absUploadImgPath = baseDir+"\\"+ ((Picture)hashMap.get("uploadPicture")).getPath();
                    boolean isDelete = MyUtils.deleteFile(absUploadImgPath);
                    if(isDelete==false){
                        // 随便写一个吧
                        errorInfoList.add(absUploadImgPath);
                    }
                }
                deleteAllPicture(successPicturesList,errorInfoList);
                successMsg = "成功只保存了所有本地照片";
                break;
            case "saveUploadOnly":
                for (HashMap<String, Object> hashMap : failedMapList) {
                    String uploadImgPath = ((Picture)hashMap.get("uploadPicture")).getPath();
                    String existImgPath = ((Picture)hashMap.get("existPicture")).getPath();

                    String absUploadImgPath = baseDir+"\\"+uploadImgPath;
                    String absExistImgPath =baseDir+"\\"+existImgPath;

                    boolean isDelete = MyUtils.deleteFile(absExistImgPath);
                    i = pictureService.deletePicture(mapper,existImgPath);

                    boolean moveSuccess = pictureService.moveImgToDirByAbsPathAndInsert(absUploadImgPath);
                    isDelete = isDelete && i==1 &&moveSuccess;
                    if(isDelete==false){
                        // 随便写一个吧
                        errorInfoList.add(absExistImgPath);
                    }else {
                        Picture uploadPicture = (Picture) hashMap.get("uploadPicture");
                        String substring = uploadPicture.getPath().substring(uploadPicture.getPath().indexOf("img"));
                        uploadPicture.setPath(substring);
                        picturesList.add(uploadPicture);
                    }
                }

                saveAllPicture(successPicturesList,errorInfoList, picturesList);
                successMsg = "成功只保存所有上传照片";
                break;
            default:
                map.put("status", "fail");
        }
        MyUtils.insertMsg(map,errorInfoList,successMsg);
        // 清空session
        failedMapList.clear();
        successPicturesList.clear();
        req.getSession().setAttribute("successPicturesList", picturesList);
        if(handleMethod.equalsIgnoreCase("saveUploadOnly") || handleMethod.equalsIgnoreCase("saveBoth")){
            req.getSession().setAttribute("justUploadMsg", "本次上传预览");
        }
        return new Gson().toJson(map);
    }

    @RequestMapping("/showUploadInfo")
    public String showUploadInfo(Model model,HttpServletRequest req,String page){
        ArrayList<Picture> pictures = (ArrayList<Picture>) req.getSession().getAttribute("successPicturesList");
        TreeMap<String,ArrayList<Picture>> map = pictureService.groupPictureByMonth(pictures);
        //将map 写进 MonthPic
        model.addAttribute("monthsTreeMapListPic", map);
        // // return "p2";
        // return "picture";
        return page;
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


    @RequestMapping(value = "/before_edit_picture",method = RequestMethod.POST)
    public String before_edit_picture(String path,Model model){
        Picture picture = mapper.selectByPrimaryKey(path);

        //不带后缀名显示
        String[] split = picture.getPname().split("\\.");
        picture.setPname(split[0]);
        model.addAttribute("picture",picture);
        model.addAttribute("type","."+split[1]);
        return "forward:/pages/edit_picture.jsp";
    }


    // 实时监测文件是否重名

    public boolean existPname(String picpath,String newName){
        // 修改本地文件名  要解决重名问题
        //1.查看是否 存在同名的pname，不存在则可用，存在 则查看path的上一层文件是否同名
        PictureExample pictureExample = new PictureExample();
        PictureExample.Criteria criteria = pictureExample.createCriteria();
        criteria.andPnameEqualTo(newName);
        List<Picture> pictures = mapper.selectByExample(pictureExample);
        if(pictures.size()>0){
            // 存在同名的pname  查看path的父路径是否同名
            //获取修改图片的父路径
            int index = picpath.lastIndexOf("\\");
            String o_parent = picpath.substring(0, index);
            for (Picture picture : pictures) {
                //获取父路径
                String parentpath = picture.getPath().substring(0, picture.getPath().lastIndexOf("\\"));
                if(o_parent.equalsIgnoreCase(parentpath)){
                   return true;
                }
            }
        }
        return false;
    }
    
    // 对相同单个照片进行处理
    @ResponseBody
    @RequestMapping(value = "/ajaxHandleSamePic",method = RequestMethod.POST)
    public String ajaxHandleSamePic(String handleMethod,String uploadImgPath,String existImgPath,HttpServletRequest req) throws ParseException, ImageProcessingException, IOException {

        HashMap<String,Object> map = new HashMap<>();

        String absUploadImgPath = baseDir+"\\"+uploadImgPath;
        String absExistImgPath = baseDir+"\\"+existImgPath;
        String successMsg = "";
        boolean isSucceed = false;
        int i = 0;
        switch (handleMethod){
            case "saveBoth":
                System.out.println("saveBoth");
                successMsg = "成功保存两张照片";
                isSucceed = pictureService.moveImgToDirByAbsPathAndInsert(absUploadImgPath);
                break;
            case "deleteBoth":
                System.out.println("deleteBoth");
                isSucceed = MyUtils.deleteFile(absUploadImgPath, absExistImgPath);
                // 将数据库中的 保存文件也删除
                i = pictureService.deletePicture(mapper,existImgPath);
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
            case "saveSingle":
                System.out.println("saveSingle");
                // 将 上传的文件写入数据库中
                // 1.移动数据到img文件夹下  2.写入到数据库中
                isSucceed = pictureService.moveImgToDirByAbsPathAndInsert(absUploadImgPath);
                successMsg = "成功保存上传的照片";
                break;
            case "deleteSingle":
                System.out.println("deleteSingle");
                // 先删除 存在的文件 和 数据库中的内容
                isSucceed = MyUtils.deleteFile(absUploadImgPath);
                successMsg = "成功删除照片";
                break;
            default:
                map.put("status", "fail");
        }
        MyUtils.insertMsg(map, isSucceed,successMsg);

        // 单张照片操作完毕后 要将 session中的list值进行更新,删除 list中的 uploadImgPath 和 existImgPath
        ArrayList<HashMap<String, Object>> failedMapList = (ArrayList<HashMap<String, Object>>) req.getSession().getAttribute("failedPicturesList");
        ArrayList<Picture> successMapList = (ArrayList<Picture>) req.getSession().getAttribute("successPicturesList");

        failedMapList.removeIf(
                mapp -> ((Picture)mapp.get("uploadPicture")).getPath().equals(uploadImgPath)
        );
        successMapList.removeIf(
                mapp -> mapp.getPath().equals(uploadImgPath)
        );
        return new Gson().toJson(map);
    }

    // 对相同单个照片进行处理
    @ResponseBody
    @RequestMapping(value = "/ajaxDeletePic",method = RequestMethod.POST)
    public String ajaxDeletePic(String existImgPath,HttpServletRequest req) throws ParseException, ImageProcessingException, IOException {

        HashMap<String,Object> map = new HashMap<>();

        String absExistImgPath = baseDir+"\\"+existImgPath;
        System.out.println("deleteSingle");
        // 先删除 存在的文件 和 数据库中的内容
        boolean isSucceed = MyUtils.deleteFile(absExistImgPath);
        int i = pictureService.deletePicture(mapper,absExistImgPath.substring(absExistImgPath.indexOf("img")));
        isSucceed = isSucceed && i==1 ;
        String successMsg  = "成功删除照片";
        MyUtils.insertMsg(map, isSucceed,successMsg);

        // 单张照片操作完毕后 要将 session中的list值进行更新,删除 list中的 uploadImgPath 和 existImgPath
        TreeMap<String, ArrayList<Picture>> monthsTreeMapListPic = (TreeMap<String,ArrayList<Picture>>) req.getSession().getAttribute("monthsTreeMapListPic");
        Set<String> lists = monthsTreeMapListPic.keySet();
        for (String key : lists) {
            monthsTreeMapListPic.get(key).removeIf(
                    mapp -> mapp.getPath().equals(existImgPath)
            );
        }
        return new Gson().toJson(map);
    }


    private void deleteAllPicture(ArrayList<Picture> successPicturesList, ArrayList<String> errorInfoList) {
        for (Picture picture : successPicturesList) {
            String uploadImgPath = picture.getPath();
            String absUploadImgPath = baseDir+"\\"+uploadImgPath;
            boolean isDelete = MyUtils.deleteFile(absUploadImgPath);
            if(isDelete==false){
                // 随便写一个吧
                errorInfoList.add(uploadImgPath);
            }
        }
    }

    private void saveAllFailedPicture(ArrayList<HashMap<String, Object>> MapList, ArrayList<String> errorInfoList, ArrayList<Picture> picturesList) throws ParseException, ImageProcessingException, IOException {
        for (HashMap<String, Object> hashMap : MapList) {
            String uploadImgPath = ((Picture)hashMap.get("uploadPicture")).getPath();
            String absUploadImgPath = baseDir+"\\"+uploadImgPath;
            boolean moveSuccess = pictureService.moveImgToDirByAbsPathAndInsert(absUploadImgPath);
            if(!moveSuccess){
                errorInfoList.add(absUploadImgPath);
            }else {
                Picture uploadPicture = (Picture) hashMap.get("uploadPicture");
                String substring = uploadPicture.getPath().substring(uploadPicture.getPath().indexOf("img"));
                uploadPicture.setPath(substring);
                picturesList.add(uploadPicture);
            }
        }

    }

    private void saveAllPicture(ArrayList<Picture> successPicturesList, ArrayList<String> errorInfoList, ArrayList<Picture> picturesList) throws ParseException, ImageProcessingException, IOException {
        for (Picture picture : successPicturesList) {
            String uploadImgPath = picture.getPath();
            String absUploadImgPath = baseDir+"\\"+uploadImgPath;
            boolean moveSuccess = pictureService.moveImgToDirByAbsPathAndInsert(absUploadImgPath);
            if(!moveSuccess){
                errorInfoList.add(absUploadImgPath);
            }else {
                String substring = picture.getPath().substring(picture.getPath().indexOf("img"));
                picture.setPath(substring);
                picturesList.add(picture);
            }
        }

    }
    // 可以改写成为  对文件夹进行上传
  /*  @RequestMapping("/init")
    public String init(HttpServletRequest request){
        // 遍历文件夹下所有文件路径
        // 若父文件夹不存在则创建
        MyUtils.creatDir(uploadimgDir);
        String scrDir = "C:\\Users\\Administrator\\Desktop\\demo\\img";
        List<String> stringList = new ArrayList<>();
        ArrayList<HashMap<String, Object>> successMapList = new ArrayList<>();
        ArrayList<HashMap<String, Object>> failedMapList = new ArrayList<>();
        MyUtils.getallpath(scrDir,stringList);
        if(stringList.size()>0){
            for (String s : stringList) {
                try {
                    File src = new File(s);
                    String copypath = request.getSession().getServletContext().getRealPath("temp")+"\\"+src.getName();
                    MyUtils.copyFileUsingFileStreams(s,copypath);
                    File temp = new File(copypath);
                    pictureService.checkAndCreateImg(uploadimgDir, temp, successMapList, failedMapList);

                    // 只要一存在 检测出的照片 相似 就进行转发 显示到页面
                    request.getSession().setAttribute("failedMapList", failedMapList);
                    request.getSession().setAttribute("successMapList", successMapList);

                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        return "forward:/demo.jsp";
    }*/
}
