package ppppp.bean;

public class Picture {
    private String pid;

    private String path;

    private String pname;

    private String pcreatime;

    private String gpsLongitude;

    private String gpsLatitude;

    private Integer pwidth;

    private Integer pheight;

    private Double psize;

    public Picture(String pid, String path, String pname, String pcreatime, String gpsLongitude, String gpsLatitude, Integer pwidth, Integer pheight, Double psize, String plabel, String pdesc) {
        this.pid = pid;
        this.path = path;
        this.pname = pname;
        this.pcreatime = pcreatime;
        this.gpsLongitude = gpsLongitude;
        this.gpsLatitude = gpsLatitude;
        this.pwidth = pwidth;
        this.pheight = pheight;
        this.psize = psize;
        this.plabel = plabel;
        this.pdesc = pdesc;
    }

    @Override
    public String toString() {
        return "Picture{" +
                "pid='" + pid + '\'' +
                ", path='" + path + '\'' +
                ", pname='" + pname + '\'' +
                ", pcreatime='" + pcreatime + '\'' +
                ", gpsLongitude='" + gpsLongitude + '\'' +
                ", gpsLatitude='" + gpsLatitude + '\'' +
                ", pwidth=" + pwidth +
                ", pheight=" + pheight +
                ", psize=" + psize +
                ", plabel='" + plabel + '\'' +
                ", pdesc='" + pdesc + '\'' +
                '}';
    }

    public Picture() {
    }

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

    public String getGpsLongitude() {
        return gpsLongitude;
    }

    public void setGpsLongitude(String gpsLongitude) {
        this.gpsLongitude = gpsLongitude == null ? null : gpsLongitude.trim();
    }

    public String getGpsLatitude() {
        return gpsLatitude;
    }

    public void setGpsLatitude(String gpsLatitude) {
        this.gpsLatitude = gpsLatitude == null ? null : gpsLatitude.trim();
    }

    public Integer getPwidth() {
        return pwidth;
    }

    public void setPwidth(Integer pwidth) {
        this.pwidth = pwidth;
    }

    public Integer getPheight() {
        return pheight;
    }

    public void setPheight(Integer pheight) {
        this.pheight = pheight;
    }

    public Double getPsize() {
        return psize;
    }

    public void setPsize(Double psize) {
        this.psize = psize;
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