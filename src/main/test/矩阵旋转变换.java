import org.junit.Test;

/**
 * @author lppppp
 * @create 2021-02-07 9:17
 */
public class 矩阵旋转变换 {
// 1	2	3
// 4	5	6
// 7	8	9

// 7	4	1
// 8	5	2
// 9	6	3
    @Test
    public void T(){
        int []orgin = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16};
        int[][] ints = clockwise90Deg(orgin, 4);
       for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            System.out.print(ints[i][j]+"\t");
        }
        System.out.println();
    }
    }


    public int[][] clockwise90Deg(int []origin, int row){

        int col = origin.length/row;
        int [][]list = new int[row][col];
        for (int i = 0; i < row; i++) {
            for (int j = 0; j < col; j++) {
                list[i][j] = origin[i*col+j];
            }
        }
        int [][]newlist = new int[col][row];
        for (int i = 0; i < row; i++) {
            for (int j = 0; j < col; j++) {
                newlist[j][row-1-i] = list[i][j];
            }
        }
       return newlist;
    }
}
