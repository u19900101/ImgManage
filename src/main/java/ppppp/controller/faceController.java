package ppppp.controller;

import com.google.gson.Gson;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * @author lppppp
 * @create 2021-03-11 13:01
 */
@Controller
@RequestMapping("/face")
public class faceController {
    @ResponseBody
    @RequestMapping("/t")
    public String test(){
       return T_select();
    }

    public String T_select(){
        String sql = "select * from t_face_pic";
        ArrayList<HashMap> hashMaps = mysqlSelect(sql);
        return new Gson().toJson(hashMaps);
    }
    public ArrayList<HashMap>  mysqlSelect(String sql){
        ResultSet rs = null;
        String url = "jdbc:mysql://localhost:3306/t_imgs?useUnicode=true&characterEncoding=UTF-8&serverTimezone=CTT";//输入数据库名test
        String user = "root";//用户名
        String password = "kk";//密码
        Connection conn = null;
        PreparedStatement ps = null;
        ArrayList<HashMap> mapList = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");//指定连接类型
            conn = DriverManager.getConnection(url, user, password);//获取连接
            ps = conn.prepareStatement(sql);//准备执行语句

            //显示数据

            rs = ps.executeQuery();//执行语句
            List<String> colNames = getColNames(rs);
            rs = ps.executeQuery();//执行语句
            while(rs.next()){
                HashMap map = new HashMap<>();
                for (int i = 0; i < colNames.size(); i++) {
                    map.put(colNames.get(i),rs.getObject(colNames.get(i)));
                }
                mapList.add(map);
            }
        }
        catch (Exception e) {
            //关闭连接
            try {
                rs.close();
                conn.close();
                ps.close();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

        }
        return mapList;
    }
    private static List<String> getColNames(ResultSet rs) throws SQLException {
        ResultSetMetaData metaData = rs.getMetaData();
        int count = metaData.getColumnCount();
        // System.out.println("getCatalogName(int column) 获取指定列的表目录名称。"+metaData.getCatalogName(1));
        // System.out.println("getColumnClassName(int column) 构造其实例的 Java 类的完全限定名称。"+metaData.getColumnClassName(1));
        // System.out.println("getColumnCount()  返回此 ResultSet 对象中的列数。"+metaData.getColumnCount());
        // System.out.println("getColumnDisplaySize(int column) 指示指定列的最大标准宽度，以字符为单位. "+metaData.getColumnDisplaySize(1));
        // System.out.println("getColumnLabel(int column) 获取用于打印输出和显示的指定列的建议标题。 "+metaData.getColumnLabel(1));
        // System.out.println("getColumnName(int column)  获取指定列的名称。"+metaData.getColumnName(1));
        // System.out.println("getColumnType(int column) 获取指定列的 SQL 类型。 "+metaData.getColumnType(1));
        // System.out.println("getColumnTypeName(int column) 获取指定列的数据库特定的类型名称。 "+metaData.getColumnTypeName(1));
        // System.out.println("getPrecision(int column)  获取指定列的指定列宽。 "+metaData.getPrecision(1));
        // System.out.println("getScale(int column) 获取指定列的小数点右边的位数。 "+metaData.getScale(1));
        // System.out.println("getSchemaName(int column) 获取指定列的表模式。 "+metaData.getSchemaName(1));
        // System.out.println("getTableName(int column) 获取指定列的名称。 "+metaData.getTableName(1));
        List<String> colNameList = new ArrayList<String>();
        for(int i = 1; i<=count; i++){
            colNameList.add(metaData.getColumnName(i));
        }
        // System.out.println(colNameList);
//		rs.close();
        rs.first();
        return colNameList;
    }

    @ResponseBody
    @RequestMapping("/getFace")
    public String getFace(String imgPath,HttpServletRequest request){
        // String imgpath = "D:\\MyJava\\mylifeImg\\pythonModule\\face\\6.jpg";
        String baseDir = "D:\\MyJava\\mylifeImg\\target\\mylifeImg-1.0-SNAPSHOT\\";
        String landmarkpath = "D:\\MyJava\\mylifeImg\\pythonModule\\python\\shape_predictor_68_face_landmarks.dat";
        HashMap map = new HashMap();
        try {
            String pyFilePath = "D:\\MyJava\\mylifeImg\\pythonModule\\python\\myDlib.py";
            String[] args = new String[] { "python",pyFilePath ,baseDir+imgPath,landmarkpath};
            Process proc = Runtime.getRuntime().exec(args);// 执行py文件

            BufferedReader in = new BufferedReader(new InputStreamReader(proc.getInputStream()));
            String line = null;

            line = in.readLine();
            if(line != null){
                map.put("faceNum", Integer.valueOf(line));
                line = in.readLine();
            }

            if(line != null){
                // map.put("rects", line.replaceAll("\\s+", " ").trim().replaceAll(" ", ","));
                map.put("rects", line.trim().replaceAll(" ", ""));
                line = in.readLine();
            }

            if(line != null){
                // map.put("points", line.replaceAll("\\s+", " ").trim().replaceAll(" ", ","));
                map.put("points", line.trim().replaceAll(" ", ""));
            }
            in.close();
            proc.waitFor();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        map.put("imgPath", imgPath.replaceAll("\\\\", "/"));
        request.getSession().setAttribute("map", map);
        return  new Gson().toJson(map);
    }

}
