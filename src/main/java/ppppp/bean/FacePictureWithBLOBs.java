package ppppp.bean;

public class FacePictureWithBLOBs extends FacePicture {
    private String locations;

    private String landmarks;

    private String faceEncodings;

    private String facePaths;

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

    public String getFaceEncodings() {
        return faceEncodings;
    }

    public void setFaceEncodings(String faceEncodings) {
        this.faceEncodings = faceEncodings == null ? null : faceEncodings.trim();
    }

    public String getFacePaths() {
        return facePaths;
    }

    public void setFacePaths(String facePaths) {
        this.facePaths = facePaths == null ? null : facePaths.trim();
    }

    public String getFaceIds() {
        return super.getFaceNameIds();
    }
}