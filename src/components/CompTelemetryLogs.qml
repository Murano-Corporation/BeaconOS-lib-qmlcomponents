import QtQuick 2.15
//import QtQuick.Controls 2.15

Comp__BASE {
    id: root

    height: 235
    width: 335

    property CompTelemetryLogsButton currentButton: btnNull //???

    property color fontColor1: "black"
    property color bgColor: "#000068"
    property color boxColor1: "#065465"

    property int gridCellHeight: 80
    property int gridCellWidth: 80
    property int buttonHeight: 70
    property int buttonWidth: 70
    property int pixelSize: 18

    CompTelemetryLogsButton { //???
        id: btnNull
        visible: false
    }

    Rectangle {
        anchors.fill: root
        color: root.bgColor
        radius: 10
    }

    GridView {
        id: grid

        height: root.gridCellHeight * 2
        width: root.gridCellWidth * 4
        cellHeight: root.gridCellHeight
        cellWidth: root.gridCellWidth
        anchors.centerIn: root
        boundsBehavior: Flickable.StopAtBounds

        model: ListModel {

            ListElement {
                speed: "0.25x"
            }
            ListElement {
                speed: "0.5x"
            }
            ListElement {
                speed: "0.5x"
            }
            ListElement {
                speed: "0.75x"
            }
            ListElement {
                speed: "1x"
            }
            ListElement {
                speed: "2x"
            }
            ListElement {
                speed: "3x"
            }
        }

        delegate: Item{ //???
            id: delegate

            height: root.gridCellHeight
            width: root.gridCellWidth

            CompTelemetryLogsButton{

                height: root.buttonHeight
                width: root.buttonWidth
                anchors.centerIn: parent
                isCurrent: root.currentButton === this //???
                textSpeed: model.speed

                onClicked: {
                    console.log("Clicked " + index)
                    root.currentButton = this //???
                }
            }
        }
    }
}
