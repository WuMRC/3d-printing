
public class Silicone {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		double FR;
		double FR2;

		double x = 1.19;
		double y = 0.1241;
		
		FR = feedRate(x, y);
		FR2 = feedRate2(x, y);

		
		System.out.println(FR);
		System.out.println(FR2);

		

	}
	
	public static double feedRate(double x, double y) {
		double answer = 0;
		answer = (17.94 - (13.55 * x) - (284.9 * y) + (146.3 * x * y) + (1007 * y * y));
		return answer;
	}
	
	public static double feedRate2(double x, double y) {
		double answer = 0;
		answer = (1.01 + (0.6865 * x) + (0.7689 * y) + (0.4631 * x * y) + (0.1435 * y * y));
		return answer;
	}

}
