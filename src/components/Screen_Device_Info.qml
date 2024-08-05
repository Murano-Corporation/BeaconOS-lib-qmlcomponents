import QtQuick 2.12
import QtLocation 5.12
import QtPositioning 5.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

Item {
    id: screenDeviceInfoRoot

    property var beaconIDSelected
    property var beaconIDSelectedLast
    // property string lat
    // property string lon
    // property string altitude
    // property string deviceSpeed
    // property var selectedItem

    // onBeaconIDSelectedChanged: {
    //     console.log("BEACON ID CHANGED IN SCREEN DEVICE INFO");
    // }




    CompMapViewer{
        id: devicemap

        anchors{
            top: parent.top
            left: parent.left
            bottom: parent.bottom
        }
        width: 1920//drawerDeviceInfo.position === 1.0 ?  1460 : 1920

        showMapTypes: true



        Component.onCompleted: setZoomLevel(1.0)
        listAssets: TableModelRaptorMap
    }

    CompImageIcon{
        id: openDeviceInfo
        opacity: 0.6
        visible: drawerDeviceInfo.position < 1.0

        y: 320

        anchors{
            left: devicemap.left
            //leftMargin: 48
            //verticalCenter: parent.verticalCenter
            //topMargin: 120
        }

        height: 578
        width: 48

        source: "file:///usr/share/BeaconOS-lib-images/images/LeftOpen.svg"
        //color: "White"

        MouseArea {
            anchors.fill: parent

            onClicked: {
                //console.log("Drawer open status before:", drawerDeviceInfo.visible);
                //console.log("OPENING DEVICE INFO DRAWER!!!")

                drawerDeviceInfo.visible = !drawerDeviceInfo.visible
                //drawerDeviceInfo.open()

                //console.log("Drawer open status after:", drawerDeviceInfo.visible);
            }
        }
    }


    // CompImageIcon{
    //     id: closeDeviceInfo

    //     opacity: 0.6
    //     visible: drawerDeviceInfo.position === 1.0

    //     anchors{
    //         right: drawerDeviceInfo.left
    //         verticalCenter: parent.verticalCenter
    //     }

    //     height: 578
    //     width: 48

    //     source: "file:///usr/share/BeaconOS-lib-images/images/Expander.svg"
    //     color: "White"

    //     MouseArea {
    //         anchors.fill: parent

    //         onClicked: {
    //             console.log("Drawer open status:", screenDeviceInfoRoot.isDrawerOpen);
    //             console.log("CLOSING DEVICE INFO DRAWER!!!")
    //             drawerDeviceInfo.visible = !drawerDeviceInfo.visible
    //             drawerDeviceInfo.close()
    //             console.log(drawerDeviceInfo.visible)
    //         }
    //     }
    // }

    Drawer{
        id: drawerDeviceInfo

        closePolicy: Popup.NoAutoClose
        dim: false
        modal: false

        height: devicemap.height - 220// - areaToolbar.height - 200

        width: root.width * 0.215

        edge: Qt.LeftEdge
        y: 200
        //x: 200

        leftPadding: 10

        CompBtnBreadcrumb{
            anchors{
                fill: parent
                // top: parent.top
                // left: parent.left
                // right: parent.right
                // bottom: parent.bottom
                // topMargin: 100
            }
            //color: "#000000"
            //radius: 20
        }
        background: Rectangle {
            color: "#00000000"
        }

        Comp_Device_Info{
            id: deviceInfo

            //compMapViewer: devicemap
            onSignal_onItemClicked: devicemap.setZoomLevel(4.5)
            onSignal_onItemLongPressed: devicemap.setZoomLevel(4.5)

            anchors.fill: parent
            anchors.topMargin: 20

            //labelTitle.text: "Devices"
            //isDeviceAntenna: true
            listofDevices: TableModelRaptorMap

            onCenterOnCoords: devicemap.centerOnPointXY(x, y)
            onSignalBeaconIDChanged: (bid)=>{
                //console.log("Signal " + bid + " caught")

                screenDeviceInfoRoot.beaconIDSelected = bid


            }


        }

    }

    Rectangle {
        id: rectPopuoptarget
        color: "transparent"
        //opacity: 0.5
        height: 400
        width: 700
        x: (devicemap.width * 0.5) -250
        y: (devicemap.height * 0.5) - (500 * 0.5)

        onXChanged:{
            //console.log("X is now: ")
            popupCameraFeed.mappedPoint = rectPopuoptarget.mapToItem(root.contentItem, 0,0)
        }
    }

    Comp__BASE_Popup{
        id: popupCameraFeed

        popupName: "Camera Feed"

        height: 300
        width: 500

        property point mappedPoint : rectPopuoptarget.mapToItem(root.contentItem, 0,0)
        x: mappedPoint.x
        y: mappedPoint.y
        onMappedPointChanged:{
            console.log("Mapped Point is now: " + mappedPoint)
        }
        background: Rectangle {
            color: "transparent"
            anchors.fill: parent
        }
        anchors.centerIn: undefined

        onVisibleChanged: {
            mappedPoint = rectPopuoptarget.mapToItem(root.contentItem, 0,0)
        }

        Image {
            id: imageCameraFeed
            source: "file:///usr/share/BeaconOS-lib-images/images/sunsetSwarm 1.png"
            fillMode: Image.PreserveAspectCrop

            anchors {
                fill: parent
            }
        }
    }


}
