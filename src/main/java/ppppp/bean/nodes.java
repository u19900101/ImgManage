package ppppp.bean;

import java.util.ArrayList;

/**
 * @author lppppp
 * @create 2021-02-23 7:18
 */
public class nodes {
        int id;
        String text;
        String href;
        ArrayList<String> tags;
        ArrayList<nodes> nodes;


    public nodes(Integer id,String text, String href, ArrayList<String> tags, ArrayList<ppppp.bean.nodes> nodes) {
        this.id = id;
        this.text = text;
        this.href = href;
        this.tags = tags;
        this.nodes = nodes;
    }

    public nodes(Integer id,String text, String href, ArrayList<String> tags) {
        this.id = id;
        this.text = text;
        this.href = href;
        this.tags = tags;
    }


    @Override
    public String toString() {
        return "nodes{" +
                "id=" + id +
                ", text='" + text + '\'' +
                ", href='" + href + '\'' +
                ", tags=" + tags +
                ", nodes=" + nodes +
                '}';
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getHref() {
        return href;
    }

    public void setHref(String href) {
        this.href = href;
    }

    public String getText() {
            return text;
        }

        public void setText(String text) {
            this.text = text;
        }

        public String gethref() {
            return href;
        }

        public void sethref(String href) {
            this.href = href;
        }

        public ArrayList<String> getTags() {
            return tags;
        }

        public void setTags(ArrayList<String> tags) {
            this.tags = tags;
        }

        public ArrayList<ppppp.bean.nodes> getNodes() {
            return nodes;
        }

        public void setNodes(ArrayList<ppppp.bean.nodes> nodes) {
            this.nodes = nodes;
        }


        public nodes() {
        }
}
