import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0
import QtQml 2.12

Item {
    id: compDeviceInfo

    property alias labelTitle: lbltitle
    property bool isAntenna: true
    property alias isDeviceAntenna : compDeviceInfo.isAntenna
    property string deviceID: ""
    property var xVal
    property var yVal
    property var listofDevices: []
    property var idx

    function setCoordinates(model){
        var xValue = model.Latitude;
        var yValue = model.Longitude/*
       compDeviceInfo.xVal = xValue.split("° ")[0];
       compDeviceInfo.yVal = yValue.split("° ")[0];*/
        centerOnCoords(xValue, yValue);
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

    CompLabel {
        id: lbltitle

        anchors{
            top: parent.top
            topMargin: 10
            horizontalCenter: parent.horizontalCenter
        }
        font{
            pixelSize: 25
        }

    }

    ListView {
        id: listofDevices
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        //interactive: true

        spacing: 15

        anchors{
            top: lbltitle.bottom
            left: parent.left
            right: parent.right

            //fill:parent
            topMargin: 10
            leftMargin: 10
            rightMargin: 10
            bottomMargin: 10
        }

        height: parent.height - 60 //popupActions.opened ? (drawerDeviceInfo.height - popupActions.height - 100) : parent.height//height

        model: compDeviceInfo.listofDevices
        delegate: CompBtnBreadcrumb{

            width: parent.width
            Rectangle{
                anchors.fill: parent
                color: "Transparent"
                border{
                    width: 3
                    color: "#9287ED"
                }
                visible: model.is_selected
            }
            CompImageIcon{

                anchors{
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                    leftMargin: 10
                    rightMargin: 30
                }

                width: 40
                source: model.asset_type === "Antenna" ? "file:///usr/share/BeaconOS-lib-images/images/Antenna.svg" : "file:///usr/share/BeaconOS-lib-images/images/Drone.svg"
            }

            //appSourceName: myModelData ? myModelData.appSource : '?'
            text: model.Beacon_ID // + " - " + model.Latitude + ", " + model.Longitude
            onClicked: {
                compDeviceInfo.deviceID = model.Beacon_ID;
                compDeviceInfo.isAntenna = model.asset_type === "Antenna" ? true : false
                compDeviceInfo.signalBeaconIDChanged(model.Beacon_ID);
                compDeviceInfo.idx = index + 16
                popupActions.open();
                setCoordinates(model);
            }

        }

        ScrollBar.vertical: ScrollBar{
            policy: ScrollBar.AlwaysOn
            width: 8
            position: position + 4
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
                drawerDeviceInfo.height = devicemap.height
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
                        color: "#9287ED"
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
                            if(modelData[1] === "Control"){
                                popupActions.close();
                                raptorNavMenu.selectedScreen = "Control"
                            }

                        }
                    }
                }
            }
        }
    }
}

