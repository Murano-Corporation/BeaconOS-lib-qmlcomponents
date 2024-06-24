import QtQuick 2.15
import QtQuick3D 1.15
import QtQuick3D.Materials 1.15
import QtQuick.Controls 2.15
import Qt.labs.qmlmodels 1.0


FocusScope {
    id: screen_3DViewer_Root

    focus: true

    property Model selectedTarget: model_NULL

    property real moveSpeed: 10
    property real sensitivity: 0.2 // Mouse sensitivity for camera rotation

    // Camera rotation variables
    property bool mousePressed: false
    property real mouseX: 0
    property real mouseY: 0
    property real lastMouseX: 0
    property real lastMouseY: 0
    property real yaw: 0
    property real pitch: 0
    property bool mouseYawInverted: true
    property bool mousePitchInverted: true


    // Pinch gesture variables
    property real initialPinchDistance: 0
    property real initialCameraDistance: 0

    property var inputVector3: {"x":0, "y":0, "z":0}


    Model{
        id: model_NULL
    }

    onInputVector3Changed: {
        moveCamera(inputVector3.x, inputVector3.y, inputVector3.z)
    }


    function moveCamera(x, y, z) {
        var cameraDirection = Qt.vector3d(0, 0, 0)


        if (x < 0) {
            cameraDirection = cameraDirection.plus(Qt.vector3d(camera.forward.x, camera.forward.y, camera.forward.z))
        }

        if (x >  0) {
            cameraDirection = cameraDirection.plus(Qt.vector3d(-camera.forward.x, -camera.forward.y, -camera.forward.z))
        }

        if (y > 0) {
            cameraDirection = cameraDirection.plus(Qt.vector3d(-camera.right.x, -camera.right.y, -camera.right.z))
        }

        if (y < 0) {
            cameraDirection = cameraDirection.plus(Qt.vector3d(camera.right.x, camera.right.y, camera.right.z))
        }

        if (z !== 0) {
            cameraDirection = cameraDirection.plus(Qt.vector3d(0, z, 0))
        }

        cameraDirection.normalized()

        camera.position.x += cameraDirection.x * moveSpeed
        camera.position.y += cameraDirection.y * moveSpeed
        camera.position.z += cameraDirection.z * moveSpeed
    }


    function rotateCamera(dx, dy) {
        yaw += (dx * (mouseYawInverted ? -1 : 1)) * sensitivity
        pitch += (dy * (mousePitchInverted ? -1 : 1)) * sensitivity

        // Clamp pitch to avoid flipping over
        if (pitch > 89.0) pitch = 89.0
        if (pitch < -89.0) pitch = -89.0

        // Calculate new rotation
        camera.eulerRotation.x = pitch
        camera.eulerRotation.y = yaw
    }

    View3D{
        id : view
        anchors.fill: parent

        environment:     SceneEnvironment{
            id: sceneEnvironemtn
            clearColor: "skyblue"
            backgroundMode: SceneEnvironment.Color
        }

        PerspectiveCamera {
            id: camera
            position: Qt.vector3d(0, -200, 300)


        }

        // Number animations for smooth camera movement
        NumberAnimation {
            id: xAnim
            target: camera
            property: "position.x"
            duration: 200
            easing.type: Easing.InOutQuad
        }

        NumberAnimation {
            id: yAnim
            target: camera
            property: "position.y"
            duration: 200
            easing.type: Easing.InOutQuad
        }

        NumberAnimation {
            id: zAnim
            target: camera
            property: "position.z"
            duration: 200
            easing.type: Easing.InOutQuad
        }

        DirectionalLight {
            eulerRotation.x: -90
        }

        //DirectionalLight {
        //    eulerRotation.y: 90
        //}


        //DirectionalLight {
        //    eulerRotation.x: -30
        //    eulerRotation.y: -70
        //}

        //DirectionalLight {
        //    eulerRotation.x: 30
        //    eulerRotation.y: 70
        //}

        //DirectionalLight {
        //    eulerRotation.x: -30
        //    eulerRotation.y: 70
        //}

        //DirectionalLight {
        //    eulerRotation.x: 30
        //    eulerRotation.y: -70
        //}

        Repeater3D{


            model: ListModel{
                ListElement{
                    name: "Test"
                    type: "Lego Tractor"
                    position_x: 0
                    position_y: -200
                    position_z: 0
                    scale: 80
                    source:"file:///home/murano/.balsam_output/lego_base/meshes/defaultobject.mesh"
                    ally: true

                }

                ListElement{
                    name: "Test"
                    type: "Drone"
                    position_x: 100
                    position_y: 100
                    position_z: 100
                    scale: 1
                    source:"file:///home/murano/.balsam_output/lego_base/meshes/defaultobject.mesh"
                    ally: false

                }

                ListElement{
                    name: "Test"
                    type: "Drone"
                    position_x: 0
                    position_y: 100
                    position_z: 0
                    scale: 1
                    source:"file:///home/murano/.balsam_output/lego_base/meshes/defaultobject.mesh"
                    ally: true

                }
            }


            delegate:

            DelegateChooser{
                id: delegateChooser

                role: "type"

                DelegateChoice{
                    roleValue: "Drone"

                    delegate: Drone_063 {

                        property bool selected: screen_3DViewer_Root.selectedTarget === this

                        property var meta_data: {
                            "name": model.name,
                            "type": model.type
                        }

                        diffuseColor: model.ally ? "green" : "red"

                        position: Qt.vector3d(model.position_x, model.position_y, model.position_z)
                        scale: Qt.vector3d(model.scale, model.scale, model.scale)
                        //source: model.source
                        pickable: true

                    }
                }

                DelegateChoice{
                    roleValue: "Lego Tractor"

                    delegate: Model {

                        property bool selected: screen_3DViewer_Root.selectedTarget === this

                        property var meta_data: {
                            "name": model.name,
                            "type": model.type
                        }

                        position: Qt.vector3d(model.position_x, model.position_y, model.position_z)
                        scale: Qt.vector3d(model.scale, model.scale, model.scale)
                        source: model.source
                        pickable: true


                        DefaultMaterial {
                            id: defaultMaterial_material

                            property color color_default: "#ffFFFFFF"
                            property color color_selected: "#ff00ff00"
                            property color color_unselected: "#ff999999"

                            diffuseColor: parent.selected ? color_selected : (screen_3DViewer_Root.selectedTarget !== model_NULL ? color_unselected : color_default)
                        }


                        materials: [
                            defaultMaterial_material,

                        ]
                    }
                }

            }
        }



        MouseArea{
            anchors.fill: parent

            acceptedButtons: Qt.RightButton
            propagateComposedEvents: true

            onPressed: {
                screen_3DViewer_Root.mousePressed = true
                screen_3DViewer_Root.mouseX = mouse.x
                screen_3DViewer_Root.mouseY = mouse.y
                screen_3DViewer_Root.lastMouseX = mouse.x
                screen_3DViewer_Root.lastMouseY = mouse.y
            }

            onReleased: {
                screen_3DViewer_Root.mousePressed = false
            }

            onPositionChanged: {
                if (screen_3DViewer_Root.mousePressed) {
                    var dx = mouse.x - screen_3DViewer_Root.lastMouseX
                    var dy = mouse.y - screen_3DViewer_Root.lastMouseY
                    screen_3DViewer_Root.lastMouseX = mouse.x
                    screen_3DViewer_Root.lastMouseY = mouse.y

                    screen_3DViewer_Root.rotateCamera(dx, dy)
                }
            }
        }

        MouseArea{
            anchors.fill: parent

            propagateComposedEvents: true

            acceptedButtons: Qt.LeftButton

            onClicked: {

                var pick_result = view.pick( mouse.x, mouse.y )



                var picked = pick_result.objectHit
                if( !picked )
                    return


                if( picked === screen_3DViewer_Root.selectedTarget )
                {
                    screen_3DViewer_Root.selectedTarget = model_NULL
                    return
                }

                //console.log("Selected Item:")
                //console.log("--- " + picked.meta_data.type)
                //console.log("--- " + picked.meta_data.name)

                camera.lookAt(picked)

                screen_3DViewer_Root.selectedTarget = picked

            }
        }
    }

    Keys.onPressed: {
        var input_now = screen_3DViewer_Root.inputVector3

        if (event.key === Qt.Key_W) {
            input_now.x -= 1
        } else if (event.key === Qt.Key_S) {
            input_now.x += 1
        } else if (event.key === Qt.Key_A) {
            input_now.y += 1
        } else if (event.key === Qt.Key_D) {
            input_now.y -= 1
        } else if (event.key === Qt.Key_Space) {
            input_now.z += 1
        } else if (event.key === Qt.Key_Control) {
            input_now.z -= 1
        }

        screen_3DViewer_Root.inputVector3 = input_now
    }

    Keys.onReleased: {
        var input_now = screen_3DViewer_Root.inputVector3

        if (event.key === Qt.Key_W) {
            input_now.x += 1
        } else if (event.key === Qt.Key_S) {
            input_now.x -= 1
        } else if (event.key === Qt.Key_A) {
            input_now.y -= 1
        } else if (event.key === Qt.Key_D) {
            input_now.y += 1
        } else if (event.key === Qt.Key_Space) {
            input_now.z -= 1
        } else if (event.key === Qt.Key_Control) {
            input_now.z += 1
        }

        screen_3DViewer_Root.inputVector3 = input_now
    }

    Component.onCompleted: {
        screen_3DViewer_Root.forceActiveFocus()
    }

}
