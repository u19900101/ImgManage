import org.junit.Test;
import org.python.core.PyFunction;
import org.python.core.PyInteger;
import org.python.core.PyObject;
import org.python.util.PythonInterpreter;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @author lppppp
 * @create 2021-03-11 9:17
 */
public class java调用python {
    @Test
    public void T(){
        PythonInterpreter interpreter = new PythonInterpreter();
        interpreter.exec("a=[5,2,3,9,4,0]; ");
        interpreter.exec("print(sorted(a));");  //此处python语句是3.x版本的语法
    }

    @Test
    public void T2(){
        // TODO Auto-generated method stub
        String imgpath = "D:\\py\\My_work\\6_27_facebook\\7.jpg";
        String landmarkpath = "D:\\MyJava\\mylifeImg\\src\\main\\java\\ppppp\\python\\shape_predictor_68_face_landmarks.dat";
        try {
            String pyFilePath = "D:\\MyJava\\mylifeImg\\pythonModule\\python\\quan.py";
            String[] args = new String[] { "python",pyFilePath ,imgpath,landmarkpath};
            Process proc = Runtime.getRuntime().exec(args);// 执行py文件

            BufferedReader in = new BufferedReader(new InputStreamReader(proc.getInputStream()));
            String line = null;
            while ((line = in.readLine()) != null) {
                System.out.println(line);
            }
            in.close();
            proc.waitFor();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

    }
//
//    [points[(2357, 292) ... ,points[(1230, 496), (1230, 524), ]]
    @Test
    public void TM(){
        String s = "rectangles[[(2340, 171) (2608, 439)], [(1181, 379) (1449, 647)], [(1181, 379) (1449, 647)]]";
        String regEx="[\\D]+";
        String[] cs = s.replaceAll(regEx, " ").trim().split(" ");

        // 每4个一组装进数组中
        ArrayList<List<Integer>> rect = new ArrayList<>();
        for (int i = 0; i < cs.length; ) {
            List<Integer> list = new ArrayList<>();
            for (int j = 0; j < 4; j++) {
                if(j == 2 || j == 3){
                    list.add(Integer.valueOf(cs[i])-Integer.valueOf(cs[i-2]));
                }else {
                    list.add(Integer.valueOf(cs[i]));
                }
                i++;
            }
            rect.add(list);
        }

        for (List<Integer> integers : rect) {
            System.out.println(integers.toString());
        }
    }

    @Test
    public void Tkk(){
        String content = "满39元减2元";
        //正则表达式，用于匹配非数字串，+号用于匹配出多个非数字串
        String regEx="[^0-9]+";
        Pattern pattern = Pattern.compile(regEx);
        //用定义好的正则表达式拆分字符串，把字符串中的数字留出来
        String[] cs = pattern.split(content);
        System.out.println(Arrays.toString(cs));
    }

    @Test
    public void T1(){
        String[] cs = " a, b ; ; c".split("[,;\\s]+");
        for (String c : cs) {
            System.out.println(c);
        }
        System.out.println(Arrays.toString(cs));
    }
}
