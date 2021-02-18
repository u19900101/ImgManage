package ppppp.dao;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import ppppp.bean.Picture;
import ppppp.bean.PictureExample;

public interface PictureMapper {
    long countByExample(PictureExample example);

    int deleteByExample(PictureExample example);

    int deleteByPrimaryKey(String path);

    int insert(Picture record);

    int insertSelective(Picture record);

    List<Picture> selectByExampleWithBLOBs(PictureExample example);

    List<Picture> selectByExample(PictureExample example);

    Picture selectByPrimaryKey(String path);

    int updateByExampleSelective(@Param("record") Picture record, @Param("example") PictureExample example);

    int updateByExampleWithBLOBs(@Param("record") Picture record, @Param("example") PictureExample example);

    int updateByExample(@Param("record") Picture record, @Param("example") PictureExample example);

    int updateByPrimaryKeySelective(Picture record);
    int MyUpdateByPrimaryKey(@Param("newPath")String newPath,@Param("record")Picture record);
    int updateByPrimaryKeyWithBLOBs(Picture record);

    int updateByPrimaryKey(String record);

}