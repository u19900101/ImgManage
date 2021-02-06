package ppppp.service;

import com.drew.imaging.ImageMetadataReader;
import com.drew.imaging.ImageProcessingException;
import org.junit.Test;
import org.opencv.core.*;
import org.opencv.imgcodecs.Imgcodecs;
import org.opencv.imgproc.Imgproc;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ppppp.bean.Picture;
import ppppp.dao.PictureMapper;

import java.io.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static ppppp.controller.PictureController.getallpath;

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
                        //    这个时间没有太多参考意义
                      /*  case "Date/Time":
                            if(map.get("date_time")==null){
                                map.put("date_time",t.getDescription());
                            }*/

                        default:
                            break;
                    }
                })
        );
        // 不进行转换，只获取第一个即可
        // String dateStr = map.get("creatime");
        // SimpleDateFormat sdf = new SimpleDateFormat("EEE MMM dd HH:mm:ss zzz yyyy", Locale.US);
        //
        // Date date = (Date) sdf.parse(dateStr);
        // String formatStr= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date);
        // map.put("creatime",formatStr);
        if(map.get("GPS_Longitude")!=null && map.get("GPS_Latitude")!=null){
            String lon = map.get("GPS_Longitude").replace(" ","").replace("\"","")
                    .replace("°","_").replace("'","_");
            String lat = map.get("GPS_Latitude").replace(" ","").replace("\"","")
                    .replace("°","_").replace("'","_");
            map.put("location", lon+","+lat);
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

    public static double getImageSimilar(String imgpathA,String imgpathB){
        //加载库
        System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
        // System.out.println("opencv = " + Core.VERSION);
        Mat H1 = getHistImage(imgpathA);
        Mat H2 = getHistImage(imgpathB);
        return Imgproc.compareHist(H1, H2, 0);
    }
    public static boolean isContainChinese(String str) {
        Pattern p = Pattern.compile("[\u4e00-\u9fa5]");
        Matcher m = p.matcher(str);
        if (m.find()) {
            return true;
        }
        return false;
    }
    public static Mat getHistImage(String pathName){
        System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
        System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
        File srcPic = new File(pathName);
        Mat  srcMat = new Mat();
        if(isContainChinese(pathName)){
            FileInputStream inputStream = null;
            try {
                inputStream = new FileInputStream(srcPic);
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            }
            byte[] byt = new byte[(int) srcPic.length()];
            try {
                int read = inputStream.read(byt);
            } catch (IOException e) {
                e.printStackTrace();
            }
            srcMat =  Imgcodecs.imdecode(new MatOfByte(byt), Imgcodecs.IMREAD_COLOR);
        }else{
            srcMat = Imgcodecs.imread(srcPic.getAbsolutePath(), Imgcodecs.IMREAD_ANYCOLOR);
        }

        Mat gray = new Mat();
        //1 图片灰度化
        Imgproc.cvtColor(srcMat, gray, Imgproc.COLOR_BGR2GRAY);
        List<Mat> matList = new LinkedList<Mat>();
        matList.add(gray);
        Mat histogram = new Mat();
        MatOfFloat ranges=new MatOfFloat(0,256);
        MatOfInt histSize = new MatOfInt(255);
        //2 计算直方图
        Imgproc.calcHist(matList,new MatOfInt(0),new Mat(),histogram,histSize ,ranges);
        //3 创建直方图面板
        Mat histImage = Mat.zeros( 100, (int)histSize.get(0, 0)[0], CvType.CV_8UC1);
        //4 归一化直方图
        Core.normalize(histogram, histogram, 1, histImage.rows() , Core.NORM_MINMAX, -1);
        return histogram;
    }
    // 2.将照片或视频信息写入数据库中
    public void insertInfo(String filepath) throws ParseException, IOException, ImageProcessingException {
        String filetype = filepath.split("\\.")[1].toLowerCase();
        HashMap<String,String> map = new HashMap<>();
        Picture pic = new Picture();
        File file = new File(filepath);
        // 以后缀名来判断文件是图片还是视频
        if(isImgType(filetype)){
            map = getImgInfo(file);
        }else if(isVideoType(filetype)){
            map = getVideoInfo(filepath);
        }
        //将图片的相对路径存入数据库中 以便页面显示
        String path = file.getAbsolutePath();
        pic.setPath(path.substring(path.indexOf("img")));
        pic.setPname(file.getName());
        pic.setPcreatime(map.get("create_time"));
        pic.setPlocal(map.get("location"));
        // if(pic.getPcreatime()!=null || pic.getPlocal()!=null){
        //     System.out.println("成功写入图片___"+file.getName()+" create_time: "+ pic.getPcreatime()+"  location: "+ pic.getPlocal());
        // }
        int insert = mapper.insert(pic);

    }
    public static boolean isImgType(String filetype){
        return filetype.equals("jpg") || filetype.equals("png")|| filetype.equals("jpeg")|| filetype.equals("gif")|| filetype.equals("bmp");
    }
    public static boolean isVideoType(String filetype){
        return filetype.equals("mp4") || filetype.equals("avi")|| filetype.equals("mov")|| filetype.equals("rmvb");
    }
    @Test
    public void T_img() throws ParseException, ImageProcessingException, IOException {
        insertInfo("D:\\MyJava\\mylifeImg\\src\\main\\webapp\\img\\f2\\gofree.jpg");
    }
    @Test
    public void T_video() throws ParseException, ImageProcessingException, IOException {
        HashMap<String, String> videoInfo = getVideoInfo("D:\\MyJava\\mylifeImg\\src\\main\\webapp\\img\\f1\\m2.mp4");
        System.out.println(videoInfo);
        //    {creation_time=2015-12-12 14:58:58, duration=00:00:21.55, size=1280x720, location=114.3300,31.0065}
    }
    @Test
    public void T_img_video(){
        // 遍历文件夹下所有文件路径
        String dir = "D:\\MyJava\\mylifeImg\\src\\main\\webapp\\img\\";
        List<String> stringList = new ArrayList<>();
        getallpath(dir,stringList);
        for (String s : stringList) {
            try {
                insertInfo(s);
                // HashMap<String, String> stringStringHashMap = getImgInfo(new File(filepath));
                // System.out.println(s+"------"+stringStringHashMap);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
