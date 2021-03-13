import org.junit.Test;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Arrays;

/**
 * @author lppppp
 * @create 2021-03-11 9:17
 */
public class java调用python {

    @Test
    public void T(){
        String s = "123kkk";
        System.out.println(Arrays.toString(s.split("\\d{2}")));
    }
    @Test
    public void T_传参(){
        // TODO Auto-generated method stub
        String imgpath = "D:\\MyJava\\mylifeImg\\pythonModule\\face\\d\\9.jpg";
        try {
            String pyFilePath = "D:\\MyJava\\mylifeImg\\pythonModule\\python\\getFaceInfo.py";
            String[] args = new String[] { "python",pyFilePath ,imgpath};
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

    @Test
    public void T2(){
        // TODO Auto-generated method stub
        String imgpath = "D:\\py\\My_work\\6_27_facebook\\7.jpg";
        String landmarkpath = "D:\\MyJava\\mylifeImg\\pythonModule\\python\\shape_predictor_68_face_landmarks.dat";
        try {
            String pyFilePath = "D:\\MyJava\\mylifeImg\\pythonModule\\python\\myDlib.py";
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

}
