package ppppp.util;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

/**
 * @author lppppp
 * @create 2021-02-09 8:44
 */
public class MyUtils {
    public static String move_file(String absoulteSrcpath, String absoulteDestDir){
        //判断当前文件夹下是否有重名的文件
        File file = new File(absoulteSrcpath);
        String newFileName = file.getName();
        String[] list = new File(absoulteDestDir).list();
        if(list.length > 0){
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
            System.out.println("移动照片： "+absoulteSrcpath+ "到文件夹 ："
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
}