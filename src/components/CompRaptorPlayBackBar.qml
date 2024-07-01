import QtQuick 2.12
import QtLocation 5.12
import QtPositioning 5.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

Rectangle {
    id: compRaptorPlayBackBarRoot

    property string timeCurrent: "00:20:40"
    property string timeTotal: "01:04:35"
    property real lblWidth: 120

    height: 103
    color: "#CC818087"
    radius: 20

    CompLabel{
        id: lblTimeCurrent

        width: compRaptorPlayBackBarRoot.lblWidth
        anchors{
            left: parent.left
            leftMargin: 10
            verticalCenter: parent.verticalCenter
        }
        horizontalAlignment: Text.AlignRight

        text: compRaptorPlayBackBarRoot.timeCurrent
    }

    CompProgressBar{
        id: playBackProgressBar

        anchors{
            left: lblTimeCurrent.right
            leftMargin: 10
            right: lblTimeTotal.left
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }

        colorBg: "#DD000000"
        showPercentComplete: false

        height: 4



    }

    CompLabel{
        id: lblTimeTotal

        width: compRaptorPlayBackBarRoot.lblWidth
        anchors{
            right: parent.right
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }

        text: compRaptorPlayBackBarRoot.timeTotal
    }
}
