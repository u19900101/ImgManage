package ppppp.bean;

public class Label {
    private Integer labelid;

    private String labelName;

    private Integer parentid;

    private String parentName;

    private Integer tags;

    private String href;

    private String icon;

    public Label() {
    }

    public Label(String labelName, Integer tags, String href) {
        this.labelName = labelName;
        this.tags = tags;
        this.href = href;
    }

    public Label(String labelName, Integer parentid, String parentName, Integer tags, String href) {
        this.labelName = labelName;
        this.parentid = parentid;
        this.parentName = parentName;
        this.tags = tags;
        this.href = href;
    }

    public Integer getLabelid() {
        return labelid;
    }

    public void setLabelid(Integer labelid) {
        this.labelid = labelid;
    }

    public String getLabelName() {
        return labelName;
    }

    public void setLabelName(String labelName) {
        this.labelName = labelName == null ? null : labelName.trim();
    }

    public Integer getParentid() {
        return parentid;
    }

    public void setParentid(Integer parentid) {
        this.parentid = parentid;
    }

    public String getParentName() {
        return parentName;
    }

    public void setParentName(String parentName) {
        this.parentName = parentName == null ? null : parentName.trim();
    }

    public Integer getTags() {
        return tags;
    }

    public void setTags(Integer tags) {
        this.tags = tags;
    }

    public String getHref() {
        return href;
    }

    public void setHref(String href) {
        this.href = href == null ? null : href.trim();
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon == null ? null : icon.trim();
    }
}