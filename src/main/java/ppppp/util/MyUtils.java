package ppppp.util;

import org.junit.Test;
import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.MatOfByte;
import org.opencv.core.Size;
import org.opencv.imgcodecs.Imgcodecs;
import org.opencv.imgproc.Imgproc;

import java.io.*;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


/**
 * @author lppppp
 * @create 2021-02-09 8:44
 */
public class MyUtils {
    /** 均值哈希算法*/
    public static int[] aHash(String src){
        System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
        int[] res = new int[64];
        try {
            int width = 8;
            int height = 8;
            File srcPic = new File(src);
            Mat srcMat = null;

            if(MyUtils.isContainChinese(src)){
                FileInputStream inputStream = new FileInputStream(srcPic);
                byte[] byt = new byte[(int) srcPic.length()];
                int read = inputStream.read(byt);
                srcMat =  Imgcodecs.imdecode(new MatOfByte(byt), Imgcodecs.IMREAD_COLOR);
                // 不关闭的话 文件无法移动，尬。。。。
                inputStream.close();
            }else{
                srcMat = Imgcodecs.imread(src, Imgcodecs.IMREAD_ANYCOLOR);
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
    public static void setMapInfo(HashMap<String, Object> map, File uploadImgTemp, ArrayList<HashMap<String, Object>> successMapList, ArrayList<HashMap<String, Object>> failedMapList){

    }

    // 判断两者之间的4个方向转换是否都不同，若有一个完全相同则说明两张图相似
    public static double diff(int[] imgA, int[] imgB){
        int []diffCount = new int[4];
        diffCount[0] = caluDiff(imgB,imgA);
        if(diffCount[0]==64){
            return 1.0;
        }
        //第1次旋转90度后比较
        int[] turn90 = clockwise90Deg(imgA, 8);
        diffCount[1] = caluDiff(imgB,turn90);
        if(diffCount[1]==64){
            return 1.0;
        }
        //第2次旋转90度后比较
        int[] turn180 = clockwise90Deg(turn90, 8);
        diffCount[2] = caluDiff(imgB,turn180);
        if(diffCount[1]==64){
            return 1.0;
        }
        //第3次旋转90度后比较
        int[] turn270 = clockwise90Deg(turn180, 8);
        diffCount[3] = caluDiff(imgB,turn270);
        if(diffCount[3]==64){
            return 1.0;
        }

        return (diffCount[0]+diffCount[1]+diffCount[2]+diffCount[3])/64.0/4.0;
    }

    private static int caluDiff(int[] imgB, int[] imgA) {
        int diffCount = 0;
        for (int i = 0; i < imgB.length; i++) {
            if (imgB[i] == imgA[i]) {
                diffCount++;
            }
        }
        return diffCount;
    }

    public static int[] clockwise90Deg(int[] origin, int row){
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
    // 解决图片路径中包含中文
    public static boolean isContainChinese(String str) {
        Pattern p = Pattern.compile("[\u4e00-\u9fa5]");
        Matcher m = p.matcher(str);
        if (m.find()) {
            return true;
        }
        return false;
    }

    public static HashMap insertMsg(HashMap map, ArrayList<String> errorInfoList, String successMsg) {

        if(errorInfoList.size() == 0){
            map.put("status", "success");
            map.put("msg", successMsg);
        }else {
            map.put("status", "fail");
        }
        return map;
    }

    public static HashMap insertMsg(HashMap map, boolean isSucceed, String successMsg) {

        if(isSucceed){
            map.put("status", "success");
            map.put("msg", successMsg);
        }else {
            map.put("status", "fail");
            map.put("msg", "操作失败鸟");
        }
        return map;
    }
    public static boolean isImgType(String filetype){
        filetype = filetype.toLowerCase();
        return filetype.endsWith("jpg") || filetype.endsWith("png")|| filetype.endsWith("jpeg")|| filetype.endsWith("gif")|| filetype.endsWith("bmp");
    }
    public static boolean isVideoType(String filetype){
        filetype = filetype.toLowerCase();
        return filetype.endsWith("mp4") || filetype.endsWith("avi")|| filetype.endsWith("mov")|| filetype.endsWith("rmvb")|| filetype.endsWith("mpeg");
    }

    public static String move_file(String absoulteSrcPath, String absoulteDestDir){
        //判断当前文件夹下是否有重名的文件
        File file = new File(absoulteSrcPath);
        String newFileName = file.getName();
        String[] list = new File(absoulteDestDir).list();

        if(list!=null && list.length>0){
            ArrayList<String> fileList = new ArrayList<>();
            for (String s : list) {
                fileList.add(s);
            }
            if(fileList.contains(newFileName)){
                newFileName = MyUtils.createNewName(fileList,newFileName);
            }
        }
        boolean b = file.renameTo(new File(absoulteDestDir,newFileName));
        if(b){
            System.out.println("移动照片： "+absoulteSrcPath+ "到文件夹 ："
                    +absoulteDestDir +" 下");
        }else {
            System.out.println("移动图片失败.....");
        }
        return b?absoulteDestDir+"\\" + newFileName:null;
    }
    //生成不重名的文件名称
    public static String createNewName(ArrayList<String> fileList, String s) {

        String temp = s;

        int count =1;
        while (fileList.contains(temp)){
            temp = s.split("\\.")[0]+"_"+count+"."+s.split("\\.")[1];
            count++;
        }
        return temp;
    }
    public static String createNewName(String[] fileList, String s) {
        ArrayList<String> list = new ArrayList<>();
        for (String fileName : fileList) {
            if(fileName.contains(".")){
                list.add(fileName);
            }
        }
        String newName = createNewName(list, s);
        return newName;
    }

    public static void copyFileUsingFileStreams(String source, String dest) throws IOException {
        BufferedInputStream in = null;
        BufferedOutputStream out = null;
        try {
            in = new BufferedInputStream(new FileInputStream(new File(source)));
            out = new BufferedOutputStream(new FileOutputStream(new File(dest)));
            byte []buf = new byte[1024];
            int bytesRead;
            while ((bytesRead = in.read(buf))>0){
                out.write(buf,0,bytesRead);
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }finally {
            if (in!=null){
                in.close();
            }
           if(out!=null){
               out.close();
           }
        }
    }

    // 递归获取文件夹下的所有路径
    public static void getallpath(String dir, List<String> stringList){
        File dirfile = new File(dir);
        if(dirfile.isDirectory()){
            String[] list = dirfile.list();
            for (String s : list) {
                getallpath(dirfile.getAbsolutePath() + "\\" + s,stringList);
            }
        }else {
            // System.out.println(dir);
            stringList.add(dir);
        }
    }

    public static void creatDir(String destDir) {
        File file = new File(destDir);
        if(!file.exists() || !file.isDirectory()) {
            file.mkdirs();
        }
    }
    public static String intsToStr(int[] ints) {
        String s ="";
        for (int i = 0; i < ints.length; i++) {
            s+=ints[i];
        }
        return s;
    }

    // 将字符串拆为 字符数组
    public static int[] getIntNum(String str){
        int []num = new int [str.length()];
        for (int i = 0; i < str.length(); i++) {
            num[i] = Integer.parseInt(String.valueOf(str.charAt(i)));
        }
        return num;
    }

    public static boolean deleteFile(String ...absImgPath) {
        for (String path : absImgPath) {
            File img = new File(path);
            if(img.exists()){
                img.delete();
                System.out.println("已删除照片...."+path);
            }else {
                System.out.println("删除照片失败 .... "+path+" 不存在 ");
                return false;
            }
        }
        return true;
    }

    public static String createPicIdByAbsPath(String absImgPath) {
        return intsToStr(aHash(absImgPath));
    }


    public static String trimSubStr(String srcStr, String subStr) {
        if(srcStr.equalsIgnoreCase(subStr)){
            return "";
        }
        srcStr = ","+srcStr+",";
        String res= srcStr.replace( subStr + ",", "");
        return res.substring(1,res.length()-1);
    }

    //   将带有时间信息的照片名  作为照片的创建时间 写入数据库中
    //   有且仅有匹配3中格式
    // 2016-08-16T09:33:17
    /*
    1.mmexport1605932146267.jpg
    2.Screenshot_20201209_152638_com.eg.android.AlipayGphone
    3.wx_camera_1607081625719.jpg
    4.hdImg_a8464b03b3d71c7dc5a843a0d33e53831604568858570.jpg
    * */

    @Test
    public void T(){
        System.out.println(nameToCreateTime("hdImg_a8464b03b3d71c7dc5a843a0d33e53831604568858570.eg.android.AlipayGphone"));
    }
    public static String nameToCreateTime(String name){
        Pattern p = Pattern.compile("[0-9]{13}");
        Matcher m = p.matcher(name);
        if (m.find()) {
            String match = m.group();
            Long timeStamp = Long.valueOf(match);
            // 排除大于当前时间的字符
            if(timeStamp>System.currentTimeMillis()){
                return null;
            }
            return longToDateStr(timeStamp).split("\\.")[0];
        }

        Pattern p2 = Pattern.compile("[0-9]{8}_[0-9]{6}");
        Matcher m2 = p2.matcher(name);
        if (m2.find()) {
            String s = m2.group().replace("_", "");
            return s.substring(0,4)+"-"+s.substring(4,6)+"-"+s.substring(6,8)
                    +"T"+s.substring(8,10)+":"+s.substring(10,12)+":"+s.substring(12,14);
        }
        return null;
}

    public static String longToDateStr(long timeStamp){
        LocalDateTime localDateTime = Instant.ofEpochMilli(timeStamp).atZone(ZoneOffset.ofHours(8)).toLocalDateTime();
        return localDateTime.toString().split("\\.")[0];
    }

}
