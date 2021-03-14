import com.alibaba.fastjson.JSONObject;
import com.google.gson.Gson;
import org.junit.Test;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * @author lppppp
 * @create 2021-03-11 9:17
 */
public class java调用python {

    @Test
    public void T_传字符串数组给python(){
        String s = "[[1019, 1538, 666, 665], [1401, 958, 799, 799]]";

    }
    public void  mysql(String sql,List argsList){
        boolean rs = false;
        String url = "jdbc:mysql://localhost:3306/t_imgs?useUnicode=true&characterEncoding=UTF-8&serverTimezone=CTT";//输入数据库名test
        String user = "root";//用户名
        String password = "kk";//密码
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");//指定连接类型
            conn = DriverManager.getConnection(url, user, password);//获取连接
            ps = conn.prepareStatement(sql);//准备执行语句
            for (int i = 1; i <= argsList.size();i++) {
                ps.setObject(i,argsList.get(i-1));
            }
            //显示数据
            try {
                rs = ps.execute();//执行语句
                /*List<String> colNames = getColNames(rs);
                for (int i = 0; i < colNames.size(); i++) {
                    System.out.print(colNames.get(i)+"\t");
                }
                System.out.println();
                rs = ps.executeQuery();//执行语句
                while(rs.next()){
                    for (int i = 0; i < colNames.size(); i++) {
                       System.out.print(rs.getObject(colNames.get(i))+"\t");
                    }
                    System.out.println();
                }*/
                //关闭连接
                // rs.close();
                conn.close();
                ps.close();
            }
            catch (SQLException e) {
                e.printStackTrace();
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Test
    public void T(){
        System.out.println(T_select());
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

            //faceNum 2
            //locations [[1019, 1538, 666, 665], [1401, 958, 799, 799]]
            //face_code [-0.022834885865449905, -0.013802939094603062, 0  128维
            //face_ids   [0, 1]
            //landmarks
            List  list = new ArrayList<>();

            list.add(imgpath);

            if ((line = in.readLine()) != null) {
                list.add(Integer.valueOf(line));
            }

            if ((line = in.readLine()) != null) {
                list.add(line);
                System.out.println(line);
                // String locations = "{'locations':'"+line+"'}";
                // JSONObject json = JSONObject.parseObject(locations);

            }

            if ((line = in.readLine()) != null) {
                list.add(line);
                System.out.println(line);
                // String face_ids = "{'face_ids':'"+line+"'}";
                // JSONObject json = JSONObject.parseObject(face_ids);
                // list.add(json);
            }

            if ((line = in.readLine()) != null) {
                list.add(line);
                System.out.println(line);
                // String landmarks = "{'landmarks':'"+line+"'}";
                // JSONObject json = JSONObject.parseObject(landmarks);
                // list.add(json);
            }
            if ((line = in.readLine()) != null) {
                String locations = "{'face_code':'"+line+"'}";
                System.out.println(line);
                // list.add(locations);
            }
            // 2.将信息存进 t_face_pic
            //pic_face
            // 1.pic_id  2.face_num    3.locations  4. face_ids    5.landmarks(72)
            String s2 = "INSERT INTO  t_face_pic (pic_id,face_num,locations,face_ids,landmarks) " +
                    "VALUES(?,?,?,?,?)";
            // // 1.将信息存进 t_face
            // // 1.face_id	2.face_name_id	3.face_code	 4.pic_id
            // // String s = "INSERT INTO  t_face (face_id,face_name_id,face_code,pic_id) " +
            // //         "VALUES(?,?,?,?)";
            //
            mysql(s2,list);



            in.close();
            proc.waitFor();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

    }

    @Test
    public void T_json(){
        String locations = "{'locations':'line'}";
        JSONObject json = JSONObject.parseObject(locations);
        System.out.println(json);
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
