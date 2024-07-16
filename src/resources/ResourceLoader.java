package resources;

import java.awt.Image;
import java.awt.Toolkit;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.UUID;

import org.apache.commons.io.IOUtils;
import org.lwjgl.BufferUtils;

public class ResourceLoader {

	static ResourceLoader rl = new ResourceLoader();

	public static Image loadImage(String imageName) {
		return Toolkit.getDefaultToolkit().getImage(rl.getClass().getResource("images" + File.separator + imageName));
	}

	public static InputStream loadFileAsStream(String fileName) {
		InputStream is = rl.getClass().getResourceAsStream(fileName);
		return is;
	}

	public static InputStream loadShader(String parent, String fileName) {
		InputStream is = rl.getClass().getResourceAsStream("shader" + File.separator + parent + File.separator + fileName);
		if (is == null) {
			System.err.println("Shader: " + parent + File.separator + fileName + " not found!");
		}
		return is;
	}

	public static String loadShaderAsString(String parent, String fileName) {
		try {
			return new String(loadShader(parent, fileName).readAllBytes());
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	public static ByteBuffer loadTexture(String fileName) {
		InputStream imageFile = rl.getClass().getResourceAsStream("textures" + File.separator + fileName);
		byte[] imageData;
		try {
			imageData = IOUtils.toByteArray(imageFile);
			ByteBuffer imageBuffer = BufferUtils.createByteBuffer(imageData.length);
			imageBuffer.put(imageData);
			imageBuffer.flip();
			return imageBuffer;
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
	}

	public static ArrayList<String> loadObjFile(String parentFolder, String fileName) {
		InputStream modelFile = ResourceLoader.class
				.getResourceAsStream("models" + File.separator + parentFolder + File.separator + fileName);
		try {
			String content = new String(modelFile.readAllBytes());
			ArrayList<String> list = new ArrayList<>();
			for (String line : content.split("\n")) {
				list.add(line);
			}
			return list;
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	public static ArrayList<String> loadMaterialFile(String parentFolder, String fileName) {
		InputStream modelFile = ResourceLoader.class.getResourceAsStream("models" + File.separator + parentFolder + File.separator + fileName);
		try {
			String content = new String(modelFile.readAllBytes());
			ArrayList<String> list = new ArrayList<>();
			for (String line : content.split("\n")) {
				list.add(line);
			}
			return list;
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	public static File getFile(String parent, String file) {
		try (InputStream is = rl.getClass().getResourceAsStream(parent + File.separator + file);) {
			return getFileFromStream(is);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	public static File getFileFromStream(InputStream is) {

		File tempFolder = new File("temp");
		tempFolder.mkdir();
		File tempFile = new File(tempFolder, UUID.randomUUID().toString());

		try (OutputStream os = new FileOutputStream(tempFile);) {
			tempFile.createNewFile();
			
			byte[] buffer = is.readAllBytes();

			os.write(buffer);
		} catch (IOException e) {
			e.printStackTrace();
		}

		return tempFile;
	}

	public static File getModelFile(String parent, String file) {
		try (InputStream is = rl.getClass()
				.getResourceAsStream("models" + File.separator + parent + File.separator + file);) {

			return getFileFromStream(is);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	public static void clear() {
		File file = new File("temp");
		deleteChildFiles(file);
		file.delete();
	}

	private static void deleteChildFiles(File root) {
		if (root.isDirectory()) {
			for (File file : root.listFiles()) {
				deleteChildFiles(file);
			}
		}
		root.delete();
	}

//	public static void main(String[] args) {
//		System.out.println(loadTexture("skybox/back.png"));
//
//	}

}