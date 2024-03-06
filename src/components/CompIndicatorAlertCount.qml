import QtQuick 2.12
import QtGraphicalEffects 1.12

Comp__BASE{
    id: indicatorAlertCount

    property int alertCount: 0
    property string textToDisplay: (alertCount > 10) ? ("10+") : ("" + alertCount)

    signal clicked()

    visible: alertCount > 0
    height: rectBg.height
    width: rectBg.width

    MouseArea{
        id: mouseAreaAlertIndicator

        anchors{
            fill: parent
        }

        onClicked: parent.clicked()
    }

    Rectangle{
        id: rectBg

        height: lblIndicator.height
        width: lblIndicator.width + 20
        radius: 0.5 * height
        color: "#B34C63"

        visible: false
    }

    InnerShadow{
        id: efxInnerShadow

        anchors{
            fill: rectBg
        }

        source: rectBg
        horizontalOffset: 2
        verticalOffset: 2
        samples: 16
        radius: 5

        color: "#BFFFC0C0"

        visible: false
    }

    DropShadow {
        id: efxDropShadow

        anchors{
            fill: rectBg
        }

        source: efxInnerShadow

        horizontalOffset: 0
        verticalOffset: 4
        radius: 4
        samples: 16

        color: "#40000000"

    }

    CompLabel {
        id: lblIndicator

        anchors{
            centerIn: parent

        }

        text: indicatorAlertCount.textToDisplay

        font{
            pixelSize: 23

        }
    }
}
