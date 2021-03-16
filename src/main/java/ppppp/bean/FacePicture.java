package ppppp.bean;

public class FacePicture {
    private String picId;

    private Integer faceNum;

    private String faceIds;

    public FacePicture(String picId, Integer faceNum, String faceIds) {
        this.picId = picId;
        this.faceNum = faceNum;
        this.faceIds = faceIds;
    }

    public FacePicture() {
    }

    public String getPicId() {
        return picId;
    }

    public void setPicId(String picId) {
        this.picId = picId == null ? null : picId.trim();
    }

    public Integer getFaceNum() {
        return faceNum;
    }

    public void setFaceNum(Integer faceNum) {
        this.faceNum = faceNum;
    }

    public String getFaceIds() {
        return faceIds;
    }

    public void setFaceIds(String faceIds) {
        this.faceIds = faceIds == null ? null : faceIds.trim();
    }

    @Override
    public String toString() {
        return "FacePicture{" +
                "picId='" + picId + '\'' +
                ", faceNum=" + faceNum +
                ", faceIds='" + faceIds + '\'' +
                '}';
    }
}