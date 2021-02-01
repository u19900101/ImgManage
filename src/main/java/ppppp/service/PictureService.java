package ppppp.service;

import com.drew.imaging.ImageMetadataReader;
import com.drew.imaging.ImageProcessingException;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ppppp.bean.Picture;
import ppppp.dao.PictureMapper;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;

/**
 * @author lppppp
 * @create 2021-02-01 10:36
 */
@Service
public class PictureService {
    @Autowired
    PictureMapper mapper;
    // 1.获取照片的时间 经度 纬度信息
    public static HashMap<String, String> readExif(File file) throws ImageProcessingException, IOException, ParseException {
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
                        case "Date/Time Original":
                            map.put("creatime",t.getDescription());
                        default:
                            break;
                    }
                })
        );
        String dateStr = map.get("creatime");
        SimpleDateFormat sdf = new SimpleDateFormat("EEE MMM dd HH:mm:ss zzz yyyy", Locale.US);

        Date date = (Date) sdf.parse(dateStr);
        String formatStr= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date);
        map.put("creatime",formatStr);
        return map;
    }


    // 2.将照片信息写入数据库中
    public void insertInfo(String filepath) throws ParseException, IOException, ImageProcessingException {
        Picture pic = new Picture();
        File file = new File(filepath);
        pic.setPath(file.getAbsolutePath());
        pic.setPname(file.getName());
        pic.setPcreatime(readExif(file).get("creatime"));

        if(readExif(file).get("GPS_Longitude")!=null && readExif(file).get("GPS_Latitude")!=null){
            pic.setPlocal(readExif(file).get("GPS_Longitude")+","+readExif(file).get("GPS_Latitude"));
        }
        System.out.println(pic);
        // int insert = mapper.insert(pic);
        System.out.println("成功写入图片: "+file.getName()+" 信息到数据库");
    }

    @Test
    public void T(){
        // 遍历文件夹下所有文件路径
        String dir = "D:\\MyJava\\mylifeImg\\src\\main\\webapp\\static\\";
        File dirfile = new File(dir);
        String[] list = dirfile.list();
        for (String s : list) {
            String filepath = dir+s;
            try {
                insertInfo(filepath);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
