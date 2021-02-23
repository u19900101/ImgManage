package ppppp.bean;

import java.util.ArrayList;

/**
 * @author lppppp
 * @create 2021-02-23 7:18
 */
public class nodes {

        String text;
        String herf;
        ArrayList<String> tags;
        ArrayList<nodes> nodes;

        @Override
        public String toString() {
            return "nodes{" +
                    "text='" + text + '\'' +
                    ", herf='" + herf + '\'' +
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

        public String getHerf() {
            return herf;
        }

        public void setHerf(String herf) {
            this.herf = herf;
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

        public nodes(String text, String herf, ArrayList<String> tags, ArrayList<ppppp.bean.nodes> nodes) {
            this.text = text;
            this.herf = herf;
            this.tags = tags;
            this.nodes = nodes;
        }

        public nodes(String text, String herf, ArrayList<String> tags) {
            this.text = text;
            this.herf = herf;
            this.tags = tags;
        }

        public nodes() {
        }
}
