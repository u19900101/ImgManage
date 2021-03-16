import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import ppppp.bean.Picture;
import ppppp.dao.PictureMapper;

import java.util.ArrayList;

/**
 * @author lppppp
 * @create 2021-03-16 16:23
 */
public class 数据库调用测试 {
    @Test
    public void T_(){

        ArrayList<Picture> pictureArrayList = getpictureMapper().selectLabelIsNull();
        pictureArrayList.addAll(getpictureMapper().selectByLabelName(""));
        System.out.println(pictureArrayList.size());

    }
    public PictureMapper getpictureMapper(){
        ApplicationContext context = new ClassPathXmlApplicationContext("spring.xml");
        return context.getBean(PictureMapper.class);
    }
}
