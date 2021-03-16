package ppppp.dao;

import org.apache.ibatis.annotations.Param;
import ppppp.bean.Picture;
import ppppp.bean.PictureExample;

import java.util.ArrayList;
import java.util.List;

public interface PictureMapper {
    long countByExample(PictureExample example);

    int deleteByExample(PictureExample example);

    int deleteByPrimaryKey(String pid);

    int insert(Picture record);

    int insertSelective(Picture record);

    List<Picture> selectByExampleWithBLOBs(PictureExample example);

    List<Picture> selectByExample(PictureExample example);

    Picture selectByPrimaryKey(String pid);

    int updateByExampleSelective(@Param("record") Picture record, @Param("example") PictureExample example);

    int updateByExampleWithBLOBs(@Param("record") Picture record, @Param("example") PictureExample example);

    int updateByExample(@Param("record") Picture record, @Param("example") PictureExample example);

    int updateByPrimaryKeySelective(Picture record);
    int MyUpdateByPrimaryKey(@Param("newPath")String newPath,@Param("record")Picture record);
    int updateByPrimaryKeyWithBLOBs(Picture record);

    int updateByPrimaryKey(Picture picture);

    ArrayList<Picture> selectByLabelNameLike(List labelNameList);

    ArrayList<Picture> selectByLabelIdLike(List labelIdList);

    ArrayList<Picture> selectByLabelName(String labelName);

    ArrayList<Picture> selectLabelIsNull();
}