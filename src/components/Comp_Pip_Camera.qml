import QtQuick 2.15
import QtQuick.Controls 2.15
import QtMultimedia 5.12
import QtGraphicalEffects 1.15

Comp_Pip__BASE {
    id: component_Pip_Camera

    property int cameraRotationOffset: Settings.cameraRotationOffset
    property bool isCameraAvailable: availableCameras.length > 0
    property var availableCameras: QtMultimedia.availableCameras
    property int indexOfSelectedCamera: -1
    property string selectedCameraDevId: availableCameras.length >= 3 ? QtMultimedia.availableCameras[2].deviceId : ""
    property Camera cameraMain
    property VideoOutput videoOutMain

    dev_ShowRect: false

    Rectangle {
        id: circleBG
        visible: !isCameraAvailable
        anchors{
            top: parent.top
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        width: height
        //radius: width * 0.5

        color: "#80000000"

    }


    Loader{
        id: loaderCameraMain

        active: component_Pip_Camera.isCameraAvailable
        asynchronous: true

        anchors.fill: circleBG

        sourceComponent: Item {

            VideoOutput {
                id: videoOut
                visible: false

                anchors.fill: parent

                Component.onCompleted: {
                    console.log("Main Video out loaded!")
                    component_Pip_Camera.videoOutMain = this
                }

                source: Camera {

                    deviceId: QtMultimedia.availableCameras[2].deviceId

                    Component.onCompleted:{
                        console.log("Main Camera out loaded!")
                        component_Pip_Camera.cameraMain = this
                    }
                }
                orientation: cameraRotationOffset
            }

            //Rectangle{
            //    anchors.fill: parent

            //    color: "red"
            //}




        }


    }

    OpacityMask {
        anchors.fill: circleBG

        maskSource: circleBG
        source: videoOutMain ? videoOutMain : undefined
        cached: false
    }

    Loader{
        id: loaderNoCamera

        active: !component_Pip_Camera.isCameraAvailable
        anchors.fill: circleBG
        sourceComponent: CompLabel{

            text: "Camera Unavailable"
            wrapMode: "WordWrap"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            color: "White"
        }
    }


}
