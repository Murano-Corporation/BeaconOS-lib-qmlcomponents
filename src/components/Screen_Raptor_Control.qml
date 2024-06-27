import QtQuick 2.15

Screen_Raptor__BASE {
    id: screen_RaptorControlRoot

    property string beaconIDSelected : ""

    signal signalBeaconIDSelected(string beacon_ID)

    Component.onCompleted: {
        tmrDelayOnCompleted.start()
    }

    anchors.fill: parent

    Timer {
        id: tmrDelayOnCompleted

        interval:  10
        onTriggered: {
            if(screen_RaptorControlRoot.beaconIDSelected === ""){
                popupSelectedAssets.open();
            }
        }
    }

    Image {
        id: imageCameraFeed
        visible: screen_RaptorControlRoot.beaconIDSelected !== ""
        source: "file:///usr/share/BeaconOS-lib-images/images/sunsetSwarm 1.png"

        anchors {
            fill: parent
        }
    }

    CompBtnBreadcrumb {
        id: lblBeaconID

        visible: screen_RaptorControlRoot.beaconIDSelected !== ""

        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: 20
        }

        height: 60
        width: 220

        text: screen_RaptorControlRoot.beaconIDSelected ? "Asset ID: " + screen_RaptorControlRoot.beaconIDSelected : ""
        fontColor: "#00FF94"
        onClicked: popupSelectedAssets.open()
    }

    Item {
        id: compTargetBoundingBox1
        visible: screen_RaptorControlRoot.beaconIDSelected !== ""
        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 100
        }

        Rectangle{
            anchors.top: parent.top
            color: "#00FF94"
            height: 2
            width: 270
        }
        Rectangle{
            anchors.left: parent.left
            color: "#00FF94"
            height: 123
            width: 2
        }

        Rectangle{
            anchors.top: parent.top
            anchors.right: parent.right
            color: "#00FF94"
            height: 2
            width: 270
        }
        Rectangle{
            anchors.right: parent.right
            color: "#00FF94"
            height: 123
            width: 2
        }

        Rectangle{
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            color: "#00FF94"
            height: 2
            width: 270
        }
        Rectangle{
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            color: "#00FF94"
            height: 123
            width: 2
        }

        Rectangle{
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            color: "#00FF94"
            height: 2
            width: 270
        }
        Rectangle{
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            color: "#00FF94"
            height: 123
            width: 2
        }
    }




    Rectangle{
        id: areaAltimeter
        visible: screen_RaptorControlRoot.beaconIDSelected !== ""

        anchors.centerIn: parent

        height: 40
        width: 40

        color: "#80ff8899"
    }

    CompLabel{
        id: areaSelfCoordinates

        text: screen_RaptorControlRoot.beaconIDSelected ? "20.9584° N, 151.700° W" : ""

        font{
            pixelSize: 40
        }

        anchors{
            top: parent.top
            right: parent.right
            margins: 20
        }
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight

        height: 67
        width: 521

        color: "#00FF94"

    }

    Rectangle {
        id: areaTargetMetaData

        visible: screen_RaptorControlRoot.beaconIDSelected !== ""


        height: 500
        width: 350

        color: "Transparent"

        border{
            width: 4
            color: "#00FF94"
        }

        Timer {
            id: tmrNotTouched

            interval: 2000

            onTriggered: {
                areaTargetMetaData.color = "Transparent"
            }
        }

        CompLabel{
            id: lblDroneSwarm
            anchors{
                top: parent.top
                left: parent.left
                margins: 20
            }
            color: "#00FF94"
            text: "Drone Swarm"
            font.pixelSize: 30
        }

        ListView{
            id: metaDataList

            anchors{
                top: lblDroneSwarm.bottom
                topMargin: 20
                left: lblDroneSwarm.left
            }
            height: parent.height

            model: [
                {"label": "Asset Name", "value": "Drone Swarm"},
                {"label": "Main Arm", "value": "No weapon"},
                {"label": "Second Arm", "value": "- "},
                {"label": "Peronnel", "value": "- "},
                {"label": "Destroyed", "value": "23/47"},
                {"label": "Health", "value": "- "},
                {"label": "Range", "value": "20 kilometers"}
            ]

            delegate:Item{
                height: 60
                CompLabel{
                    text: modelData.label + " : " + modelData.value
                    color: "#00FF94"
                    font.pixelSize: 20
                }
            }
        }

        Behavior on color{

            ColorAnimation {
                duration: 200
            }
        }
        anchors.verticalCenter: imageCameraFeed.verticalCenter
        anchors.left: imageCameraFeed.right
        anchors.right: imageCameraFeed.left
        anchors.top: imageCameraFeed.bottom
        anchors.bottom: imageCameraFeed.top
        anchors.leftMargin: -391
        anchors.rightMargin: -1879
        anchors.topMargin: -826
        anchors.bottomMargin: -754
        anchors.horizontalCenter: imageCameraFeed.horizontalCenter

        MouseArea{
            anchors.fill: parent

            onPressed: {
                tmrNotTouched.stop()
                areaTargetMetaData.color = "#80000000"
            }

            onReleased: {
                tmrNotTouched.start()
            }
        }
    }


    CompLabel{
        id: areaClassifcation

        visible: screen_RaptorControlRoot.beaconIDSelected !== ""
        x: 132
        y: 737

        color: "#00FF94"
        text: "Drone Swarm"
        font.pixelSize: 25



        Rectangle{
            color: "Transparent"
            z: -1
            anchors.fill: parent
            anchors.margins: -20

            border{
                color: "#00FF94"
                width: 3
            }

            Timer{
                id: tmr_DelayFade
                interval: 2000

                onTriggered: {
                    parent.color = "Transparent"
                }
            }


            Behavior on color{

                ColorAnimation {
                    duration: 200
                }
            }

            MouseArea{
                anchors.fill: parent

                onPressed: {
                    tmr_DelayFade.stop()
                    parent.color = "#80000000"

                }

                onReleased: {
                    tmr_DelayFade.start()

                }
            }
        }
    }


    Row{
        id: areaControlsRow

        height: 90
        width: 400

        enabled: screen_RaptorControlRoot.beaconIDSelected !== ""
        opacity: screen_RaptorControlRoot.beaconIDSelected ? 1.0 : 0.3

        anchors{
            bottom: parent.bottom
            bottomMargin: 40
            horizontalCenter: parent.horizontalCenter
        }

        spacing: 30

        CompRaptorNavMenuItem {
            id: menuItemRaptor
            opacity: 0.6

            imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/Camera.svg"
            imgIconColor: "White"
        }
        CompRaptorNavMenuItem {
            id: menuItemControl
            opacity:0.6

            imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/Video.svg"
            imgIconColor: "White"

        }
        CompRaptorNavMenuItem {
            id: menuItem3DReconstruction
            opacity: 0.6

            imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/3DReconstruction.svg"

        }

        CompRaptorNavMenuItem {
            id: menuItemFlightPlanner
            opacity: 0.6

            imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/ControlEnabled.svg"

        }

    }

    PopupAsset {
        id: popupSelectedAssets
    }

    CompBtnBreadcrumb{
        id: selectAssetBtn

        anchors.centerIn: parent
        visible: screen_RaptorControlRoot.beaconIDSelected === "" && !popupSelectedAssets.visible

        height: 200
        width: 400

        text: "Please select an asset to continue."

        onClicked: popupSelectedAssets.open()
    }



}
