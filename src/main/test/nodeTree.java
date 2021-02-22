import com.google.gson.Gson;
import org.junit.Test;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * @author lppppp
 * @create 2021-02-22 22:02
 */
public class nodeTree {
    @Test
    public void T(){
       /*
        text: 'person',
        href: '#',
        tags: ['2'],
        nodes: [
          {
            text: 'jimi',
            href: 'https://google.com',
            tags: ['100000']
          },
          {
            text: 'jingjing',
            href: '#grandchild2',
            tags: ['0']
          }
        ]
      }  */




        HashMap<String,Object> nodeChild = new HashMap<>();
        nodeChild.put("text", "text1");
        nodeChild.put("href", "#");
        String s = "['"+100000+"']";
        System.out.println(s);
        nodeChild.put("tags", s);

        ArrayList childernList = new ArrayList();
        childernList.add(nodeChild);
        childernList.add(nodeChild);

        HashMap<String,Object> node = new HashMap<>();
        node.put("text", "text1");
        node.put("href", "#");
        node.put("tags", "['"+100000+"']");
        node.put("nodes", childernList);


        System.out.println(new Gson().toJson(node));
    }
}
