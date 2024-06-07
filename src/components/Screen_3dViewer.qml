import QtQuick 2.0
import QtQuick3D 1.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1

import QtQuick.Scene3D 2.0
import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Extras 2.0

Item {
    id: screen_3DViewer_Root

    property string modelPath_Current: ""

    //property alias modelPath: sceneLoader.source

    readonly property real panSpeed_X: 10
    property real inputMove_Strength: 0.0
    property real inputLook_Strength: 0.0
    property int sceneLoaderStatus: 0
    onSceneLoaderStatusChanged: {
        //console.log("Root scene loader status changed to : " + sceneLoaderStatus)

        progress_Load.visible = (sceneLoaderStatus !== SceneLoader.Ready)
    }

    readonly property real panSpeed_Y: 10
    readonly property real rotSpeed_H: 2
    readonly property real rotSpeed_V: 2

    readonly property int inputUpdateInterval: 25

    //property var scene: new Entity()

    //Component.onCompleted: {
    //    // Create a model loader and load the obj file
    //    var modelLoader = QmlObjectLoader()
    //    modelLoader.source = "my_obj_file.obj"

    //    // Create a material and set its color
    //    var material = new QPhongMaterial()
    //    material.diffuse = Qt.rgba(1.0, 0.0, 0.0, 1.0)

    //    // Add the model and material to the scene
    //    scene.addComponent(modelLoader)
    //    modelLoader.model.addComponent(material)

    //    // Add the scene to the root item
    //    root.addChild(scene)
    //}

    onModelPath_CurrentChanged: {

        loaderSceneEntity.active = false
        if( modelPath_Current === "")
        {
            return
        }
        progress_Load.visible = true
        tmrDelay.start()
    }

    Timer{
        id: tmrDelay

        interval: 250

        onTriggered: loaderSceneEntity.active = true
    }

    Item {
        id: areaControls_Top

        anchors{
            top: parent.top
            left: parent.left
            right: parent.right

        }

        height: 60

        Row{
            id: row_ControlsTop

            anchors.fill: parent
            spacing: 30
            RoundButton{
                id: btnCpatureVideo

                height: parent.height

                text: "Video"


                onClicked: loaderCameraPopup.active = true
            }

            RoundButton
            {
                id: btnModelPicker

                text: "Pick .obj"

                height: parent.height

                onClicked: {
                    //console.log("Setting folder to: " + StandardPaths.writableLocation(StandardPaths.DocumentsLocation))
                    //fileDlg_Picker.folder = StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
                    fileDlg_Picker.open()
                }
            }

            CompLabel{
                id: lbl_ModelCurrent_Name

                visible: modelPath_Current !== ""

                height: parent.height

                text: "Current Model: " + modelPath_Current
            }
        }
    }

    FileDialog{
        id: fileDlg_Picker

        currentFile: screen_3DViewer_Root.modelPath_Current
        //onCurrentFileChanged: {
        //    console.log("Current File Changed to: " + currentFile)
        //}

        folder: "file:///home/murano/.nerf_models"
        //onFolderChanged:{
        //    console.log("Foilder now: " + folder)
        //}

        nameFilters: ["*.obj"]

        onAccepted: {
            //console.log("ACCEPTED: setting modelPAth_Current to: " + fileDlg_Picker.currentFile)
            screen_3DViewer_Root.modelPath_Current = fileDlg_Picker.currentFile
            //mainScene3d.update()
        }
    }


    Loader{
        id: loaderSceneEntity

        asynchronous: true
        active: false

        anchors{
            top: areaControls_Top.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom

            margins: 40
        }

        sourceComponent:    Scene3D
        {
            id:mainScene3d

            focus: true
            hoverEnabled: true

            aspects: ["input", "logic","render"]

            cameraAspectRatioMode: Scene3D.AutomaticAspectRatio

            Entity
            {
                id: sceneRoot

                Camera
                {
                    id: camera
                    projectionType: CameraLens.PerspectiveProjection
                    fieldOfView: 30
                    aspectRatio: 16/9
                    nearPlane : 0.1
                    farPlane : 100.0
                    position: Qt.vector3d( 10.0, 0.0, 10.0 )
                    upVector: Qt.vector3d( 0.0, 1.0, 0.0 )
                    viewCenter: Qt.vector3d( 0.0, 0.0, 0.0 )
                }

                OrbitCameraController
                {
                    camera: camera
                }

                components: [
                    RenderSettings
                    {
                        activeFrameGraph: ForwardRenderer
                        {
                            clearColor:"#333333"
                            camera: camera
                        }
                    },
                    InputSettings
                    {
                    }
                ]
                Entity
                {
                    id: monkeyEntity
                    components: [

                        SceneLoader
                        {
                            id: sceneLoader

                            source: screen_3DViewer_Root.modelPath_Current

                            onStatusChanged: {
                                //console.log("SceneLoader Status now: " + status)
                                screen_3DViewer_Root.sceneLoaderStatus = status

                                //if( status === SceneLoader.Ready )
                                //{
                                //    console.log("Scene Loader loaded:")
                                //    console.log(sceneLoader.entityNames())

                                //    var e = sceneLoader.entity("defaultobject")

                                //    console.log("---Default Object")
                                //    console.log("------childNodes: " + e.childNodes.length)
                                //    console.log("------Data: " + e.data.length)
                                //    console.log("------PropTrackOverr: " + e.propertyTrackingOverrides)

                                //}
                            }
                        }
                    ]

                    //onComponentsChanged: {
                    //    console.log("Components changed to: ")

                    //    foreach(entity, components)
                    //    {
                    //        console.log("--- Data: " + entity.data)
                    //    }
                    //}
                }



            }



        }


    }

    Loader{
        id: loaderCameraPopup

        active: false
        anchors{
            top: areaControls_Top.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom

            margins: 40
        }
        sourceComponent: Screen_Camera_Delta{

            mode_current: mode_video
            isOverlayMode: true
            beaconId: AssetInfo.beaconID
            assetId: AssetInfo.assetName

            onCancelClicked: loaderCameraPopup.active = false

            onViewFullGalleryClicked: {
                comHealthDashboardContent.setSystemTypeSelection('Camera Gallery')
                loaderCameraPopup.active = false
            }


        }
    }

    ProgressBar{
        id: progress_Load


        anchors{
            bottom: parent.bottom
            right: parent.right

            margins: 20
        }

        from: 0.0
        to: 1.0
        //value: loaderSceneEntity.progress
        //onValueChanged: {
        //    console.log("Progres value now: " + value)
        //}

        indeterminate: true
    }


    Item {
        id: __materialLibrary__
    }

    // /// CAMERAS
    //Node {
    //    id: sceneStandalone

    //    // / LIGHTING
    //    DirectionalLight {
    //        id: light_1

    //        eulerRotation{
    //            x: -30
    //            y: -70
    //        }
    //    }

    //    // / MODELS
    //    Model {
    //        id: modelCylinder
    //        position: Qt.vector3d(0,-200,0)
    //        source: "file:///home/murano/.nerf_models/braingear.stl"
    //        scale: Qt.vector3d(2,0.2,1)
    //        materials: [DefaultMaterial {
    //                diffuseColor: "red"
    //            }]
    //    }

    //    Model {
    //        id: modelSphere
    //        position: Qt.vector3d(0,150,0)
    //        source: "#Sphere"

    //        materials: [DefaultMaterial {
    //                diffuseColor: "blue"
    //            }]

    //        SequentialAnimation on y {
    //            loops: Animation.Infinite

    //            NumberAnimation {
    //                duration: 3000
    //                to: -150
    //                from: 150
    //                easing.type: Easing.InQuad
    //            }

    //            NumberAnimation {
    //                duration: 3000
    //                to: 150
    //                from: -150
    //                easing.type: Easing.OutQuad
    //            }
    //        }
    //    }

    //    Model {
    //        id: modelGround
    //        source: "#Cube"
    //        position: Qt.vector3d(8,modelCylinder.y + modelCylinder.bounds.minimum.y ,1)
    //        scale: Qt.vector3d(8,0.2,8)
    //        materials: [
    //            DefaultMaterial{
    //                diffuseColor: "brown"
    //            }
    //        ]
    //    }


    //    Node{
    //        id: nodeAnimCamPerspective_1

    //        PerspectiveCamera{
    //            id: cameraPerspective_1
    //            z: 600
    //        }

    //        PropertyAnimation on eulerRotation.x {
    //            loops: Animation.Infinite
    //            duration: 5000
    //            to: -360
    //            from: 0
    //        }
    //    }

    //    PerspectiveCamera{
    //        id: cameraPerspective_2
    //        z: 600

    //        // PropertyAnimation on position.x {

    //           // duration: inputUpdateInterval * 5

    //        // }
    //    }

    //    Node {

    //        PerspectiveCamera {
    //            id: cameraPerspective_3
    //            x: 500
    //            eulerRotation.y: 90



    //        }
    //        PropertyAnimation on eulerRotation.y {
    //            loops: Animation.Infinite
    //            duration: 5000
    //            to: 0
    //            from: -360
    //        }
    //    }

    //}



    //OrthographicCamera{
    //    id: cameraOrtho
    //    x: -600
    //    eulerRotation.y: -90
    //}

    // /// VIEWS
    //Rectangle{
    //    id: rectTopLeft

    //    anchors{
    //        top: parent.top
    //        left: parent.left
    //    }

    //    width: parent.width * 0.5
    //    height: parent.height * 0.5

    //    color: "#848895"
    //    border.color: "black"

    //    View3D{
    //        id: viewTopLeft
    //        anchors.fill: parent
    //        importScene: sceneStandalone
    //        camera: cameraOrtho

    //        environment: SceneEnvironment{
    //            clearColor: "skyblue"
    //            backgroundMode: SceneEnvironment.Color
    //        }





    //    }

    //    Row {
    //        id: controlsContainer
    //        anchors.bottom: parent.bottom
    //        anchors.horizontalCenter: parent.horizontalCenter
    //        spacing: 10
    //        // padding: 10

    //        RoundButton {
    //            text: "Camera 1"
    //            highlighted: viewTopLeft.camera == cameraPerspective_1
    //            onClicked: {
    //                viewTopLeft.camera = cameraPerspective_1
    //            }
    //        }
    //        RoundButton {
    //            text: "Camera 2"
    //            highlighted: viewTopLeft.camera == cameraPerspective_2
    //            onClicked: {
    //                viewTopLeft.camera = cameraPerspective_2
    //            }
    //        }
    //        RoundButton {
    //            text: "Camera 3"
    //            highlighted: viewTopLeft.camera == cameraPerspective_3
    //            onClicked: {
    //                viewTopLeft.camera = cameraPerspective_3
    //            }
    //        }
    //    }
    //}


    //Rectangle{
    //    id: rectTools

    //    anchors{
    //        top: rectTopLeft.bottom
    //        left: parent.left
    //        right: parent.right
    //        bottom: parent.bottom
    //    }

    //    Column{
    //        enabled: false
    //        anchors.fill: parent

    //        Row{
    //            spacing: 40
    //            width: parent.width
    //            height: 90
    //            Label{
    //                id: lblPanning

    //                text: "PANNING:"
    //            }

    //            RoundButton{
    //                id: btnPan_Left

    //                text: "<-"
    //                height: parent.height
    //                width: height
    //                // onPressed: {
    //                    // viewTopLeft.camera.position.x -= 10
    //                // }
    //            }

    //            RoundButton{
    //                id: btnPan_Right

    //                text: "->"
    //                height: parent.height
    //                width: height
    //                // onPressed: {
    //                    // viewTopLeft.camera.position.x += 10
    //                // }
    //            }

    //            RoundButton{
    //                id: btnPan_Up

    //                text: "/\\"
    //                height: parent.height
    //                width: height


    //                // onPressed: {
    //                    // viewTopLeft.camera.position.y += 10
    //                // }
    //            }

    //            RoundButton{
    //                id: btnPan_Down

    //                text: "\\/"
    //                height: parent.height
    //                width: height
    //                // onPressed: {
    //                    // viewTopLeft.camera.position.y -= 10
    //                // }
    //            }
    //        }

    //        Row{
    //            spacing: 40
    //            width: parent.width
    //            height: 90
    //            Label{
    //                id: lblRotation

    //                text: "ROTATION:"
    //            }

    //            RoundButton{
    //                id: btnRotate_Left
    //                height: parent.height
    //                width: height
    //                text: "<-"

    //                // onPressed: {
    //                    // viewTopLeft.camera.eulerRotation.y += 1
    //                // }
    //            }

    //            RoundButton{
    //                id: btnRotate_Right
    //                height: parent.height
    //                width: height
    //                text: "->"

    //                // onPressed: {
    //                    // viewTopLeft.camera.eulerRotation.y -= 1
    //                // }
    //            }

    //            RoundButton{
    //                id: btnRotate_Up
    //                height: parent.height
    //                width: height
    //                text: "/\\"

    //                // onPressed: {
    //                    // viewTopLeft.camera.eulerRotation.x += 1
    //                // }
    //            }

    //            RoundButton{
    //                id: btnRotate_Down
    //                height: parent.height
    //                width: height
    //                text: "\\/"

    //                // onPressed: {
    //                    // viewTopLeft.camera.eulerRotation.x -= 1
    //                // }
    //            }
    //        }

    //    }


    //    Comp_Joystick {
    //        id: joystickMove

    //        joystickName: "Move"
    //        anchors.bottom: parent.bottom
    //        anchors.left: parent.left
    //    }

    //    Comp_Joystick {
    //        id: joystickLook

    //        joystickName: "Look"
    //        anchors.bottom: parent.bottom
    //        anchors.right: parent.right
    //    }

    //}

    //Timer{
    //    id: tmrControlls

    //    interval: inputUpdateInterval
    //    repeat: true
    //    running: true
    //    onTriggered: {
    //        var pan = viewTopLeft.camera.position
    //        // console.log("Camera Pan In: " + pan)

    //        // / PAN CONTROLLED BY ON-SCREEN JOYSTICK
    //        // pan.x += joystickMove.inputX * panSpeed_X
    //        // pan.y += joystickMove.inputY * panSpeed_Y
    //        // console.log("MY FORWARD VECTOR3D: " + viewTopLeft.camera.forward)
    //        var vectorRight = viewTopLeft.camera.right
    //        var vectorForward = viewTopLeft.camera.forward
    //        // console.log("---Vec Right: " + vectorRight)
    //        // console.log("---Vec Forward: " + vectorForward)
    //        var force_move_h = joystickMove.inputX * panSpeed_X
    //        var force_move_f = joystickMove.inputY * panSpeed_Y
    //        // console.log("---Force F: " + force_move_f)
    //        // console.log("---Force H: " + force_move_h)
    //        var vector_move_h = Qt.vector3d(
    //                    vectorRight.x * force_move_h,
    //                    vectorRight.y * force_move_h,
    //                    vectorRight.z * force_move_h)
    //        var vector_move_f = Qt.vector3d(
    //                    vectorForward.x * force_move_f,
    //                    vectorForward.y * force_move_f,
    //                    vectorForward.z * force_move_f
    //                    )
    //        // console.log("---Move F: " + vector_move_f)
    //        // console.log("---Move H: " + vector_move_h)

    //        pan.x += vector_move_f.x;
    //        pan.y += vector_move_f.y;
    //        pan.z += vector_move_f.z;

    //        pan.x += vector_move_h.x;
    //        pan.y += vector_move_h.y;
    //        pan.z += vector_move_h.z;

    //        // / PAN CONTROLLED BUTTON BUTTONS
    //        // var panXInput = (btnPan_Left.down ? -panSpeed_X : 0) + (btnPan_Right.down ? panSpeed_X : 0);
    //        // var panYInput = (btnPan_Up.down ? panSpeed_Y : 0) + (btnPan_Down.down ? -panSpeed_Y : 0);
    //        // pan.x += panXInput
    //        // pan.y += panYInput

    //        var eulerRotation = viewTopLeft.camera.eulerRotation

    //        // / ROTATION CONTROLLED BY ON-SCREEN JOYSTICK
    //        eulerRotation.x += joystickLook.inputY * rotSpeed_V
    //        eulerRotation.y += joystickLook.inputX * -rotSpeed_H

    //        // / ROTATION CONTROLLED BUTTONS
    //        // var rotateHInput = (btnRotate_Left.down ? rotSpeed_H : 0) + (btnRotate_Right.down ? -rotSpeed_H : 0)
    //        // var rotateYInput = (btnRotate_Up.down ? rotSpeed_V : 0) + (btnRotate_Down.down ? -rotSpeed_V : 0)
    //        // eulerRotation.y += rotateHInput
    //        // eulerRotation.x += rotateYInput

    //        // if( panXInput === 0 && panYInput == 0 && rotateHInput == 0 && rotateYInput == 0)
    //           // return;

    //        // console.log("Pan Y Input: " + panYInput)
    //        // console.log("---Pan speed y: " + panSpeed_Y)
    //        // console.log("---Pan_Up? " + btnPan_Up.down)
    //        // console.log("---Pan_Down? " + btnPan_Down.down)
    //        // console.log("Pan Output: " + pan)

    //        viewTopLeft.camera.position = pan
    //        viewTopLeft.camera.eulerRotation = eulerRotation
    //    }


}
