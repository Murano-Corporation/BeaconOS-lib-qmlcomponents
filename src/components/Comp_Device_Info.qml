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
    property var listofAntennas: [
        {
            "id": "276557",
            "coordinates": "20.9584° N, 151.700° W"
        },
        {
            "id": "897637",
            "coordinates": "87.3930° S, 231.504° W"
        },
        {
            "id": "678375",
            "coordinates": "7.4959° N, 11.055° E"
        },
        {
            "id": "852147",
            "coordinates": "19.9854° S, 120.500° E"
        },
        {
            "id": "951753",
            "coordinates": "50.4532° N, 136.524° W"
        }
    ]
    property var listofDrones: [
        {
            "id": "7431",
            "coordinates": "20.9584° N, 151.700° W"
        },
        {
            "id": "9963",
            "coordinates": "87.3930° S, 231.504° W"
        },
        {
            "id": "1487",
            "coordinates": "7.4959° N, 11.055° E"
        },
        {
            "id": "5841",
            "coordinates": "19.9854° S, 120.500° E"
        },
        {
            "id": "4752",
            "coordinates": "50.4532° N, 136.524° W"
        }
    ]

    property var listData: isAntenna ? listofAntennas : listofDrones

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


        model: compDeviceInfo.listData

        delegate: CompBtnBreadcrumb{

            width: parent.width

            //appSourceName: myModelData ? myModelData.appSource : '?'
            text: modelData.id + " - " + modelData.coordinates

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("Clicked on button");
                    popupActions.open();
                }
            }
        }
    }

    Popup {
        id: popupActions
        height: 270
        width: listofDevices.width

        x: listofDevices.x
        y: listofDevices.y * 4

        background: Rectangle{
            color: "#123456"

            radius: 16
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
            anchors.fill: parent
            anchors.topMargin: 40
            anchors.leftMargin: 10

            model: [
                ["file:///usr/share/BeaconOS-lib-images/images/Hide.svg", "Hide"],
                ["file:///usr/share/BeaconOS-lib-images/images/Control.svg", "Control"],
                ["file:///usr/share/BeaconOS-lib-images/images/3DReconstruction.svg", "3DReconstruction"],
                ["file:///usr/share/BeaconOS-lib-images/images/FlightPlannerIcon.svg", "FlightPlanner"]
            ]

            cellHeight: height / 2
            cellWidth: width / 2
            delegate: CompGradientRect {
                anchors.topMargin: 20
                height: gridViewActions.cellHeight * 0.9
                width: gridViewActions.cellWidth * 0.95
                CompImageIcon {
                    anchors.centerIn: parent
                    width: 80
                    height: 80
                    source: modelData[0]
                    color: "White"
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked:{
                        console.log("clicked on more options");
                    }
                }
            }
        }
    }
}

