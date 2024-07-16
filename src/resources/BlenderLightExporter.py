import bpy
import mathutils
import xml.etree.ElementTree as ET

# Path to the output file
output_file_path = bpy.path.abspath("//lights_data.xml")

light_type_to_index = {
    'POINT': 2,
    'SUN': 1,
    'SPOT': 3,
    'AREA': 0
}

def vector_to_xml(element, vector, tag_name):
    vector_element = ET.SubElement(element, tag_name)
    vector_element.set("x", str(vector[0]))
    vector_element.set("y", str(vector[1]))
    vector_element.set("z", str(vector[2]))

def export_light_data(filepath):
    root = ET.Element("LightSourcesData")

    for obj in bpy.data.objects:
        if obj.type == 'LIGHT':
            light = obj.data

            # Get the local front vector (negative Z-axis)
            local_front_vector = mathutils.Vector((0, 0, -1))

            # Transform the local front vector to global space
            global_front_vector = obj.matrix_world.to_3x3() @ local_front_vector

            light_element = ET.SubElement(root, "Light")
            ET.SubElement(light_element, "Name").text = obj.name
            
            light_type_index = light_type_to_index[light.type]
            ET.SubElement(light_element, "Type").text = str(light_type_index)
            
            vector_to_xml(light_element, obj.location, "Location")
            vector_to_xml(light_element, obj.rotation_euler, "Rotation")
            vector_to_xml(light_element, global_front_vector, "GlobalFrontVector")
            
            color_element = ET.SubElement(light_element, "Color")
            color_element.set("r", str(light.color[0]))
            color_element.set("g", str(light.color[1]))
            color_element.set("b", str(light.color[2]))
            
            ET.SubElement(light_element, "Energy").text = str(light.energy)
            
            if light.type == 'POINT':
                ET.SubElement(light_element, "ConstantAttenuation").text = str(light.constant_coefficient)
                ET.SubElement(light_element, "LinearAttenuation").text = str(light.linear_coefficient)
                ET.SubElement(light_element, "QuadraticAttenuation").text = str(light.quadratic_coefficient)
            
            if light.type == 'SPOT':
                print(light.spot_size)
                ET.SubElement(light_element, "SpotSize").text = str(light.spot_size)
                ET.SubElement(light_element, "SpotBlend").text = str(light.spot_blend)


    tree = ET.ElementTree(root)
    tree.write(filepath, encoding='utf-8', xml_declaration=True)

# Call the function to export the light data
export_light_data(output_file_path)

print(f"Light data has been exported to {output_file_path}")