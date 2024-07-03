import QtQuick 2.12
import QtLocation 5.12
import QtPositioning 5.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

Item {
    id: screenDeviceInfoRoot

    property var beaconIDSelected
    property var beaconIDSelectedLast
    property bool isDrawerOpen: false
    // property string lat
    // property string lon
    // property string altitude
    // property string deviceSpeed
    // property var selectedItem

    onBeaconIDSelectedChanged: {
        console.log("BEACON ID CHANGED IN SCREEN DEVICE INFO");
    }

    CompMapViewer{
        id: devicemap

        anchors{
            top: parent.top
            //topMargin: 20
            left: parent.left
            //right: parent.right
            bottom: parent.bottom
        }
        width: drawerDeviceInfo.position === 1.0 ?  1550 : 1920

        showMapTypes: false
        Component.onCompleted: setZoomLevel(1.0)
        listAssets: TableModelRaptorMap
    }

    CompImageIcon{
        id: openDeviceInfo

        opacity: 0.6
        visible: drawerDeviceInfo.position < 1.0

        anchors{
            right: devicemap.right
            verticalCenter: parent.verticalCenter
        }

        height: 578
        width: 48

        source: "file:///usr/share/BeaconOS-lib-images/images/Expander.svg"
        color: "White"

        MouseArea {
            anchors.fill: parent

            onClicked: {
                console.log("Drawer open status:", screenDeviceInfoRoot.isDrawerOpen);
                console.log("OPENING DEVICE INFO DRAWER!!!")

                drawerDeviceInfo.open()
                screenDeviceInfoRoot.isDrawerOpen = true;

                console.log("Drawer open status:", screenDeviceInfoRoot.isDrawerOpen);
            }
            // Component.onDestroyed: {
            //     screenDeviceInfoRoot.isDrawerOpen = false;
            // }
        }
    }


    CompImageIcon{
        id: closeDeviceInfo

        opacity: 0.6
        visible: drawerDeviceInfo.position === 1.0

        anchors{
            right: devicemap.right
            verticalCenter: parent.verticalCenter
        }

        height: 578
        width: 48

        source: "file:///usr/share/BeaconOS-lib-images/images/Expander_Flipped.svg"
        color: "White"

        MouseArea {
            anchors.fill: parent

            onClicked: {
                console.log("Drawer open status:", screenDeviceInfoRoot.isDrawerOpen);
                console.log("CLOSING DEVICE INFO DRAWER!!!")
                drawerDeviceInfo.close()
                screenDeviceInfoRoot.isDrawerOpen = false;
                console.log("Drawer open status:", screenDeviceInfoRoot.isDrawerOpen);
            }
            // Component.onDestroyed: {
            //     screenDeviceInfoRoot.isDrawerOpen = false;
            // }
        }
    }
    // Comp_Device_Info{

    //     id: antennaInfo

    //     anchors{
    //         top: devicemap.top
    //         //topMargin: 20
    //         left: devicemap.right
    //         leftMargin: 20
    //         right: parent.right
    //         //bottom: devicemap.bottom
    //         bottomMargin: 10
    //     }
    //     height: 478

    //     labelTitle.text: "Antennas"
    //     isDeviceAntenna: true
    //     listofDevices: TableModelRaptorAntenna

    //     onCenterOnCoords: devicemap.centerOnPointXY(x, y)
    //     onSignalBeaconIDChanged: (bid)=>{
    //         console.log("Signal caught")
    //         screenDeviceInfoRoot.beaconIDSelected = bid
    //     }


    // }

    // Comp_Device_Info{

    //     anchors{
    //         top: antennaInfo.bottom
    //         topMargin: 20
    //         left: devicemap.right
    //         leftMargin: 20
    //         right: parent.right
    //         //bottom: devicemap.bottom
    //         //bottomMargin: 20
    //     }

    //     height: antennaInfo.height
    //     labelTitle.text: "Drones"
    //     isDeviceAntenna: false
    //     listofDevices: TableModelRaptorDrone

    //     onCenterOnCoords: devicemap.centerOnPointXY(x, y)
    //     onSignalBeaconIDChanged: (bid)=>{
    //         console.log("Signal caught")
    //         screenDeviceInfoRoot.beaconIDSelected = bid
    //     }
    // }

    Drawer{
        id: drawerDeviceInfo

        closePolicy: Popup.NoAutoClose
        dim: false
        modal: false

        height: devicemap.height// - areaToolbar.height - 200

        width: 350

        edge: Qt.RightEdge
        y: 85

        rightPadding: 10

        CompBtnBreadcrumb{
            anchors.fill: parent
            //color: "#000000"
            //radius: 20
        }
        background: Rectangle {
            color: "#00000000"
        }

        Comp_Device_Info{
            id: deviceInfo

            anchors.fill: parent

            labelTitle.text: "Devices"
            //isDeviceAntenna: true
            listofDevices: TableModelRaptorMap

            onCenterOnCoords: devicemap.centerOnPointXY(x, y)
            onSignalBeaconIDChanged: (bid)=>{
                console.log("Signal caught")

                screenDeviceInfoRoot.beaconIDSelected = bid
                drawerDeviceInfo.height = devicemap.height - 400
            }


        }



    }


}
