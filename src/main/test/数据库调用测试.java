import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import ppppp.bean.Picture;
import ppppp.dao.FacePictureMapper;
import ppppp.dao.LabelMapper;
import ppppp.dao.PictureMapper;

import java.util.ArrayList;
import java.util.List;

/**
 * @author lppppp
 * @create 2021-03-16 16:23
 */
public class 数据库调用测试 {

    String baseDir = "D:\\MyJava\\mylifeImg\\target\\mylifeImg-1.0-SNAPSHOT\\";

    @Test
    public void T_(){
        List list = new ArrayList<>();
        list.add(5);
        List<Picture> pictures = pictureMapper().selectByLabelIdLike(list);
        System.out.println(pictures.size());

    }


    private FacePictureMapper facePictureMapper() {
        ApplicationContext context = new ClassPathXmlApplicationContext("spring.xml");
        return context.getBean(FacePictureMapper.class);
    }
    public PictureMapper pictureMapper(){
        ApplicationContext context = new ClassPathXmlApplicationContext("spring.xml");
        return context.getBean(PictureMapper.class);
    }

    public LabelMapper labelMapper(){
        ApplicationContext context = new ClassPathXmlApplicationContext("spring.xml");
        return context.getBean(LabelMapper.class);
    }

}
