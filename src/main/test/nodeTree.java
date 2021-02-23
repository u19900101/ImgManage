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



    @Test
    public void T2(){
        ArrayList list = new ArrayList();
        for (int i = 0; i < 3; i++) {
            list.add(new nodes("text-"+i, "hrft-"+i, i));
            ArrayList clist = new ArrayList();
            for (int j = 10; j < 12; j++) {
                clist.add(new nodes("ctext-"+j, "chrft-"+j, j));
            }
            list.add(new nodes("f-"+i, "h-"+i, i, clist));
        }
        System.out.println(new Gson().toJson(list));
    }
}
class nodes{
    String text;
    String herf;
    String tags;
    ArrayList<nodes> nodes;


    public ArrayList<nodes> getNodes() {
        return nodes;
    }

    public void setNodes(ArrayList<nodes> nodes) {
        this.nodes = nodes;
    }

    public nodes(String text, String herf, int tags) {
        this.text = text;
        this.herf = herf;
        this.tags = "['"+tags+"']";
    }

    public nodes(String text, String herf, int tags, ArrayList<nodes> nodes) {
        this.text = text;
        this.herf = herf;
        this.tags = "['"+tags+"']";
        this.nodes = nodes;
    }

    public nodes() {
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getHerf() {
        return herf;
    }

    public void setHerf(String herf) {
        this.herf = herf;
    }

    public String getTags() {
        return tags;
    }

    public void setTags(int tags) {
        this.tags = "['"+tags+"']";
    }
}
