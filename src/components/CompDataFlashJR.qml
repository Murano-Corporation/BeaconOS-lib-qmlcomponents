import QtQuick 2.0

Comp__BASE {
    id: dfMain
    height: 116
    width: 60

    GridView {
        cellHeight: 26
        cellWidth: 60

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        model: ListModel {
            Text.WordWrap: true
            ListElement {
                name: "Download DataFlash Log Via Mavlink"
            }
            ListElement {
                name: "Review a Log"
            }
            ListElement {
                name: "Auto Analysis"
            }
            ListElement {
                name: "Create KML + gpx"
            }
            ListElement {
                name: "Convert .Bin to .Log"
            }
            ListElement {
                name: "Create Matla? File"
            }
            ListElement {
                name: "Geo Reference Images"
            }
        }
    }
}
