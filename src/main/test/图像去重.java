import com.drew.imaging.ImageProcessingException;
import org.junit.Test;
import org.opencv.core.*;
import org.opencv.imgcodecs.Imgcodecs;
import org.opencv.imgproc.Imgproc;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static ppppp.controller.PictureController.*;
import static ppppp.service.PictureService.createImgFile;
import static ppppp.service.PictureService.isImgType;

/**
 * @author lppppp
 * @create 2021-02-06 16:09
 */
/*
要在vm中添加这些
-Djava.library.path=D:\Javainstall\opencv\build\java\x64 -Djava.awt.headless=false
*
* */
public class 图像去重 {

    @Test
    public void T_testAll() throws ParseException, IOException, ImageProcessingException {
        String destDir = "D:\\MyJava\\mylifeImg\\src\\main\\webapp\\img";
        File srcFile = new File("C:\\Users\\Administrator\\Desktop\\中文.jpg");

        //在整个数据库中进行 照片去重检查
        ArrayList<String> stringList = new ArrayList<>();
        getallpath(destDir,stringList);
        boolean exist = false;
        //判断图片在数据库中是否存在相似的照片
        long l = System.currentTimeMillis();
        int count = 0;
        for (String s : stringList) {
            File fileExist = new File(s);
            String fileType = s.substring(s.indexOf(".")+1);
            if(isImgType(fileType)){
                double imageSimilar = getImageSimilar(fileExist.getAbsolutePath(), srcFile.getAbsolutePath());
                System.out.println("图片 ："+s+"与原图的相似度为： "+imageSimilar);
                count++;
                if(imageSimilar>IMAGE_SIMILARITY){
                    exist = true;
                    break;
                }
            }
        }

        //存在
        if(exist){
            System.out.println("存在相同照片.....");
        }
        // 不存在，按照片信息建立文件夹上传
        else {
            createImgFile(srcFile);
        }

        System.out.println(("耗时："+(System.currentTimeMillis()-l)/1000)+" s 共检测照片 "+count+" 张");
    }
    @Test
    public void T_move_file(){
        String srcpath ="C:\\Users\\Administrator\\Desktop\\中文.jpg";
        String destDir = "D:\\MyJava\\mylifeImg\\src\\main\\webapp\\img\\2019";
        boolean b = move_file(srcpath, destDir);
        System.out.println(b);
    }
    @Test
    public void T() throws IOException {
        //加载库
        System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
        // System.out.println("opencv = " + Core.VERSION);
        // String p1 = "D:\\MyJava\\mylifeImg\\src\\main\\webapp\\img\\2021\\02\\06\\中文.jpg";
        // String p2 = "D:\\MyJava\\mylifeImg\\src\\main\\webapp\\img\\m2.jpg";
        // 测试图片颜色分布相似度大于 95% 的情况
        // String p1 = "D:\\MyJava\\mylifeImg\\src\\main\\webapp\\testDupImage\\1.jpg";
        // String p2 = "D:\\MyJava\\mylifeImg\\src\\main\\webapp\\testDupImage\\2.jpg";
        // 两张相似的图
        String p1 = "D:\\MyJava\\mylifeImg\\src\\main\\webapp\\testDupImage\\m3.jpg";
        String p2 = "D:\\MyJava\\mylifeImg\\src\\main\\webapp\\testDupImage\\m2.jpg";

        // 测试图片 经过微信压缩的相似度
        // String p1 = "D:\\MyJava\\mylifeImg\\src\\main\\webapp\\testDupImage\\m1.jpg";
        // String p2 = "D:\\MyJava\\mylifeImg\\src\\main\\webapp\\testDupImage\\m2.jpg";

        // 测试图片 经过旋转的相似度
        // String p1 = "D:\\MyJava\\mylifeImg\\src\\main\\webapp\\testDupImage\\m22.jpg";
        // String p2 = "D:\\MyJava\\mylifeImg\\src\\main\\webapp\\testDupImage\\m2.jpg";
        // String p1 = "D:\\MyJava\\mylifeImg\\src\\main\\webapp\\testDupImage\\1.jpg";
        // String p2 = "D:\\MyJava\\mylifeImg\\src\\main\\webapp\\testDupImage\\11.jpg";
        double imageSimilar = getImageSimilar(p1, p2);
        System.out.println(imageSimilar);

    }

    // 对图像的旋转 很好解决
    public static double getImageSimilar(String imgpathA,String imgpathB) throws IOException {
        //加载库
        System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
        // System.out.println("opencv = " + Core.VERSION);
        return diff(aHash(imgpathA), aHash(imgpathB));
    }
    // 解决图片路径中包含中文
    public static boolean isContainChinese(String str) {
        Pattern p = Pattern.compile("[\u4e00-\u9fa5]");
        Matcher m = p.matcher(str);
        if (m.find()) {
            return true;
        }
        return false;
    }

    /** 均值哈希算法*/
    public static int[] aHash(String src){
        System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
        int[] res = new int[64];
        try {
            int width = 8;
            int height = 8;
            File srcPic = new File(src);
            Mat  srcMat = new Mat();
            if(isContainChinese(src)){
                FileInputStream inputStream = new FileInputStream(srcPic);
                byte[] byt = new byte[(int) srcPic.length()];
                int read = inputStream.read(byt);
                srcMat =  Imgcodecs.imdecode(new MatOfByte(byt), Imgcodecs.IMREAD_COLOR);
                // 不关闭的话 文件无法移动，尬。。。。
                inputStream.close();
            }else{
                srcMat = Imgcodecs.imread(srcPic.getAbsolutePath(), Imgcodecs.IMREAD_ANYCOLOR);
            }

            Mat resizeMat = new Mat();
            Imgproc.resize(srcMat,resizeMat, new Size(width, height),0,0);
            // 将缩小后的图片转换为64级灰度（简化色彩）
            int total = 0;
            int[] ints = new int[64];

            int index = 0;
            for (int i = 0;i < height;i++){
                for (int j = 0;j < width;j++){
                    int gray = gray(resizeMat.get(i, j));
                    ints[index++] = gray;
                    total = total + gray;
                }
            }
            // 计算灰度平均值
            int grayAvg = total / (width * height);
            // 比较像素的灰度
            for (int i =0;i<ints.length;i++) {
                if (ints[i] >= grayAvg) {
                    res[i] = 1;
                } else {
                    res[i] = 0;
                }
            }

        }catch (Exception e){
            e.printStackTrace();
        }
        return res;
    }
    private static int gray(double[] bgr) {
        int rgb = (int) (bgr[2] * 77 + bgr[1] * 151 + bgr[0] * 28) >> 8;
        int gray = (rgb << 16) | (rgb << 8) | rgb;
        return gray;
    }

    // 判断两者之间的4个方向转换是否都不同，若有一个完全相同则说明两张图相似
    public  static double diff(int[] ints1,int[] ints2){
        int []diffCount = new int[4];
        diffCount[0] = caluDiff(ints1,ints2);
        if(diffCount[0]==64){
            return 1.0;
        }
        //第1次旋转90度后比较
        int[] turn90 = clockwise90Deg(ints2, 8);
        diffCount[1] = caluDiff(ints1,turn90);
        if(diffCount[1]==64){
            return 1.0;
        }
        //第2次旋转90度后比较
        int[] turn180 = clockwise90Deg(turn90, 8);
        diffCount[2] = caluDiff(ints1,clockwise90Deg(turn180, 8));
        if(diffCount[1]==64){
            return 1.0;
        }
        //第3次旋转90度后比较
        int[] turn270 = clockwise90Deg(turn180, 8);
        diffCount[3] = caluDiff(ints1,clockwise90Deg(turn270, 8));
        if(diffCount[3]==64){
            return 1.0;
        }

        return (diffCount[0]+diffCount[1]+diffCount[2]+diffCount[3])/64.0/4.0;
    }

    private static int caluDiff(int[] ints1, int[] ints2) {
        int diffCount = 0;
        for (int i = 0; i < ints1.length; i++) {
            if (ints1[i] == ints2[i]) {
                diffCount++;
            }
        }
        return diffCount;
    }

    public static int[] clockwise90Deg(int []origin, int row){
        int col = origin.length/row;
        int [][]list = new int[row][col];
        for (int i = 0; i < row; i++) {
            for (int j = 0; j < col; j++) {
                list[i][j] = origin[i*col+j];
            }
        }
        int []newlist = new int[col*row];
        for (int i = 0; i < row; i++) {
            for (int j = 0; j < col; j++) {
                newlist[j*col+row-1-i] = list[i][j];
            }
        }
        return newlist;
    }

    // 直方图方法  不能解决 同分布问题
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
}
