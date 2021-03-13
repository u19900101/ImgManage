import com.alibaba.fastjson.JSON;

import java.util.Map;

/**
 * @author lppppp
 * @create 2021-03-13 17:04
 */
public class jsonToList {
    public static void main(String[] args) {


        String str = "{\"0\":\"[1,2,3,4]\",\"1\":\"lisi\",\"2\":\"wangwu\",\"3\":\"maliu\"}";
        //第一种方式
        Map maps = (Map)JSON.parse(str);
        System.out.println("这个是用JSON类来解析JSON字符串!!!");
        for (Object map : maps.entrySet()){
            System.out.println(((Map.Entry)map).getKey()+"     " + ((Map.Entry)map).getValue());
            System.out.println(((Map.Entry)map).getValue().getClass().getName());
        }


    }
}
