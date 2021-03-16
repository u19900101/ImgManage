package ppppp.bean;

public class FacePictureWithBLOBs extends FacePicture {
    private String locations;

    private String landmarks;

    public FacePictureWithBLOBs(String picId, Integer faceNum, String faceIds) {
        super(picId, faceNum, faceIds);
    }

    @Override
    public String toString() {
        return "FacePictureWithBLOBs{" +
                "picId='" + super.getPicId() + '\'' +
                ", faceNum=" + super.getFaceNum() +
                ", faceIds='" + super.getFaceIds() + '\'' +
                "locations='" + locations + '\'' +
                ", landmarks='" + landmarks + '\'' +
                '}';
    }

    public FacePictureWithBLOBs(String picId, Integer faceNum, String faceIds, String locations, String landmarks) {
        super(picId, faceNum, faceIds);
        this.locations = locations;
        this.landmarks = landmarks;
    }

    public FacePictureWithBLOBs(String locations, String landmarks) {
        this.locations = locations;
        this.landmarks = landmarks;
    }

    public String getLocations() {
        return locations;
    }

    public void setLocations(String locations) {
        this.locations = locations == null ? null : locations.trim();
    }

    public String getLandmarks() {
        return landmarks;
    }

    public void setLandmarks(String landmarks) {
        this.landmarks = landmarks == null ? null : landmarks.trim();
    }
}