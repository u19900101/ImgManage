package ppppp.dao;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import ppppp.bean.Face;
import ppppp.bean.FaceExample;

public interface FaceMapper {
    long countByExample(FaceExample example);

    int deleteByExample(FaceExample example);

    int deleteByPrimaryKey(Integer faceId);

    int insert(Face record);

    int insertSelective(Face record);

    List<Face> selectByExampleWithBLOBs(FaceExample example);

    List<Face> selectByExample(FaceExample example);

    Face selectByPrimaryKey(Integer faceId);

    int updateByExampleSelective(@Param("record") Face record, @Param("example") FaceExample example);

    int updateByExampleWithBLOBs(@Param("record") Face record, @Param("example") FaceExample example);

    int updateByExample(@Param("record") Face record, @Param("example") FaceExample example);

    int updateByPrimaryKeySelective(Face record);

    int updateByPrimaryKeyWithBLOBs(Face record);

    int updateByPrimaryKey(Face record);
}