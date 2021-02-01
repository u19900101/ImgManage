package ppppp.bean;

public class Picture {
    private Integer pid;
    private String path;
    private String pname;
    private String pcreatime;
    private String plocal;
    private String plabel;
    private String pdesc = "还未设置";

    public Picture(String path, String pname, String pcreatime, String plocal, String plabel, String pdesc) {
        this.path = path;
        this.pname = pname;
        this.pcreatime = pcreatime;
        this.plocal = plocal;
        this.plabel = plabel;
        this.pdesc = pdesc;
    }

    public Picture() {
    }

    public Integer getPid() {
        return pid;
    }

    public void setPid(Integer pid) {
        this.pid = pid;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path == null ? null : path.trim();
    }

    public String getPname() {
        return pname;
    }

    public void setPname(String pname) {
        this.pname = pname == null ? null : pname.trim();
    }

    public String getPcreatime() {
        return pcreatime;
    }

    public void setPcreatime(String pcreatime) {
        this.pcreatime = pcreatime == null ? null : pcreatime.trim();
    }

    public String getPlocal() {
        return plocal;
    }

    public void setPlocal(String plocal) {
        this.plocal = plocal == null ? null : plocal.trim();
    }

    public String getPlabel() {
        return plabel;
    }

    public void setPlabel(String plabel) {
        this.plabel = plabel == null ? null : plabel.trim();
    }

    public String getPdesc() {
        return pdesc;
    }

    public void setPdesc(String pdesc) {
        this.pdesc = pdesc == null ? null : pdesc.trim();
    }

    @Override
    public String toString() {
        return "Picture{" +
                "pid=" + pid +
                ", path='" + path + '\'' +
                ", pname='" + pname + '\'' +
                ", pcreatime='" + pcreatime + '\'' +
                ", plocal='" + plocal + '\'' +
                ", plabel='" + plabel + '\'' +
                ", pdesc='" + pdesc + '\'' +
                '}';
    }
}