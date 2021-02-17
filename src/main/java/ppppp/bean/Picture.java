package ppppp.bean;

public class Picture {
    private String path;

    private String pid;

    private String pname;

    private String pcreatime;

    private String gpsLongitude;

    private String gpsLatitude;

    private Integer pwidth;

    private Integer pheight;

    private Double psize;

    private String plabel;

    private String pdesc;

    @Override
    public String toString() {
        return "Picture{" +
                "path='" + path + '\'' +
                ", pid='" + pid + '\'' +
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

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path == null ? null : path.trim();
    }

    public String getPid() {
        return pid;
    }

    public void setPid(String pid) {
        this.pid = pid == null ? null : pid.trim();
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