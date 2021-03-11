import org.junit.Test;
import org.python.core.PyFunction;
import org.python.core.PyInteger;
import org.python.core.PyObject;
import org.python.util.PythonInterpreter;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

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
//    rectangles[[(2340, 171) (2608, 439)], [(1181, 379) (1449, 647)]
//    [points[(2357, 292) ... ,points[(1230, 496), (1230, 524), ]]
}
