import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: compReferenceGridItemRoot

    property string fileName: "{filename.ext}"

    property bool isSelected: false
    property bool isHighlighted: false

    property color colorIdle: "#00ffffff"
    property color colorHover
    property color colorSelected
    property color colorCurrent: (isSelected ? colorSelected : (isHighlighted ? colorHover : colorIdle))

    signal clicked()
    signal entered()
    signal exited()
    signal doubleClicked()

    Rectangle{
        anchors{
            fill: itemBg
            margins: -10
        }

        radius: 50

        color: compReferenceGridItemRoot.colorCurrent
    }

    Item{
        id: itemBg

        anchors{
            centerIn: parent
        }

        height: compReferenceGridItemRoot.height * 0.90
        width: height

        BorderImage {
            id: borderImg

            visible: true

            source: "file:///usr/share/BeaconOS-lib-images/images/GlassBox_1x_643x598.png"

            anchors{
                fill: parent
            }

            border.left: 40; border.top: 40
            border.right: 40; border.bottom: 40
        }

    }

    CompImageIcon{
        anchors{
            centerIn: itemBg
        }

        source: 'file:///usr/share/BeaconOS-lib-images/images/ReferenceFill.svg'
        color: "#ffffff"
        opacity: 0.05
        height: itemBg.height * 0.80
        width: height
    }

    CompLabel{
        id: lblFileName

        anchors{
            fill: itemBg
            margins: 20
        }
        text: compReferenceGridItemRoot.fileName
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font{
            pixelSize: 20
        }
    }

    MouseArea{
        id: mouseArea

        hoverEnabled: true

        anchors{
            fill: parent
        }

        onClicked: {
            parent.clicked()
        }

        onDoubleClicked: {
            compReferenceGridItemRoot.doubleClicked()
        }

        onEntered: {
            compReferenceGridItemRoot.entered()
        }

        onExited: {
            compReferenceGridItemRoot.exited()
        }

    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.75;height:200;width:200}
}
##^##*/
