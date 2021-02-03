package ppppp.bean;

import java.util.Date;
import java.util.List;

/**
 * @author lppppp
 * @create 2021-02-03 20:24
 */
public class MonthPicture {
    private Date month;
    private List<Picture> pictureList;

    public MonthPicture(Date month, List<Picture> pictureList) {
        this.month = month;
        this.pictureList = pictureList;
    }

    public Date getMonth() {
        return month;
    }

    public void setMonth(Date month) {
        this.month = month;
    }

    public void setPictureList(List<Picture> pictureList) {
        this.pictureList = pictureList;
    }

    public MonthPicture() {
    }

    @Override
    public String toString() {
        return "MonthPicture{" +
                "month=" + month +
                ", pictureList=" + pictureList +
                '}';
    }
}
