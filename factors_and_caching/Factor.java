import java.util.Arrays;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.io.File;
import java.io.FileReader;
import java.io.BufferedReader;
import java.io.FileWriter;
import java.io.BufferedWriter;
import java.io.IOException;
import java.util.Iterator;

public class Factor {

	private static final String CACHE_FILENAME = ".factor_cache";
	private static final String CACHE_DELIM = "~";

	// A cache for storing previously computed outputs
	private static Map<String, String> cache = initializeCache();

	/*
	 * Initializes the cache from a file
	 */
	public static Map<String, String> initializeCache() {
		Map<String, String> cacheMap = new HashMap<String, String>();

		File cacheFile = new File(CACHE_FILENAME);
		if(cacheFile.exists()) {
			BufferedReader in;
			try {
				String line;
				in = new BufferedReader(new FileReader(cacheFile));
				while((line = in.readLine()) != null) {
					// Pairs stored in format "[10, 5, 2, 20]~{10: [5,2], 5: [], 2: [], 20: [10,5,2]}"
					String[] pair = line.split(CACHE_DELIM, 2);
					cacheMap.put(pair[0], pair[1]);
				}
				in.close();
			} catch(IOException e) {
				System.err.println("Error reading cache file");
				e.printStackTrace();
			}
		}

		// Save the cache back to a file when program exits
		Runtime.getRuntime().addShutdownHook(new Thread() {
			public void run() {
				saveCache();
			}
		});

		return cacheMap;
	}	

	/*
	 * Saves the cache to a file
	 */
	public static void saveCache() {
		if(cache == null || cache.isEmpty()) return;

		File cacheFile = new File(CACHE_FILENAME);
		BufferedWriter out;
		try {
			out = new BufferedWriter(new FileWriter(cacheFile));
			Iterator it = cache.entrySet().iterator();
			// Save each input/output pair to a line in the cache file
			while(it.hasNext()) {
				Map.Entry toCache = (Map.Entry) it.next();
				// Pairs stored in format "[10, 5, 2, 20]~{10: [5,2], 5: [], 2: [], 20: [10,5,2]}"
				out.write(toCache.getKey() + CACHE_DELIM + toCache.getValue() + "\n");
			}
			out.close();
		} catch(IOException e) {
			System.out.println("Error writing to cache file");
			e.printStackTrace();
		}
	}

	/*
	 * A main method to demonstrate factoring function
	 */
	public static void main(String[] args) {
		int[] array;
		if(args.length > 0) {
			// Parse command line arguments
			array = new int[args.length];
			for(int i = 0; i < args.length; i++) {
				array[i] = Integer.parseInt(args[i]);
			}
		} else {
			// Use some example values if non provided
			System.out.println("Using default values: [10, 5, 2, 20]");
			System.out.println("For non-default values, enter a list of" +
								" integers as arguments, e.g. " +
								" java Factor 21 7 8 19 32\n");
			array = new int[]{10,5,2,20};
		}
		
		System.out.println(getFactorsString(array));
	}

	/*
	 * Computes the factors of each int in array, 
	 * and returns the result in a formatted String
	 */
	public static String getFactorsString(int[] array) {
		// Check if this array's output has been computed already
		String key = Arrays.toString(array);
		String cached = cache.get(key);
		if(cached != null) {
			System.out.println("Cache Hit!");
			return cached;
		}

		String output = outputString(array, getFactors(array));

		// Cache the output
		cache.put(key, output);
		return output;
	}
	
	/*
	 * Computes the factors of each int in array
	 */
	public static List<List<Integer>> getFactors(int[] array) {
		// An arraylist of factors for each int in the given array
		List<List<Integer>> output = new ArrayList<List<Integer>>();

		// Loop through array and check factors for each int in array
		for(int currIdx = 0; currIdx < array.length; currIdx++) {
			output.add(new ArrayList<Integer>());
			for(int i = 0; i < array.length; i++) {
				// We don't want to add the number as a factor of itself
				if(i == currIdx) continue;

				// Check if array[i] is a factor of array[currIdx]
				if(array[currIdx] % array[i] == 0)
					output.get(currIdx).add(new Integer(array[i])); // Found a factor
			}
		}

		return output;
	}

	/*
	 * Formats the output of getFactors() into a String
	 * like "{10: [5,2], 5: [], 2: [], 20: [10,5,2]}"
	 */
	private static String outputString(int[] array, List<List<Integer>> output) {
		StringBuilder out = new StringBuilder();
		out.append("{");
		for(int i = 0; i < output.size(); i++) {
			if(i != 0) out.append(", ");
			out.append("" + array[i] + ": [");
			for(int j = 0; j < output.get(i).size(); j++) {
				if(j != 0) out.append(",");
				out.append(output.get(i).get(j));
			}
			out.append("]");
		}
		out.append("}");
		return out.toString();
	}
}
