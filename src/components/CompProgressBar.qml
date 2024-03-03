import QtQuick 2.0
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12


Item{
    id: compProgressBar

    property real percentComplete: 0.35
    property color colorBg: "#80000000"
    property color colorComplete: "#9287ED"

    width: 800

    Rectangle{
        id: rectBg

        anchors.fill: parent
        radius: 0.5 * height

        color: compProgressBar.colorBg
    }

    Rectangle{
        id: rectComplete

        anchors{
            left: rectBg.left
            top: rectBg.top
            bottom: rectBg.bottom
        }

        width: rectBg.width * compProgressBar.percentComplete
        radius: rectBg.radius
        color: compProgressBar.colorComplete
    }

    CompLabel{
        id: lblPercentComplete

        visible: false

        text: (compProgressBar.percentComplete * 100) + "% Complete"

        anchors.fill: parent

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        font.pixelSize: height * 0.8

        color: Qt.lighter(compProgressBar.colorComplete)
    }

    DropShadow{
        id: colorOVerlay

        anchors.fill: lblPercentComplete
        source: lblPercentComplete

        color: compProgressBar.colorBg

        radius: 1

        samples: 16
        horizontalOffset: 0
        verticalOffset: 0
        spread: 24

        cached: false

        smooth: true
        antialiasing: true
    }


}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.5}
}
##^##*/
