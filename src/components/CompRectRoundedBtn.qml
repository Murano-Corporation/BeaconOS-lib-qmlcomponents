import QtQuick 2.12
import QtGraphicalEffects 1.12

Item{
    id: compRectRoundedBtn

    property alias radius: rectBg.radius

    property color colorGradient: "Green"
    //opacity: 0.4

    Rectangle{
        id: rectBg
        radius: 24

        anchors.fill: parent
        visible: false


        color: "White"
    }

    LinearGradient{
        id: gradient1
        source: rectBg

        start: Qt.point(0, 0)
        end:  Qt.point(0, rectBg.height)

        anchors{
            fill: rectBg
        }

        gradient: Gradient{
            GradientStop{
                position: 0.0

                color: Qt.lighter(compRectRoundedBtn.colorGradient)
            }

            GradientStop{
                position: 1.0

                color: Qt.darker(compRectRoundedBtn.colorGradient)
            }
        }

        visible: true

    }

    InnerShadow{
        id: innerShadow

        source: gradient1

        anchors.fill: rectBg

        horizontalOffset: 4
        verticalOffset: -4
        radius: 12.0

        spread: 2.0
        color: "#30FFFFFF"

        samples: 16

        visible: false
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.75;height:480;width:640}
}
##^##*/
