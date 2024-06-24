import QtQuick 2.15
import QtQuick3D 1.15


Model {
    id: drone_63
    source: "qrc:/models/drone/meshes/drone_63.mesh"

    property alias diffuseColor: drone_63_Mat_material.diffuseColor



    DefaultMaterial {
        id: drone_63_Mat_material
        //diffuseMap: Texture {
        //    source: "qrc:/models/drone/maps/drone_063_baseColor.png"
        //    tilingModeHorizontal: Texture.Repeat
        //    tilingModeVertical: Texture.Repeat
        //}
    }
    materials: [
        drone_63_Mat_material
    ]
}

