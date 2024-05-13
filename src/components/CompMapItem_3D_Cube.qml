import QtQuick 2.15
import QtLocation 5.3
import QtQuick3D 1.15
import QtQuick.Controls 2.15

Comp__BASE_MapQuickItem {
    id: compMapItem_3D_Cube

    property real heading
    property bool isAlly
    property real tilt: 0

    zoomLevel: 2.1

    sourceItem: Item {
        property var coords

        width: compMapItem_3D_Cube.itemWidth
        height: compMapItem_3D_Cube.itemHeight

        Node {
            id: scene

            DirectionalLight {
                id: light_1

                eulerRotation{
                    x: -30
                    y: -70
                }
            }

            Model {
                id: modelCylinder
                position: Qt.vector3d(0,0,0)
                source: "#Cylinder"
                scale: Qt.vector3d(1,1,1)
                materials: [DefaultMaterial {
                        diffuseColor: "red"
                    }]

                eulerRotation{
                    x: 90 - compMapItem_3D_Cube.tilt
                }
            }

            PerspectiveCamera{
                id: cameraPerspective_2

                z: 200

                //PropertyAnimation on position.x {

                //    duration: inputUpdateInterval * 5

                //}
            }

        }

        View3D{
            anchors.fill: parent

            camera: cameraPerspective_2
            importScene: scene
        }

    }
}
