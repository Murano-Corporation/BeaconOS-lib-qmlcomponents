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

    function setCoordinates(model){
        var xValue = model.Latitude;
        var yValue = model.Longitude/*
       compDeviceInfo.xVal = xValue.split("° ")[0];
       compDeviceInfo.yVal = yValue.split("° ")[0];*/
        centerOnCoords(xValue, yValue);
    }

    signal centerOnCoords(var x, var y);
    signal signalBeaconIDChanged(var beaconIDSelected);

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: "#14818087"

        border {
            color: "White"
            width: 2
        }
    }

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

        spacing: 15

        anchors{
            fill:parent
            topMargin: 50
            leftMargin: 10
            rightMargin: 10
            bottomMargin: 10
        }

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

            //appSourceName: myModelData ? myModelData.appSource : '?'
            text: model.Beacon_ID + " - " + model.Latitude + ", " + model.Longitude
            onClicked: {
                //console.log("Clicked on button");
                compDeviceInfo.deviceID = model.Beacon_ID;
                //compDeviceInfo.beaconIDSelected = model.Beacon_ID;
                compDeviceInfo.signalBeaconIDChanged(model.Beacon_ID);
                console.log("model.is_selected : " + model.is_selected);
                popupActions.open();
                setCoordinates(model);
            }

        }
    }

    Popup {
        id: popupActions
        height: compDeviceInfo.isAntenna ? 160 : 270
        width: listofDevices.width

        x: listofDevices.x
        y: listofDevices.y * 4

        background: Rectangle{
            color: "#123456"

            radius: 16
        }

        CompLabel {
            id: lblPopuptitle

            anchors{
                top: parent.top
                //topMargin: 20
                horizontalCenter: parent.horizontalCenter
            }

            font.pixelSize: 25
            text: compDeviceInfo.deviceID

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
                top: parent.top
                bottomMargin: 20
            }

            height: 30
            width: 30

            onClicked: {
                popupActions.close()
            }

        }

        GridView {

            id: gridViewActions
            // anchors.left: parent.left
            // anchors.right: parent.right
            // anchors.top: lblPopuptitle.bottom
            anchors.fill: parent
            anchors.topMargin: 40
            anchors.leftMargin: 10

            // Rectangle {
            //     anchors.fill: parent
            //     color: "Purple"
            //     opacity: 0.5
            // }

            model: [
                ["file:///usr/share/BeaconOS-lib-images/images/Hide.svg", "Hide"],
                ["file:///usr/share/BeaconOS-lib-images/images/Control.svg", "Control"],
                ["file:///usr/share/BeaconOS-lib-images/images/3DReconstruction.svg", "3DReconstruction"],
                ["file:///usr/share/BeaconOS-lib-images/images/FlightPlannerIcon.svg", "FlightPlanner"]
            ]

            cellHeight: compDeviceInfo.isAntenna ? height : height / 2
            cellWidth: compDeviceInfo.isAntenna ? width/3 : width / 2
            delegate: Item{

                //color: "Pink"

                visible: (index !==3 && compDeviceInfo.isAntenna) || (!compDeviceInfo.isAntenna)
                height: gridViewActions.cellHeight
                width: gridViewActions.cellWidth
                CompGradientRect {

                    height: parent.height * 0.80
                    width: parent.width * 0.80
                    anchors.centerIn: parent

                    CompImageIcon {
                        anchors.centerIn: parent

                        height: parent.height * 0.80
                        width: parent.width * 0.80
                        source: modelData[0]
                        color: "White"
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

