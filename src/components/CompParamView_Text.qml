import QtQuick 2.12

import QtQuick.Controls 2.12
import Qt.labs.qmlmodels 1.0
import QtGraphicalEffects 1.0

Item{
    id: compParamViewTextRoot

    property alias valueText: lblValue.text
    property alias paramName: lblParamName.text
    property int severity: 0

    width: 340
    height: 355

    Rectangle{
        id: rectBg

        anchors{
            fill: rectContents
            margins: 60
        }

        radius: 0.5 * height

        color: "#233245"
        visible: false
    }

    GaussianBlur{
        id: blurBg

        anchors{
            fill: rectBg
        }
        transparentBorder: true
        source: rectBg
        samples: 16
        radius: 40
    }

    Rectangle{
        id: rectContents

        anchors{
            top: compParamViewTextRoot.top
            topMargin: 20
            left: compParamViewTextRoot.left
            leftMargin: 20
            right: compParamViewTextRoot.right
            rightMargin: 20
        }

        height: width
        radius: 20

        color: "#80000000"
    }

    CompLabel {
        id: lblParamName

        anchors{
            top: rectContents.bottom
            topMargin: 20
            left: compParamViewTextRoot.left
            right: compParamViewTextRoot.right

        }

        text: "ParamName"

        horizontalAlignment: "AlignHCenter"
        verticalAlignment: "AlignVCenter"
        wrapMode: Text.WordWrap
        font{
            pixelSize: 20
        }
    }

    CompLabel {
        id: lblValue

        anchors{
            centerIn: rectContents
        }

        font{
            pixelSize: 32
            weight: Font.Normal
        }


    }



}
