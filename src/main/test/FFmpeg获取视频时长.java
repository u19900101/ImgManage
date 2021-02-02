/**
 * @author lppppp
 * @create 2021-02-02 15:45
 */

import org.junit.Test;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.TimeZone;

/**
 * @description: ffmepg获取视频时长
 * @create: 2020/01/15 17:28
 */
public class FFmpeg获取视频时长 {
    public static HashMap<String, Object> getVideoInfo(String videoPath) {
        //ffmepg工具地址
        String ffmpegPath = "D:\\MyJava\\mylifeImg\\src\\main\\resource\\ffmpeg.exe";
        //拼接cmd命令语句
        StringBuffer buffer = new StringBuffer();
        buffer.append(ffmpegPath);
        //注意要保留单词之间有空格
        buffer.append(" -i ");
        buffer.append(videoPath);
        //执行命令语句并返回执行结果
        HashMap<String,Object> map = new HashMap<>();
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

                    map.put("creation_time", dld.toLocaleString());
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

    @Test
    public void T_video_info(){
        String videoPath = "D:\\MyJava\\mylifeImg\\src\\main\\webapp\\img\\f1\\m2.mp4";
        HashMap<String, Object> videoInfo = getVideoInfo(videoPath);
        System.out.println();
        System.out.println(videoInfo);
    }

//    时区转换
    @Test
    public void T_change_time_zero() throws ParseException {
        // 2015-12-12T06:58:58.000000Z----------------2015-12-12T14:58:58.000000Z
        String timeStr = "2015-12-12T06:58:58.000000Z"; // 字面时间

        String s = timeStr.replace("T", " ").split("\\.")[0];

        // SimpleDateFormat bjSdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");     // 北京
        // bjSdf.setTimeZone(TimeZone.getTimeZone("Asia/Shanghai"));  // 设置北京时区
        // 直接将时间按伦敦时间解析为date
        SimpleDateFormat londonSdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); // 伦敦
        londonSdf.setTimeZone(TimeZone.getTimeZone("Europe/London"));  // 设置伦敦时区
        Date dld = londonSdf.parse(s);
        System.out.println(dld.toLocaleString());

    }

    @Test
    public void Tkk() throws ParseException {
        // String timeStr = "2017-8-24 11:17:10"; // 字面时间
        String s = "2015-12-12T06:58:58.000000Z"; // 字面时间
        String timeStr = s.replace("T", " ").split("\\.")[0];
        SimpleDateFormat bjSdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        bjSdf.setTimeZone(TimeZone.getTimeZone("Asia/Shanghai"));
        Date date = bjSdf.parse(timeStr);  // 将字符串时间按北京时间解析成Date对象

        SimpleDateFormat tokyoSdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  // 东京
        tokyoSdf.setTimeZone(TimeZone.getTimeZone("Europe/London"));  // 设置东京时区
        System.out.println("北京时间: " + timeStr +"对应的伦敦时间为:"  + tokyoSdf.format(date));
    }
}
