import org.junit.Test;
import org.opencv.core.*;
import org.opencv.imgcodecs.Imgcodecs;
import org.opencv.imgproc.Imgproc;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.LinkedList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @author lppppp
 * @create 2021-02-06 16:09
 */
/*
要在vm中添加这些
-Djava.library.path=D:\Javainstall\opencv\build\java\x64 -Djava.awt.headless=false
*
* */
public class 安装opencv {
    @Test
    public void T() throws IOException {
        //加载库
        System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
        // System.out.println("opencv = " + Core.VERSION);
        String p1 = "D:\\MyJava\\mylifeImg\\src\\main\\webapp\\img\\2021\\02\\05\\中文.jpg";
        String p2 = "D:\\MyJava\\mylifeImg\\src\\main\\webapp\\img\\m2.jpg";
        double imageSimilar = getImageSimilar(p1, p2);
        System.out.println(imageSimilar);

    }

    public double getImageSimilar(String imgpathA,String imgpathB) throws IOException {

        //加载库
        System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
        // System.out.println("opencv = " + Core.VERSION);
        Mat H1 = get(imgpathA);
        Mat H2 = get(imgpathB);
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
    public Mat get(String pathName) throws IOException {
        System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
        File srcPic = new File(pathName);
        Mat  srcMat = new Mat();
        if(isContainChinese(pathName)){
            FileInputStream inputStream = new FileInputStream(srcPic);
            byte[] byt = new byte[(int) srcPic.length()];
            int read = inputStream.read(byt);
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
        // similarity1 = cv2.compareHist(H1, H2, 0)
}
