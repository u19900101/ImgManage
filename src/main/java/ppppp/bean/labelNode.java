package ppppp.bean;

import java.util.ArrayList;

/**
 * @author lppppp
 * @create 2021-02-23 7:18
 */
public class labelNode {

    String id;
    String parent;
    String text;
    String tags;
    String href;
    String icon;

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public labelNode(String id, String parent, String text, String tags, String href, String icon) {
        this.id = id;
        this.parent = parent;
        this.text = text;
        this.tags = tags;
        this.href = href;
        this.icon = icon;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getParent() {
        return parent;
    }

    public void setParent(String parent) {
        this.parent = parent;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getTags() {
        return tags;
    }

    public void setTags(String tags) {
        this.tags = tags;
    }

    public String getHref() {
        return href;
    }

    public void setHref(String href) {
        this.href = href;
    }

    public labelNode(String id, String parent, String text, String tags, String href) {
        this.id = id;
        this.parent = parent;
        this.text = text;
        this.tags = tags;
        this.href = href;
    }

    public labelNode() {
    }
}
