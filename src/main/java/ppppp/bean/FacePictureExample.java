package ppppp.bean;

import java.util.ArrayList;
import java.util.List;

public class FacePictureExample {
    protected String orderByClause;

    protected boolean distinct;

    protected List<Criteria> oredCriteria;

    public FacePictureExample() {
        oredCriteria = new ArrayList<Criteria>();
    }

    public void setOrderByClause(String orderByClause) {
        this.orderByClause = orderByClause;
    }

    public String getOrderByClause() {
        return orderByClause;
    }

    public void setDistinct(boolean distinct) {
        this.distinct = distinct;
    }

    public boolean isDistinct() {
        return distinct;
    }

    public List<Criteria> getOredCriteria() {
        return oredCriteria;
    }

    public void or(Criteria criteria) {
        oredCriteria.add(criteria);
    }

    public Criteria or() {
        Criteria criteria = createCriteriaInternal();
        oredCriteria.add(criteria);
        return criteria;
    }

    public Criteria createCriteria() {
        Criteria criteria = createCriteriaInternal();
        if (oredCriteria.size() == 0) {
            oredCriteria.add(criteria);
        }
        return criteria;
    }

    protected Criteria createCriteriaInternal() {
        Criteria criteria = new Criteria();
        return criteria;
    }

    public void clear() {
        oredCriteria.clear();
        orderByClause = null;
        distinct = false;
    }

    protected abstract static class GeneratedCriteria {
        protected List<Criterion> criteria;

        protected GeneratedCriteria() {
            super();
            criteria = new ArrayList<Criterion>();
        }

        public boolean isValid() {
            return criteria.size() > 0;
        }

        public List<Criterion> getAllCriteria() {
            return criteria;
        }

        public List<Criterion> getCriteria() {
            return criteria;
        }

        protected void addCriterion(String condition) {
            if (condition == null) {
                throw new RuntimeException("Value for condition cannot be null");
            }
            criteria.add(new Criterion(condition));
        }

        protected void addCriterion(String condition, Object value, String property) {
            if (value == null) {
                throw new RuntimeException("Value for " + property + " cannot be null");
            }
            criteria.add(new Criterion(condition, value));
        }

        protected void addCriterion(String condition, Object value1, Object value2, String property) {
            if (value1 == null || value2 == null) {
                throw new RuntimeException("Between values for " + property + " cannot be null");
            }
            criteria.add(new Criterion(condition, value1, value2));
        }

        public Criteria andPicIdIsNull() {
            addCriterion("pic_id is null");
            return (Criteria) this;
        }

        public Criteria andPicIdIsNotNull() {
            addCriterion("pic_id is not null");
            return (Criteria) this;
        }

        public Criteria andPicIdEqualTo(String value) {
            addCriterion("pic_id =", value, "picId");
            return (Criteria) this;
        }

        public Criteria andPicIdNotEqualTo(String value) {
            addCriterion("pic_id <>", value, "picId");
            return (Criteria) this;
        }

        public Criteria andPicIdGreaterThan(String value) {
            addCriterion("pic_id >", value, "picId");
            return (Criteria) this;
        }

        public Criteria andPicIdGreaterThanOrEqualTo(String value) {
            addCriterion("pic_id >=", value, "picId");
            return (Criteria) this;
        }

        public Criteria andPicIdLessThan(String value) {
            addCriterion("pic_id <", value, "picId");
            return (Criteria) this;
        }

        public Criteria andPicIdLessThanOrEqualTo(String value) {
            addCriterion("pic_id <=", value, "picId");
            return (Criteria) this;
        }

        public Criteria andPicIdLike(String value) {
            addCriterion("pic_id like", value, "picId");
            return (Criteria) this;
        }

        public Criteria andPicIdNotLike(String value) {
            addCriterion("pic_id not like", value, "picId");
            return (Criteria) this;
        }

        public Criteria andPicIdIn(List<String> values) {
            addCriterion("pic_id in", values, "picId");
            return (Criteria) this;
        }

        public Criteria andPicIdNotIn(List<String> values) {
            addCriterion("pic_id not in", values, "picId");
            return (Criteria) this;
        }

        public Criteria andPicIdBetween(String value1, String value2) {
            addCriterion("pic_id between", value1, value2, "picId");
            return (Criteria) this;
        }

        public Criteria andPicIdNotBetween(String value1, String value2) {
            addCriterion("pic_id not between", value1, value2, "picId");
            return (Criteria) this;
        }

        public Criteria andFaceNumIsNull() {
            addCriterion("face_num is null");
            return (Criteria) this;
        }

        public Criteria andFaceNumIsNotNull() {
            addCriterion("face_num is not null");
            return (Criteria) this;
        }

        public Criteria andFaceNumEqualTo(Integer value) {
            addCriterion("face_num =", value, "faceNum");
            return (Criteria) this;
        }

        public Criteria andFaceNumNotEqualTo(Integer value) {
            addCriterion("face_num <>", value, "faceNum");
            return (Criteria) this;
        }

        public Criteria andFaceNumGreaterThan(Integer value) {
            addCriterion("face_num >", value, "faceNum");
            return (Criteria) this;
        }

        public Criteria andFaceNumGreaterThanOrEqualTo(Integer value) {
            addCriterion("face_num >=", value, "faceNum");
            return (Criteria) this;
        }

        public Criteria andFaceNumLessThan(Integer value) {
            addCriterion("face_num <", value, "faceNum");
            return (Criteria) this;
        }

        public Criteria andFaceNumLessThanOrEqualTo(Integer value) {
            addCriterion("face_num <=", value, "faceNum");
            return (Criteria) this;
        }

        public Criteria andFaceNumIn(List<Integer> values) {
            addCriterion("face_num in", values, "faceNum");
            return (Criteria) this;
        }

        public Criteria andFaceNumNotIn(List<Integer> values) {
            addCriterion("face_num not in", values, "faceNum");
            return (Criteria) this;
        }

        public Criteria andFaceNumBetween(Integer value1, Integer value2) {
            addCriterion("face_num between", value1, value2, "faceNum");
            return (Criteria) this;
        }

        public Criteria andFaceNumNotBetween(Integer value1, Integer value2) {
            addCriterion("face_num not between", value1, value2, "faceNum");
            return (Criteria) this;
        }

        public Criteria andFaceIdsIsNull() {
            addCriterion("face_ids is null");
            return (Criteria) this;
        }

        public Criteria andFaceIdsIsNotNull() {
            addCriterion("face_ids is not null");
            return (Criteria) this;
        }

        public Criteria andFaceIdsEqualTo(String value) {
            addCriterion("face_ids =", value, "faceIds");
            return (Criteria) this;
        }

        public Criteria andFaceIdsNotEqualTo(String value) {
            addCriterion("face_ids <>", value, "faceIds");
            return (Criteria) this;
        }

        public Criteria andFaceIdsGreaterThan(String value) {
            addCriterion("face_ids >", value, "faceIds");
            return (Criteria) this;
        }

        public Criteria andFaceIdsGreaterThanOrEqualTo(String value) {
            addCriterion("face_ids >=", value, "faceIds");
            return (Criteria) this;
        }

        public Criteria andFaceIdsLessThan(String value) {
            addCriterion("face_ids <", value, "faceIds");
            return (Criteria) this;
        }

        public Criteria andFaceIdsLessThanOrEqualTo(String value) {
            addCriterion("face_ids <=", value, "faceIds");
            return (Criteria) this;
        }

        public Criteria andFaceIdsLike(String value) {
            addCriterion("face_ids like", value, "faceIds");
            return (Criteria) this;
        }

        public Criteria andFaceIdsNotLike(String value) {
            addCriterion("face_ids not like", value, "faceIds");
            return (Criteria) this;
        }

        public Criteria andFaceIdsIn(List<String> values) {
            addCriterion("face_ids in", values, "faceIds");
            return (Criteria) this;
        }

        public Criteria andFaceIdsNotIn(List<String> values) {
            addCriterion("face_ids not in", values, "faceIds");
            return (Criteria) this;
        }

        public Criteria andFaceIdsBetween(String value1, String value2) {
            addCriterion("face_ids between", value1, value2, "faceIds");
            return (Criteria) this;
        }

        public Criteria andFaceIdsNotBetween(String value1, String value2) {
            addCriterion("face_ids not between", value1, value2, "faceIds");
            return (Criteria) this;
        }
    }

    public static class Criteria extends GeneratedCriteria {

        protected Criteria() {
            super();
        }
    }

    public static class Criterion {
        private String condition;

        private Object value;

        private Object secondValue;

        private boolean noValue;

        private boolean singleValue;

        private boolean betweenValue;

        private boolean listValue;

        private String typeHandler;

        public String getCondition() {
            return condition;
        }

        public Object getValue() {
            return value;
        }

        public Object getSecondValue() {
            return secondValue;
        }

        public boolean isNoValue() {
            return noValue;
        }

        public boolean isSingleValue() {
            return singleValue;
        }

        public boolean isBetweenValue() {
            return betweenValue;
        }

        public boolean isListValue() {
            return listValue;
        }

        public String getTypeHandler() {
            return typeHandler;
        }

        protected Criterion(String condition) {
            super();
            this.condition = condition;
            this.typeHandler = null;
            this.noValue = true;
        }

        protected Criterion(String condition, Object value, String typeHandler) {
            super();
            this.condition = condition;
            this.value = value;
            this.typeHandler = typeHandler;
            if (value instanceof List<?>) {
                this.listValue = true;
            } else {
                this.singleValue = true;
            }
        }

        protected Criterion(String condition, Object value) {
            this(condition, value, null);
        }

        protected Criterion(String condition, Object value, Object secondValue, String typeHandler) {
            super();
            this.condition = condition;
            this.value = value;
            this.secondValue = secondValue;
            this.typeHandler = typeHandler;
            this.betweenValue = true;
        }

        protected Criterion(String condition, Object value, Object secondValue) {
            this(condition, value, secondValue, null);
        }
    }
}