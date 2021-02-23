package ppppp.bean;

import java.util.ArrayList;

/**
 * @author lppppp
 * @create 2021-02-23 7:18
 */
public class nodes {

        String text;
        String href;
        ArrayList<String> tags;
        ArrayList<nodes> nodes;

        @Override
        public String toString() {
            return "nodes{" +
                    "text='" + text + '\'' +
                    ", href='" + href + '\'' +
                    ", tags=" + tags +
                    ", nodes=" + nodes +
                    '}';
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

        public nodes(String text, String href, ArrayList<String> tags, ArrayList<ppppp.bean.nodes> nodes) {
            this.text = text;
            this.href = href;
            this.tags = tags;
            this.nodes = nodes;
        }

        public nodes(String text, String href, ArrayList<String> tags) {
            this.text = text;
            this.href = href;
            this.tags = tags;
        }

        public nodes() {
        }
}
