import QtQuick 2.15

import QtQuick.Controls 2.15

Comp__BASE {
    id: tlMain
    height: 32
    width: 58
    Column {
        CompButton{
            id: tlLoadLog
            height: 38
            width: 92
            text: "Load Log"
            font.pixelSize: 16



        }
        CompButton {
            id: tlPlay
            height: 33
            width: 92

            font{
                font.pixelSize: 16
                text: "Play"
            }
        }
        CompButton {
            id: tlTkg
            height: 55
            width: 92

            font{
                font.pixelSize: 16
                text: "Tlog > Kml or Graph"
                Text.WordWrap: true
            }
        }
    }

    GridView {
        id: tlSpeedNums
        cellHeight: 77
        cellWidth: 132

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        model: ListModel {

            ListElement {
                speed: "0.1x"
            }
            ListElement {
                speed: "0.25x"
            }
            ListElement {
                speed: "0.5x"
            }
            ListElement {
                speed: "1x"
            }
            ListElement {
                speed: "2x"
            }
            ListElement {
                speed: "5x"
            }
            ListElement {
                speed: "10x"
            }
        }

        delegate: CompTelemetryLogsSpeedJR{
            height: 77
            width: 132

            textSpeed: model.speed
        }

    }

    //speed slider and percentage slider????
    //NOT COMPLETED REFER TO FIGMA
}
