package ppppp.bean;

public class Face {
    private Integer faceId;

    private Integer faceNameId;

    private String picId;

    private String faceEncoding;

    public Face(Integer faceNameId, String picId, String faceEncoding) {
        this.faceNameId = faceNameId;
        this.picId = picId;
        this.faceEncoding = faceEncoding;
    }

    public Face() {
    }

    public Integer getFaceId() {
        return faceId;
    }

    public void setFaceId(Integer faceId) {
        this.faceId = faceId;
    }

    public Integer getFaceNameId() {
        return faceNameId;
    }

    public void setFaceNameId(Integer faceNameId) {
        this.faceNameId = faceNameId;
    }

    public String getPicId() {
        return picId;
    }

    public void setPicId(String picId) {
        this.picId = picId == null ? null : picId.trim();
    }

    public String getFaceEncoding() {
        return faceEncoding;
    }

    public void setFaceEncoding(String faceEncoding) {
        this.faceEncoding = faceEncoding == null ? null : faceEncoding.trim();
    }
}