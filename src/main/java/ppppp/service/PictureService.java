package ppppp.service;

import com.drew.imaging.ImageMetadataReader;
import com.drew.imaging.ImageProcessingException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ppppp.bean.Picture;
import ppppp.bean.PictureExample;
import ppppp.dao.PictureMapper;
import ppppp.util.MyUtils;

import java.io.*;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.*;

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
    public static Picture getImgInfo(File file) throws ImageProcessingException, IOException, ParseException {

        String fileName = file.getName();
        String parentName = file.getParent();
        Picture pic = new Picture();
        pic.setPsize(Double.valueOf(new DecimalFormat("0.00").format(Double.valueOf(file.length())/1024.0/1024.0)));
        //如果你对图片的格式有限制，可以直接使用对应格式的Reader如：JPEGImageReader
        ImageMetadataReader.readMetadata(file)
                .getDirectories().forEach(v ->
                v.getTags().forEach(t -> {
                    // System.out.println(t.getTagName() + " ： " + t.getDescription());
                    switch (t.getTagName()) {
                        //                    经度
                        case "GPS Longitude":
                            String lon = t.getDescription().replace(" ","").replace("\"","")
                                    .replace("°","_").replace("'","_");
                            pic.setGpsLongitude(lon);
                            break;
                        //                        纬度
                        case "GPS Latitude":
                            String lat = t.getDescription().replace(" ","").replace("\"","")
                                    .replace("°","_").replace("'","_");
                            pic.setGpsLatitude(lat);
                            break;
                        //                        拍摄时间
                        // 解决有的照片中有两个 Date/Time Original 但是格式不一样
                        case "Date/Time Original":

                            // 修改格式
                            // 2016-08-16T09:33:17
                            //2016:08:16 09:33:17  location: 100_33_11.27,36_33_34.23
                            String time = t.getDescription();
                            String[] s = time.split(" ");
                            String replace = s[0].replace(":", "-");
                            pic.setPcreatime(replace+"T"+ s[1]);
                            break;
                        //    获取照片的尺寸 便于照片去重判断
                        case "Image Height":
                            pic.setPheight(Integer.valueOf(t.getDescription().split(" ")[0]));
                            break;
                        case "Image Width":
                            pic.setPwidth(Integer.valueOf(t.getDescription().split(" ")[0]));
                            break;
                        default:
                            break;
                    }
                })
        );
        // 若照片名称中含有时间信息  则将其作为照片的拍摄时间
        String destDir = null;

        // 只有当照片名称中包含时间信息时  才对照片重命名
        String isContainCreate_time = MyUtils.nameToCreateTime(file.getName());
        if(isContainCreate_time!=null){
            if(pic.getPcreatime() == null){
                pic.setPcreatime(isContainCreate_time);
                //2016-08-16T09:33:17   2016_08_16T09_33_17
                fileName = isContainCreate_time.replace("-", "_").replace(":", "_")+fileName.substring(fileName.lastIndexOf("."));
            }
            // 照片名称中包含时间 信息  但是 照片本身也有时间信息  则以 照片本身的时间信息命名
            else {
                fileName = pic.getPcreatime().replace("-", "_").replace(":", "_")+fileName.substring(fileName.lastIndexOf("."));
            }
            // 现在temp 中rename  再移动到指定文件夹
            // 保证fileName不重复
            fileName = MyUtils.createNewName(file.getParentFile().list(), fileName);
            boolean rename = file.renameTo(new File(parentName, fileName));
            if(rename){
                System.out.println("重命名照片成功:"+file.getName()+"---->>>"+fileName);
            }else {
                fileName = file.getName();
            }
        }

        // 照片本身不包含时间信息
        if(pic.getPcreatime()==null){
            //照片不包含时间信息的 移入导入时间的文件夹
            String create_time = LocalDateTime.now().toString().split("\\.")[0];
            pic.setPcreatime(create_time);
            // 月份文件夹
            destDir = tempimgDir+"\\"+LocalDateTime.now().toString().substring(0,7).replace("-","\\");
        }
        // 照片本身 已经 包含时间信息
        else {
            // 若照片名称中包含时间信息  则修改 照片名称与时间相关
            // 重命名后移动到新的文件夹中
            destDir = tempimgDir+"\\"+pic.getPcreatime().substring(0,7).replace("-","\\");
        }
        MyUtils.creatDir(destDir);
        String afterMoveAbs = MyUtils.move_file(parentName + "\\" + fileName, destDir);
        if(afterMoveAbs!=null){
            fileName = new File(afterMoveAbs).getName();
        }
        pic.setPname(fileName);
        String fileAbspath = destDir + "\\" + fileName;
        pic.setPath(fileAbspath.substring(fileAbspath.indexOf("temp")));
        String picStrId = MyUtils.createPicIdByAbsPath(fileAbspath);
        pic.setPid(picStrId);

        return pic;
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
    public void checkAndCreateImg(String destDir, File uploadImgTemp,
                                  ArrayList<HashMap<String, Object>> successMapList,
                                  ArrayList<HashMap<String, Object>> failedMapList) throws ParseException, IOException, ImageProcessingException {
        //在整个数据库中进行 照片去重检查
        ArrayList<String> stringList = new ArrayList<>();
        HashMap<String,Object> map =new HashMap<>();
        MyUtils.getallpath(destDir,stringList);

        //判断图片在数据库中是否存在相似的照片
        int [] imgA = MyUtils.aHash(uploadImgTemp.getAbsolutePath());
        // 查询库中所有的 图片
        List<Picture> pictures = mapper.selectByExample(new PictureExample());
        // 将上传的图片与 现有的所有id进行比对
        Picture uploadPicture = getImgInfo(uploadImgTemp);
        map.put("uploadPicture", uploadPicture);

        //应对有可能的改变图片命名  产生的路径不存在问题
        uploadImgTemp = new File(tempimgDir,uploadPicture.getPath());
        boolean isExist = isPictureExist(uploadImgTemp,pictures,map,imgA);

        //存在
        if(isExist){
            System.out.println("  存在相同照片.....");
            // 判断 服务器中是否存在  不存在就移动  存在就不动
            File existImg = new File(baseDir+"\\"+uploadPicture.getPath().substring(uploadPicture.getPath().indexOf("img")));
            if(!existImg.exists()){
                MyUtils.copyFileUsingFileStreams(existImg.getAbsolutePath(), baseDir+"\\"+((Picture)map.get("existPicture")).getPath());
            }
            map.put("failedMsg","图片："+uploadImgTemp.getName()+"  疑似重复鸟！！");
            failedMapList.add(map);
        }
        // 不存在，按照片信息建立文件夹上传
        else {
            // 上传成功后马上将信息写入数据库 以免刷新时 的重复上传
            // 将照片信息放入map中 便于页面显示
            map.put("uploadPicture", uploadPicture);
            map.put("successMsg","图片："+uploadImgTemp.getName()+" 上传成功！！");
            successMapList.add(map);
        }
    }
    //在整个数据库中对比是否存在相似的照片
    private boolean isPictureExist(File srcFile, List<Picture> pictures, HashMap<String, Object> map, int[] imgA) throws IOException {
        long l = System.currentTimeMillis();
        int count = 0;
        for (Picture picture : pictures) {
            String s = picture.getPath();
            if(MyUtils.isImgType(s)){
                String picturePid = picture.getPid();
                int[] imgB = MyUtils.getIntNum(picturePid);
                double imageSimilar = MyUtils.diff(imgA, imgB);
                System.out.println("图片 ："+s+"与原图的相似度为： "+imageSimilar);
                count++;
                // 返回找到的第一张相似照片
                if(imageSimilar>IMAGE_SIMILARITY){
                    map.put("failedMsg","上传失败,存在相同照片.....");
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


    public boolean moveImgToDirByAbsPathAndInsert(Picture picture) {
        // 2.移动  //3.写入数据库
        String absDestDir = baseDir + "\\" +new File(picture.getPath()).getParent().replace("temp", "");
        MyUtils.creatDir(absDestDir);
        String absimg = MyUtils.move_file(baseDir + "\\" + picture.getPath(),absDestDir);
        if(absimg!=null && picture!=null){
            // 此处有可能 重名后  对照片进行重命名了
            picture.setPath(absimg.substring(absimg.indexOf("img")));
            return insertPicture(picture)==1;
        }

        return false;
    }

    public boolean moveImgToDirByAbsPathAndInsert(String absUploadImgPath) throws ParseException, IOException, ImageProcessingException {
        //1.获取信息 2.移动
        Picture picture = getImgInfo(new File(absUploadImgPath));
        //3.写入数据库
        if(picture!=null){
            return mapper.insert(picture)==1;
        }
        return false;
    }
    public int deletePicture(PictureMapper mapper, String ...imgPath) {
        int count = 0;
        for (String s : imgPath) {
            PictureExample example = new PictureExample();
            PictureExample.Criteria criteria = example.createCriteria();
            criteria.andPathEqualTo(s);
            int i = mapper.deleteByExample(example);
            count+=i;
        }

        return count;
    }

    public int insertPicture(Picture picture){
        //将图片的相对路径存入数据库中 以便页面显示
        int insert = mapper.insert(picture);
        return insert;
    }

    public static TreeMap<String, ArrayList<Picture>> groupPictureByMonth(List<Picture> pictures) {
        //将带时间的照片按月进行分组
        TreeMap<String,ArrayList<Picture>> map = new TreeMap<>(new Comparator<String>() {
            // 月份按照降序排列
            @Override
            public int compare(String o1, String o2) {
                return -o1.compareTo(o2);
            }
        });

        for (Picture picture : pictures) {
            // 有拍摄时间 信息的就按月分组
            if(picture.getPcreatime()!=null){
                String month = picture.getPcreatime().substring(0, 7);
                if(!map.containsKey(month)){
                    ArrayList<Picture> pictureArrayList = new ArrayList<>();
                    pictureArrayList.add(picture);
                    map.put(month,pictureArrayList);
                }else {
                    ArrayList<Picture> pictureArrayList = map.get(month);
                    pictureArrayList.add(picture);
                }
            }else {
                if(!map.containsKey("神秘时间")){
                    ArrayList<Picture> noneTimePicArrayList = new ArrayList<>();
                    map.put("神秘时间", noneTimePicArrayList);
                    noneTimePicArrayList.add(picture);
                }else {
                    ArrayList<Picture> noneTimePicArrayList = map.get("神秘时间");
                    noneTimePicArrayList.add(picture);
                }
            }

        }
        return map;
    }
}
