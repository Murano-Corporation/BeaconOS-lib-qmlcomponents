import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0
import QtQml 2.12

Item {
    id: compDeviceInfo

    //property alias labelTitle: lbltitle
    property bool isAntenna: true
    property alias isDeviceAntenna : compDeviceInfo.isAntenna
    property string deviceID: ""
    property var xVal
    property var yVal
    property var listofDevices: []
    property var idx
    property string selectedAction: ""

    function setCoordinates(x, y){
        centerOnCoords(x, y);
        //tmrAnimation.start()
    }  //aj

    // Timer {
    //     id: tmrAnimation

    //     interval: 500

    //     onTriggered: {
    //         centerOnCoords(xVal, yVal);
    //     }
    // }

    function listItemClicked(model, index){
        compDeviceInfo.deviceID = model.Beacon_ID;
        compDeviceInfo.isAntenna = model.asset_type === "Antenna" ? true : false
        compDeviceInfo.idx = index + 16
        popupActions.open()
        drawerDeviceInfo.height = devicemap.height - 400
        listofDevices.currentIndex = index
        compDeviceInfo.xVal = model.Latitude
        compDeviceInfo.yVal = model.Longitude
    }

    signal centerOnCoords(var x, var y);
    signal signalBeaconIDChanged(var Beacon_ID);

    // Rectangle {
    //     anchors.fill: parent
    //     radius: 20
    //     color: "#14818087"
    // }

    // Rectangle{
    //     opacity: 0.5 * drawerDeviceInfo.position
    //     color: "#000000"
    //     radius: 20
    // }

    // CompLabel {
    //     id: lbltitle

    //     anchors{
    //         top: parent.top
    //         topMargin: 10
    //         horizontalCenter: parent.horizontalCenter
    //     }
    //     font{
    //         pixelSize: 25
    //     }

    // }

    ListView {
        id: listofDevices
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        //interactive: true

        spacing: 15

        anchors{
            top: parent.top
            left: parent.left
            right: parent.right

            topMargin: 10
            leftMargin: 10
            rightMargin: 10
            bottomMargin: 10
        }

        height: parent.height - 20 //popupActions.opened ? (drawerDeviceInfo.height - popupActions.height - 100) : parent.height//height

        model: compDeviceInfo.listofDevices
        delegate: CompBtnBreadcrumb{

            width: parent.width
            lblBtnLbl.horizontalAlignment: Text.AlignLeft
            lblBtnLbl.leftPadding: 50

            //height: 60
            Rectangle{
                anchors.fill: parent
                color: "Transparent"
                radius: 20
                border{
                    width: 3
                    color: "#9287ED"
            }
                visible: (listofDevices.currentIndex === index) && popupActions.visible
            }
            CompImageIcon{
                id: imgDeviceIcon

                anchors{
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                    leftMargin: 10
                    rightMargin: 20
                }

                width: 40
                source: model.asset_type === "Antenna" ? "file:///usr/share/BeaconOS-lib-images/images/AntennaFill.svg" : "file:///usr/share/BeaconOS-lib-images/images/DroneFill.svg"
            }

            //appSourceName: myModelData ? myModelData.appSource : '?'
            // CompLabel{

            //     anchors{
            //         verticalCenter: imgDeviceIcon.verticalCenter
            //         left: imgDeviceIcon.right
            //     }
                text: model.location + " - " + model.Beacon_ID
            //} // + " - " + model.Latitude + ", " + model.Longitude

            //MouseArea{
            //anchors.fill: parent
            onClicked: {
                compDeviceInfo.listItemClicked(model, index)
            }

            onPressAndHold: { //aj
                compDeviceInfo.listItemClicked(model, index)
                setCoordinates(compDeviceInfo.xVal, compDeviceInfo.yVal)
                devicemap.setZoomLevel(4.5)
            }
        //}

        }

        ScrollBar.vertical: ScrollBar{
            policy: ScrollBar.AlwaysOn
            width: 8
            //position: position + 4
            //topInset: 51
            topPadding: 10
            bottomPadding: 10
        }
    }

    Popup {
        id: popupActions
        height: 288 //compDeviceInfo.isAntenna ? 160 : 270
        width: listofDevices.width + 20
        closePolicy: Popup.NoAutoClose

        x: listofDevices.x - 10
        //y: listofDevices.y * 13.6
        y: drawerDeviceInfo.height + 10
        background: CompBtnBreadcrumb{
            anchors.fill: parent
            //color: "#0d1929"
            //radius: 20
        }

        CompLabel {
            id: lblPopuptitle

            anchors{
                top: parent.top
                //topMargin: 20
                horizontalCenter: parent.horizontalCenter
            }

            font.pixelSize: 20
            text: "Device ID: " + compDeviceInfo.deviceID

        }

        BtnClose{
            id: btnClose

            imageIcon{

                image{
                    antialiasing: true
                    smooth: true
                    cache: true
                }

                colorOverlay{
                    antialiasing: true
                    smooth: true
                    cached: true
                }

            }

            anchors{
                right: parent.right
                verticalCenter: lblPopuptitle.verticalCenter
            }

            height: 30
            width: 30

            onClicked: {
                drawerDeviceInfo.height = devicemap.height - 100
                devicemap.setZoomLevel(1.0)
                popupActions.close()
            }

        }

        GridView {
            id: gridViewActions

            interactive: false
            anchors.fill: parent
            anchors.topMargin: 40
            anchors.leftMargin: 10

            model: [
                ["file:///usr/share/BeaconOS-lib-images/images/Hide.svg", "View"],
                ["file:///usr/share/BeaconOS-lib-images/images/Control.svg", "Control"],
                ["file:///usr/share/BeaconOS-lib-images/images/3DReconstruction.svg", " Digital Twin"],
                ["file:///usr/share/BeaconOS-lib-images/images/FlightPlannerIcon.svg", "Fly"]
            ]

            cellHeight: height / 2
            cellWidth:  width / 2

            //cellHeight: height / 4
            //cellWidth: width

            delegate: Item{

                //color: "Pink"

                enabled: (index !== 3 && compDeviceInfo.isAntenna) || (!compDeviceInfo.isAntenna)
                opacity: 1.0
                height: gridViewActions.cellHeight
                width: gridViewActions.cellWidth
                CompBtnBreadcrumb {

                    height: parent.height * 0.80
                    width: parent.width * 0.90
                    anchors.centerIn: parent

                    CompImageIcon {
                        id: iconImg
                        anchors{
                            horizontalCenter: parent.horizontalCenter
                            top: parent.top
                            topMargin: 10
                        }

                        height: 40
                        width: 50
                        source: modelData[0]
                        color: "#ffffff"
                    }

                    CompLabel{
                        anchors{
                            horizontalCenter: parent.horizontalCenter
                            top: iconImg.bottom
                            //topMargin: 10
                        }
                        clip: true
                        text: modelData[1]
                        font.pixelSize: 18
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked:{
                            if(modelData[1] === "View"){
                                setCoordinates(compDeviceInfo.xVal, compDeviceInfo.yVal)
                                devicemap.setZoomLevel(4.5)
                                popupCameraFeed.open()
                            }
                            if(modelData[1] === "Control"){
                                compDeviceInfo.signalBeaconIDChanged(compDeviceInfo.deviceID);
                                raptorNavMenu.selectedScreen = "Control"
                            }
                       }
                    }
                }
            }
        }
    }




}

