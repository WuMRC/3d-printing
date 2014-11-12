import java.math.BigDecimal;
import java.math.RoundingMode;

public class pyramid {

	public static void main(String[] args) {

		double xCoordinate = 0; // Initialize X coordinate
		double yCoordinate = 0; // Initialize Y coordinate
		double zCoordinate = 0; // Initialize Z coordinate
		double feedrate = 2500; // Initialize machine feed rate (25 millimeters per second)
		boolean xDirection = false; // used to print radiator pattern in x
		boolean yDirection = false; // used to print radiator pattern in y
		boolean grid = false; // used to cross-hatch pattern
		double xOffset = 150; // set X offset
		double yOffset = 150; // set y offset
		double zOffset = 0.2; // set Z offset
		double objectWidth = 2.87;  // set object width (X direction, millimeters)
		double objectLength = 2.87;  // set object length (Y direction, millimeters)
		double objectHeight = 2.87;  // set object height (Z direction, millimeters)
		double nozzleDiameter = 0.41; // Set spacing between layers in all directions in millimeters
		double xAxisLength = xOffset + objectWidth; // Set maximum size of X axis
		double yAxisLength = yOffset + objectLength; // Set maximum size of Y axis
		double zAxisLength = zOffset + objectHeight; // Set maximum size of Z axis

		for (double k = zOffset; k <= zAxisLength; k += nozzleDiameter) { // Loop for object height
			zCoordinate = round(k, 2); // round up to 2 decimal paces to prevent errors

			for (double i = xOffset; i <= xAxisLength; i += nozzleDiameter) {  // Loop for object width
				i = round(i, 2); // round up to 2 decimal paces to prevent errors

				for (double j = yOffset; j <= (yAxisLength); j += nozzleDiameter) {   // Loop for object length
					j = round(j, 2); // round up to 2 decimal paces to prevent errors

					if(xDirection == false) {
						xCoordinate = round(i, 2);
					}
					else {
						xCoordinate = round(interpolate(i, xAxisLength, xOffset), 2);
					}

					if(yDirection == false) {
						yCoordinate = round(j, 2);
					}
					else {yCoordinate = round(interpolate(j, yAxisLength, yOffset), 2);
					}
					
					feedrate = round(feedrate, 2);
					
					// print only when y axis is about to change
					
					if(i == xOffset) { // make sure the first term is never inverted
						if(j == yOffset || j == yAxisLength) {
							System.out.println("G1" + " F" + feedrate +" X" + xCoordinate + " Y" + yCoordinate + " Z" + zCoordinate + " E0");
						}
					}
					
					// Consecutive loops should have axis inverted for hatch pattern
					
					if(i > xOffset) {
						
						// Just switch X and Y to coordinates cause cross-hatch pattern
						
						if((grid == false) && (j == yOffset || j == yAxisLength)) {
							System.out.println("G1" + " F" + feedrate +" X" + xCoordinate + " Y" + yCoordinate + " Z" + zCoordinate + " E0");
						}
						if((grid == true) && (j == yOffset || j == yAxisLength)) {
							System.out.println("G1" + " F" + feedrate +" X" + yCoordinate + " Y" + xCoordinate + " Z" + zCoordinate + " E0");
						}
					}
				}
				yDirection = !yDirection; // Flip Y direction so printer does not print the same line twice	
			}
			xDirection = !xDirection; // Flip X direction so printer does not print the same line twice
			
			grid = !grid; // At the end of "i" loop, switch grid so cross-hatch pattern can be printed
			
			// Un-comment the lines below to print a pyramid
			//xAxisLength = xAxisLength -  nozzleDiameter;
			//yAxisLength = yAxisLength - nozzleDiameter;
		}


	}
	// METHODS BEGIN HERE
	public static double interpolate (double number, double width, double offset) {
		number = (width - number) + offset;
		number = round(number, 2);
		return number;
	}

	public static double round(double value, int places) {
		if (places < 0) throw new IllegalArgumentException();
		BigDecimal bd = new BigDecimal(value);
		bd = bd.setScale(places, RoundingMode.HALF_UP);
		return bd.doubleValue();
	}
}
