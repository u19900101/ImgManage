import com.drew.imaging.ImageProcessingException;
import org.junit.Test;
import ppppp.bean.Picture;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.Field;
import java.text.ParseException;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static ppppp.controller.PictureController.tempimgDir;
import static ppppp.service.PictureService.getImgInfo;

/**
 * @author lppppp
 * @create 2021-02-03 20:32
 */
public class 对时间字符串按月进行分组 {
    @Test
    public void T(){
        String s ="2020-10-06 14:34:52 2020-10-06 14:19:13 2020-10-06 14:17:05 2020-10-06 10:13:29 2020-10-06 10:03:59 2020-10-06 09:07:41 2020-10-06 09:05:13 2020-10-06 08:59:21 2020-10-06 08:46:44 2020-10-06 08:16:15 2020-10-06 08:08:14 2020-02-22 17:39:35 2020-02-02 20:26:40 2019-11-30 19:46:35 2019-11-28 17:53:58 2019-11-24 18:21:29 2019-11-22 21:05:04 2019-04-17 20:19:26 2019-03-23 12:40:30 2019-03-23 12:37:45 2019-03-17 12:20:21 2018-10-22 10:04:52 2016-08-16 09:33:17 2016-06-30 11:24:57 2016-05-22 13:34:35 2015-12-12 14:58:58 2015-10-17 13:26:59 2011-07-23 10:23:12";
        String[] s1 = s.split(" ");
        TreeMap<String,ArrayList<String>> map = new TreeMap<>(new Comparator<String>() {
            @Override
            public int compare(String o1, String o2) {
                return o2.compareTo(o1);
            }
        });
        for (int i = 0; i < s1.length; i+=2) {
            // System.out.println(s1[i]+" "+s1[i+1]);
            String month = s1[i].substring(0,7);

            if(!map.containsKey(month)){
                ArrayList<String> strings = new ArrayList<>();
                strings.add(s1[i]+" "+s1[i+1]);
                map.put(month,strings);
            }else {
                ArrayList<String> strings = map.get(month);
                strings.add(s1[i]+" "+s1[i+1]);
            }
        }
        // System.out.println(map);

        Set<String> strings = map.keySet();
        for (String string : strings) {
            System.out.println(string+"   "+map.get(string).size());
        }

    }

    @Test
    public void T_将文件名中时间信息写进数据库() throws ParseException, IOException, ImageProcessingException {



    }



    public String nameToCreateTime(String name){
        Pattern p = Pattern.compile("[0-9]{13}");
        Matcher m = p.matcher(name);
        if (m.find()) {
            String match = m.group();
            return longToDateStr(Long.valueOf(match)).split("\\.")[0];
        }

        Pattern p2 = Pattern.compile("(\\D*)([0-9]{4})([0-9]{2})([0-9]{2})(\\D*)([0-9]{2})([0-9]{2})([0-9]{2})(.*)");
        Matcher m2 = p2.matcher(name);
        if (m2.find()) {
            String match2 = m2.group(2);
            String match3 = m2.group(3);
            String match4 = m2.group(4);
            String match6 = m2.group(6);
            String match7 = m2.group(7);
            String match8= m2.group(8);
            return match2+"-"+match3+"-"+match4+" "+match6+":"+match7+":"+match8;
        }
        return null;
    }
    public String longToDateStr(long timeStamp){
        LocalDateTime localDateTime = Instant.ofEpochMilli(timeStamp).atZone(ZoneOffset.ofHours(8)).toLocalDateTime();
        return localDateTime.toString().replace("T", " ");
    }
}
