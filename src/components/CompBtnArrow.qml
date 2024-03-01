import QtQuick 2.0

Item{
    id: compBtnArrow

    property alias text: lblText.text

    signal clicked()

    height: 24
    width: lblText.x + lblText.width

    CompImageIcon{
        id: icon

        source: "file:///usr/share/BeaconOS-lib-images/images/LeftFill.svg"
        color: "#727272"

        anchors{
            top: parent.top
            left: parent.left
            bottom: parent.bottom
        }

        width: height
    }

    CompLabel{
        id: lblText
        text: "Set Me"

        color: "black"
        font.pixelSize: 22
        anchors{
            left: icon.right
            leftMargin: 20
            top: icon.top
            bottom: icon.bottom
        }
    }

    MouseArea{
        anchors.fill: parent

        onClicked: compBtnArrow.clicked()
    }


}
