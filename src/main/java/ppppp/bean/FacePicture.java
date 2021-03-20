package ppppp.bean;

public class FacePicture {
    private String picId;

    private Integer faceNum;

    private String faceNameIds;

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

    public String getFaceNameIds() {
        return faceNameIds;
    }

    public void setFaceNameIds(String faceNameIds) {
        this.faceNameIds = faceNameIds == null ? null : faceNameIds.trim();
    }
}