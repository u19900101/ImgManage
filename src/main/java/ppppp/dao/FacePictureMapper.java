package ppppp.dao;

import org.apache.ibatis.annotations.Param;
import ppppp.bean.FacePicture;
import ppppp.bean.FacePictureExample;
import ppppp.bean.FacePictureWithBLOBs;

import java.util.List;

public interface FacePictureMapper {
    long countByExample(FacePictureExample example);

    int deleteByExample(FacePictureExample example);

    int deleteByPrimaryKey(String picId);

    int insert(FacePictureWithBLOBs record);

    int insertSelective(FacePictureWithBLOBs record);

    List<FacePictureWithBLOBs> selectByExampleWithBLOBs(FacePictureExample example);

    List<FacePicture> selectByExample(FacePictureExample example);

    FacePictureWithBLOBs selectByPrimaryKey(String picId);

    int updateByExampleSelective(@Param("record") FacePictureWithBLOBs record, @Param("example") FacePictureExample example);

    int updateByExampleWithBLOBs(@Param("record") FacePictureWithBLOBs record, @Param("example") FacePictureExample example);

    int updateByExample(@Param("record") FacePicture record, @Param("example") FacePictureExample example);

    int updateByPrimaryKeySelective(FacePictureWithBLOBs record);

    int updateByPrimaryKeyWithBLOBs(FacePictureWithBLOBs record);

    int updateByPrimaryKey(FacePicture record);
}