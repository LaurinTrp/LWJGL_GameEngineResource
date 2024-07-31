package resources;

import java.awt.Image;
import java.awt.Toolkit;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.nio.ByteBuffer;

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
	
	public static File getResourceFile(String resFolder, String parentFolder, String fileName) {
		URL url = rl.getClass().getResource(resFolder + File.separator + parentFolder + File.separator + fileName);
		File file = new File(url.getFile());
		
		return file;
	}

	public static File getModelFile(String parent, String file) {
		return getResourceFile("models", parent, file);
	}
}