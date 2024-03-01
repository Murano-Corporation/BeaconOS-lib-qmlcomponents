import QtQuick 2.0
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12


Item{
    id: compProgressBar_Circle

    property real percentComplete: 0.5

    height: 64
    width: 64

    Rectangle{
        id: rectBg_ProgressCircle
        anchors.fill: parent

        radius: 0.5 * height
    }

    DropShadow{
        anchors.fill: rectBg_ProgressCircle
        source: rectBg_ProgressCircle
        color: "#80000000"

    }

    CompLabel{
        id: lblPercentComplete

        anchors.fill: parent

        text: (compProgressBar_Circle.percentComplete * 100) + "%"
        color: "black"

        font.pixelSize: height * 0.3

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

    }
}
