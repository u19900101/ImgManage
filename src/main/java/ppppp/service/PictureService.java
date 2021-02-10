package ppppp.service;

import com.drew.imaging.ImageMetadataReader;
import com.drew.imaging.ImageProcessingException;
import org.junit.Test;
import org.opencv.core.*;
import org.opencv.imgcodecs.Imgcodecs;
import org.opencv.imgproc.Imgproc;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import ppppp.bean.Picture;
import ppppp.bean.PictureExample;
import ppppp.dao.PictureMapper;
import ppppp.util.MyUtils;

import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static ppppp.controller.PictureController.*;

/**
 * @author lppppp
 * @create 2021-02-01 10:36
 */
@Service
public class PictureService {
    @Autowired
    PictureMapper mapper;
    // 1.获取照片的时间 经度 纬度信息
    public static HashMap<String, String> getImgInfo(File file) throws ImageProcessingException, IOException, ParseException {
        HashMap<String,String>map = new HashMap<>();
        //如果你对图片的格式有限制，可以直接使用对应格式的Reader如：JPEGImageReader
        ImageMetadataReader.readMetadata(file)
                .getDirectories().forEach(v ->
                v.getTags().forEach(t -> {
                    // System.out.println(t.getTagName() + " ： " + t.getDescription());
                    switch (t.getTagName()) {
                        //                    经度
                        case "GPS Longitude":
                            map.put("GPS_Longitude",t.getDescription());
                            break;
                        //                        纬度
                        case "GPS Latitude":
                            map.put("GPS_Latitude",t.getDescription());
                            break;
                        //                        拍摄时间
                        // 解决有的照片中有两个 Date/Time Original 但是格式不一样
                        case "Date/Time Original":
                            if(map.get("create_time")==null){
                                // 修改格式
                                //2016:08:16 09:33:17  location: 100_33_11.27,36_33_34.23
                                String time = t.getDescription();
                                String[] s = time.split(" ");
                                String replace = s[0].replace(":", "-");

                                map.put("create_time",replace+" "+ s[1]);
                            }
                            break;
                        //    获取照片的尺寸 便于照片去重判断
                        case "Image Height":
                            // System.out.println(t.getDescription());
                            map.put("height",t.getDescription().split(" ")[0]);
                            break;
                        case "Image Width":
                            // System.out.println(t.getDescription());
                            map.put("width",t.getDescription().split(" ")[0]);
                            break;
                        /*   这个时间没有太多参考意义*/
                        // case "Date/Time":
                        //     if(map.get("date_time")==null){
                        //         map.put("date_time",t.getDescription());
                        //     }
                        default:
                            break;
                    }
                })
        );

        if(map.get("GPS_Longitude")!=null && map.get("GPS_Latitude")!=null){
            String lon = map.get("GPS_Longitude").replace(" ","").replace("\"","")
                    .replace("°","_").replace("'","_");
            String lat = map.get("GPS_Latitude").replace(" ","").replace("\"","")
                    .replace("°","_").replace("'","_");
            map.put("GPS_Longitude", lon);
            map.put("GPS_Latitude", lat);
        }
        return map;
    }

    public static HashMap<String, String> getVideoInfo(String videoPath) {
        //ffmepg工具地址
        String ffmpegPath = "D:\\MyJava\\mylifeImg\\src\\main\\resource\\ffmpeg.exe";
        //拼接cmd命令语句
        StringBuffer buffer = new StringBuffer();
        buffer.append(ffmpegPath);
        //注意要保留单词之间有空格
        buffer.append(" -i ");
        buffer.append(videoPath);
        //执行命令语句并返回执行结果
        HashMap<String,String> map = new HashMap<>();
        try {
            Process process = Runtime.getRuntime().exec(buffer.toString());
            InputStream in = process.getErrorStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(in));
            String line ;
            while((line=br.readLine())!=null) {
                if(line.trim().startsWith("Duration:")){
                    //根据字符匹配进行切割
                    // System.out.println("视频时间 = " + line.trim().substring(0,line.trim().indexOf(",")));
                    map.put("duration", line.trim().substring(0,line.trim().indexOf(",")).split(" ")[1]);
                }
                //一般包含fps的行就包含分辨率
                if(line.contains("fps")){
                    //根据
                    String definition = line.split(",")[2];
                    definition = definition.trim().split(" ")[0];
                    // System.out.println("分辨率 = " + definition);
                    map.put("size", definition);
                }

                if(map.get("creation_time")==null&&line.trim().startsWith("creation_time")){
                    String []creation_time = line.trim().split(" ");
                    String timeStr =  creation_time[creation_time.length-1];
                    String s = timeStr.replace("T", " ").split("\\.")[0];

                    // SimpleDateFormat bjSdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");     // 北京
                    // bjSdf.setTimeZone(TimeZone.getTimeZone("Asia/Shanghai"));  // 设置北京时区
                    // 直接将时间按伦敦时间解析为date
                    SimpleDateFormat londonSdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); // 伦敦
                    londonSdf.setTimeZone(TimeZone.getTimeZone("Europe/London"));  // 设置伦敦时区
                    Date dld = londonSdf.parse(s);

                    map.put("create_time", dld.toLocaleString());
                    // System.out.println(dld.toLocaleString());

                }

                if(map.get("location")==null&&line.trim().startsWith("location")){
                    //根据字符匹配进行切割
                    String []location = line.trim().split("\\+");
                    map.put("location", location[2].replace("/", "")+","+location[1]);
                    // System.out.println(line.trim());
                }
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return map;
    }


    public HashMap<String, Object> checkAndCreateImg(String destDir, File srcFile) throws ParseException, IOException, ImageProcessingException {
        //在整个数据库中进行 照片去重检查
        ArrayList<String> stringList = new ArrayList<>();
        HashMap<String,Object> map =new HashMap<>();
        MyUtils.getallpath(destDir,stringList);

        //判断图片在数据库中是否存在相似的照片
        if(!isImgType(srcFile.getName())){
            return map;
        }
        int [] imgA = aHash(srcFile.getAbsolutePath());
        // 查询库中所有的 图片
        List<Picture> pictures = mapper.selectByExample(new PictureExample());
        // 将上传的图片与 现有的所有id进行比对
        String picStrId = MyUtils.intsToStr(imgA);

        Picture uploadPicture = fileToPicture(srcFile.getAbsolutePath(),picStrId);
        map.put("uploadPicture", uploadPicture);
        boolean isExist = isPictureExist(srcFile,pictures,map,imgA);

        //存在
        if(isExist){
            System.out.println("  存在相同照片.....");
            // 判断 服务器中是否存在  不存在就移动  存在就不动
            MyUtils.copyFileUsingFileStreams(srcFile.getAbsolutePath(), uploadimgDir.replace("img", "")+map.get("existImgPath"));

            // 不能删 删了页面就读不到....
            // map.put("failedMsg","    上传失败,存在相同照片.....");
        }
        // 不存在，按照片信息建立文件夹上传
        else {
            // 返回值为 按照时间写的项目 相对 路 径
            String createdPath =  createImgFile(srcFile);
            createdPath = createdPath.substring(createdPath.indexOf("img"));
            // 若未成功上传 则 删除 上传的图片
            if(createdPath==null){
                // srcFile.delete();
                map.put("failedMsg","  上传失败,未能成功移动照片！！");
                // return "  上传失败,未能成功移动照片！！";
            }else {
                // 上传成功后马上将信息写入数据库 以免刷新时 的重复上传
                uploadPicture.setPath(createdPath);
                insertInfo(uploadPicture);
                // 将照片信息放入map中 便于页面显示
                map.put("uploadPicture", uploadPicture);
                map.put("successMsg","    上传成功！！");
                map.put("successPath",createdPath);
                map.put("picStrId",MyUtils.intsToStr(imgA));
            }
        }
        return map;
    }

    private boolean isPictureExist(File srcFile, List<Picture> pictures, HashMap<String, Object> map, int[] imgA) throws IOException {
        long l = System.currentTimeMillis();
        int count = 0;
        for (Picture picture : pictures) {
            String s = picture.getPath();
            if(isImgType(s.substring(s.length()-3))){
                String picturePid = picture.getPid();
                int[] imgB = MyUtils.getIntNum(picturePid);
                double imageSimilar = diff(imgA, imgB);
                System.out.println("图片 ："+s+"与原图的相似度为： "+imageSimilar);
                count++;
                if(imageSimilar>IMAGE_SIMILARITY){
                    map.put("failedMsg","上传失败,存在相同照片.....");
                    map.put("existImgPath", s);
                    // 将存在的照片信息放入map中 便于页面显示
                    map.put("existPicture", picture);
                    // 检测服务器上指定位置是否存在该文件
                    File isExistFile = new File(uploadimgDir.replace("img", ""),s);
                    if(!isExistFile.exists()){
                        //检测父文件夹是否存在
                        MyUtils.creatDir(isExistFile.getParent());
                        //只能复制，不可移动过去，不然 页面显示又找不到文件
                        MyUtils.copyFileUsingFileStreams(srcFile.getAbsolutePath(), isExistFile.getAbsolutePath());
                    }
                    System.out.println(("耗时："+(System.currentTimeMillis()-l)/1000)+" s 共检测照片 "+count+" 张");
                    return true;
                }
            }
        }
        System.out.println(("耗时："+(System.currentTimeMillis()-l)/1000)+" s 共检测照片 "+count+" 张");
        return false;
    }

    public static String createImgFile(File img) throws ParseException, IOException, ImageProcessingException {
        HashMap<String, String> imgInfo = getImgInfo(img);

        String create_time = imgInfo.get("create_time");
        String destDir;
        // 将照片移入日期类文件夹
        //照片包含时间信息的 移入照片创建的日期文件夹
        if(create_time!=null){
            destDir = uploadimgDir+"\\"+create_time.split(" ")[0].replace("-","\\");
        }
        //照片不包含时间信息的 移入导入时间的文件夹
        else {
            destDir = uploadimgDir+"\\"+LocalDateTime.now().toString().split("T")[0].replace("-","\\");
        }
        // 创建文件夹
        MyUtils.creatDir(destDir);
        return MyUtils.move_file(img.getAbsolutePath(), destDir);
    }


    // 2.将照片或视频信息写入数据库中
    public int insertInfo(Picture uploadPicture){

        //将图片的相对路径存入数据库中 以便页面显示
        int insert = mapper.insert(uploadPicture);
        return insert;
    }

    private Picture fileToPicture(String filepath,String picStrId) throws ParseException, IOException, ImageProcessingException {
        HashMap<String, String> map = new HashMap<>();
        Picture pic = new Picture();
        File file = new File(filepath);
        // 以后缀名来判断文件是图片还是视频
        if(isImgType(filepath)){
            map = getImgInfo(file);
        }else if(isVideoType(filepath)){
            map = getVideoInfo(filepath);
            return null;
        }
        // 路径在外面设置
        pic.setPid(picStrId);
        pic.setPname(file.getName());
        pic.setPcreatime(map.get("create_time"));

        pic.setGpsLatitude(map.get("gpsLatitude"));
        pic.setGpsLongitude(map.get("gpsLongitude"));
        pic.setPheight(Integer.valueOf(map.get("height")));
        pic.setPwidth(Integer.valueOf(map.get("width")));
        // 四舍五入保留两位小数
        pic.setPsize(Double.valueOf(new DecimalFormat("0.00").format(file.length()/1024.0/1024.0)));
        return pic;
    }


    public boolean setMapInfo(String s, HashMap<String, Object> map,
                              HttpServletRequest request, File temp) throws IOException {
        if(map.get("successMsg")!=null){
            map.put("successMsg","图片："+s+ map.get("successMsg"));
            String tempStr = (String) map.get("successPath");
            map.put("successPath",tempStr.substring(tempStr.indexOf("img")));
        }

        if(map.get("failedMsg")!=null){
            map.put("failedMsg","图片："+s+ map.get("failedMsg"));
            // 上传失败有两种原因  存在重复图片  或者  移动照片失败
            if(map.get("existImgPath")!=null){
                //移动后要修改 页面显示的路径
                String temppath = temp.getAbsolutePath();
                map.put("uploadImgPath",temppath.substring(temppath.indexOf("temp")));
            }
            return true;
        }
        return false;
    }

    public static boolean isImgType(String filetype){
        filetype = filetype.toLowerCase();
        return filetype.endsWith("jpg") || filetype.endsWith("png")|| filetype.endsWith("jpeg")|| filetype.endsWith("gif")|| filetype.endsWith("bmp");
    }
    public static boolean isVideoType(String filetype){
        filetype = filetype.toLowerCase();
        return filetype.endsWith("mp4") || filetype.endsWith("avi")|| filetype.endsWith("mov")|| filetype.endsWith("rmvb")|| filetype.endsWith("mpeg");
    }
    /** 均值哈希算法*/
    public static int[] aHash(String src){
        System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
        int[] res = new int[64];
        try {
            int width = 8;
            int height = 8;
            File srcPic = new File(src);
            Mat  srcMat = null;

            if(isContainChinese(src)){
                FileInputStream inputStream = new FileInputStream(srcPic);
                byte[] byt = new byte[(int) srcPic.length()];
                int read = inputStream.read(byt);
                srcMat =  Imgcodecs.imdecode(new MatOfByte(byt), Imgcodecs.IMREAD_COLOR);
                // 不关闭的话 文件无法移动，尬。。。。
                inputStream.close();
            }else{
                srcMat = Imgcodecs.imread(src, Imgcodecs.IMREAD_ANYCOLOR);
            }

            Mat resizeMat = new Mat();
            Imgproc.resize(srcMat,resizeMat, new Size(width, height),0,0);


            // 将缩小后的图片转换为64级灰度（简化色彩）
            int total = 0;
            int[] ints = new int[64];

            int index = 0;
            for (int i = 0;i < height;i++){
                for (int j = 0;j < width;j++){
                    int gray = gray(resizeMat.get(i, j));
                    ints[index++] = gray;
                    total = total + gray;
                }
            }
            // 计算灰度平均值
            int grayAvg = total / (width * height);
            // 比较像素的灰度
            for (int i =0;i<ints.length;i++) {
                if (ints[i] >= grayAvg) {
                    res[i] = 1;
                } else {
                    res[i] = 0;
                }
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return res;
    }
    private static int gray(double[] bgr) {
        int rgb = (int) (bgr[2] * 77 + bgr[1] * 151 + bgr[0] * 28) >> 8;
        int gray = (rgb << 16) | (rgb << 8) | rgb;
        return gray;
    }

    // 判断两者之间的4个方向转换是否都不同，若有一个完全相同则说明两张图相似
    public  double diff(int[] imgA,int[] imgB){
        int []diffCount = new int[4];
        diffCount[0] = caluDiff(imgB,imgA);
        if(diffCount[0]==64){
            return 1.0;
        }
        //第1次旋转90度后比较
        int[] turn90 = clockwise90Deg(imgA, 8);
        diffCount[1] = caluDiff(imgB,turn90);
        if(diffCount[1]==64){
            return 1.0;
        }
        //第2次旋转90度后比较
        int[] turn180 = clockwise90Deg(turn90, 8);
        diffCount[2] = caluDiff(imgB,turn180);
        if(diffCount[1]==64){
            return 1.0;
        }
        //第3次旋转90度后比较
        int[] turn270 = clockwise90Deg(turn180, 8);
        diffCount[3] = caluDiff(imgB,turn270);
        if(diffCount[3]==64){
            return 1.0;
        }

        return (diffCount[0]+diffCount[1]+diffCount[2]+diffCount[3])/64.0/4.0;
    }

    private int caluDiff(int[] imgB, int[] imgA) {
        int diffCount = 0;
        for (int i = 0; i < imgB.length; i++) {
            if (imgB[i] == imgA[i]) {
                diffCount++;
            }
        }
        return diffCount;
    }

    public int[] clockwise90Deg(int []origin, int row){
        int col = origin.length/row;
        int [][]list = new int[row][col];
        for (int i = 0; i < row; i++) {
            for (int j = 0; j < col; j++) {
                list[i][j] = origin[i*col+j];
            }
        }
        int []newlist = new int[col*row];
        for (int i = 0; i < row; i++) {
            for (int j = 0; j < col; j++) {
                newlist[j*col+row-1-i] = list[i][j];
            }
        }
        return newlist;
    }
    // 解决图片路径中包含中文
    public static boolean isContainChinese(String str) {
        Pattern p = Pattern.compile("[\u4e00-\u9fa5]");
        Matcher m = p.matcher(str);
        if (m.find()) {
            return true;
        }
        return false;
    }
}
