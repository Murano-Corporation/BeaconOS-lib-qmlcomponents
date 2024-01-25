import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: compProcdImageItemRoot

    property string imgDirPath: "file://"
    property string imgSourceName: ""
    property string imgSourcePath: imgSourceName !== "" ? (imgDirPath + imgSourceName) : ""

    property string imgId: ""
    property string imgTimestamp: ""
    property string result: "OK"
    property bool resultOk: (result === "OK")

    signal clicked()

    Item{
        id: itemBg

        anchors{
            fill: parent
        }

        BorderImage {
            id: borderImg

            visible: compProcdImageItemRoot.resultOk

            source: "file:///usr/share/BeaconOS-lib-images/images/GlassBox_1x_643x598.png"

            anchors{
                fill: parent
            }

            border.left: 40; border.top: 40
            border.right: 40; border.bottom: 40
        }

        ColorOverlay{
            id: colorOverlay

            visible: !compProcdImageItemRoot.resultOk
            source: borderImg
            color: "#21E55871"


            anchors{
                fill: borderImg
            }
        }

    }

    Image{
        id: img

        visible: false

        anchors{
            top: parent.top
            topMargin: 41
            left: parent.left
            leftMargin: 47
            right: parent.right
            rightMargin: 47
        }

        height: width * 0.74
        fillMode: Image.PreserveAspectFit
        source: compProcdImageItemRoot.imgSourcePath
        sourceSize: Qt.size(width, height)
    }

    DropShadow{
        anchors{
            fill: img
        }

        source: img
        samples: 17
        color: "#80000000"
        radius: 8.0
    }

    CompLabel{
        id: lblId

        anchors{
            top: img.bottom
            topMargin: 20
            horizontalCenter: img.horizontalCenter
        }

        text: compProcdImageItemRoot.imgId + " - " + compProcdImageItemRoot.imgTimestamp
        font{
            pixelSize: 25
        }
    }

    CompLabel {
        id: lblResult

        visible: !compProcdImageItemRoot.resultOk

        anchors{
            top: lblId.bottom
            topMargin: 7

            horizontalCenter: lblId.horizontalCenter
        }

        text: compProcdImageItemRoot.result
        font{
            pixelSize: 18
        }
    }

    CompImageIcon{
        id: iconOk

        visible: compProcdImageItemRoot.resultOk

        anchors{
            fill: lblResult
        }

        source: "file:///usr/share/BeaconOS-lib-images/images/CheckFill.svg"
        color: "#97CD79"
    }

    MouseArea{
        id: mousearea
        anchors{
            fill: parent
        }

        onClicked: compProcdImageItemRoot.clicked()
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";height:375;width:387}
}
##^##*/
