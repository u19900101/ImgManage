package ppppp.bean;

public class Picture {
    private String pid;

    private String path;

    private String pname;

    private String pcreatime;

    private String plocal;

    private String plabel;

    private String pdesc;

    public String getPid() {
        return pid;
    }

    public void setPid(String pid) {
        this.pid = pid == null ? null : pid.trim();
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
}