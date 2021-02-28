package ppppp.dao;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import ppppp.bean.Label;
import ppppp.bean.LabelExample;

public interface LabelMapper {
    long countByExample(LabelExample example);

    int deleteByExample(LabelExample example);

    int deleteByPrimaryKey(Integer labelid);

    int insert(Label record);

    int insertSelective(Label record);

    List<Label> selectByExample(LabelExample example);

    Label selectByPrimaryKey(Integer labelid);

    int updateByExampleSelective(@Param("record") Label record, @Param("example") LabelExample example);

    int updateByExample(@Param("record") Label record, @Param("example") LabelExample example);

    int updateByPrimaryKeySelective(Label record);

    int updateByPrimaryKey(Label record);

    int deleteByLabelName(String labelName);

    List<Label> selectByLabelName(String labelName);

    List<Label> selectByParentName(String labelName);
}