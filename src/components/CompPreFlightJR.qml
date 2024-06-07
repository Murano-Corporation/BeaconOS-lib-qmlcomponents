import QtQuick 2.15

Comp__BASE {
    id: pfMain
    height: 658
    width: 318

    CompButton{
        id: pfEdit
        height: 26
        width: 38
        anchors {
            top: parent.top
            right: parent.right
            topMargin: 10
            rightMargin: 10
        }

        font{
            font.pixelSize: 16
            text: "Edit"
        }
    }

    ListView {
        id:pfObjectList
        height: 658
        width: 292

        anchors {
            top: pfEdit.bottom
            right: parent.right
            left: parent.left
        }


        model: ListModel {
            ListElement {
                text: "Verify GPS"
                data: "0 >= 3"

            }
        }
    }
}
