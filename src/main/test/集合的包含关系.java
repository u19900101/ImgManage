import org.junit.Test;
import ppppp.bean.Picture;

import java.util.ArrayList;

/**
 * @author lppppp
 * @create 2021-03-07 21:33
 */
public class 集合的包含关系 {
    @Test
    public void T(){
        Picture picture = new Picture("1");

        Picture picture2 = new Picture("1");


        ArrayList<Picture> list = new ArrayList<>();
        list.add(picture2);

        System.out.println(list.contains(picture));
    }
}
