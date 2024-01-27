import QtQuick 2.12

import QtQuick.Controls 2.12
import Qt.labs.qmlmodels 1.0
import QtGraphicalEffects 1.12

Item{
    id: compParamViewLEDRoot

    property alias valueText: lblValue.text
    property alias paramName: lblParamName.text
    property int severity: 0
    property bool isOnBad: false
    property bool isUnknownValueText: false
    property bool isOn: {

        isUnknownValueText = false
        if(valueText === "1" || valueText === "On" || valueText === "Enabled" || valueText === "Enable")
            return true
        else if(valueText === "0" || valueText === "Off" || valueText === "Disabled" || valueText === "Disable")
            return false
        else
        {
            isUnknownValueText = true
            return true
        }

    }
    property color colorOnGood: "#00ff00"
    property color colorOnBad: "#ff0000"
    property color colorOnUnknown: "#ff00ff"
    property color colorOn_Active: isUnknownValueText ? colorOnUnknown : (isOnBad ? colorOnBad : colorOnGood)

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
            top: compParamViewLEDRoot.top
            topMargin: 20
            left: compParamViewLEDRoot.left
            leftMargin: 20
            right: compParamViewLEDRoot.right
            rightMargin: 20
        }

        height: width
        radius: 20

        color: "#15000000"
    }

    CompLabel {
        id: lblParamName

        anchors{
            top: rectContents.bottom
            topMargin: 20
            left: compParamViewLEDRoot.left
            right: compParamViewLEDRoot.right

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
        visible: compParamViewLEDRoot.isUnknownValueText
        anchors{
            centerIn: rectContents
        }

        font{
            pixelSize: 32
            weight: Font.Normal
        }
    }

    Rectangle{
        id: rectLED_BG

        anchors.centerIn: lblValue

        height: parent.height * 0.35
        width: height
        radius: 0.5 * height
        visible: false
    }

    RadialGradient{
        visible: !compParamViewLEDRoot.isUnknownValueText
        source: rectLED_BG
        anchors.fill: rectLED_BG
        gradient: Gradient{
            GradientStop {position: 0.0; color: "#80ffffff"}
            GradientStop {position: 0.39; color: "#80ffffff"}
            GradientStop {position: 0.40; color: "#000000"}
            GradientStop {position: 0.45; color: "#ffffff"}
            GradientStop {position: 0.5; color: "#000000"}
        }
    }

    Rectangle{
        id: rectLED_Indicator
        anchors.fill: rectLED_BG
        anchors.margins: 10

        radius: 0.5 * height
        color: compParamViewLEDRoot.isOn ? compParamViewLEDRoot.colorOn_Active : "#80ffffff"
        visible: true
    }

    RadialGradient{
        visible: !compParamViewLEDRoot.isUnknownValueText
        source: rectLED_Indicator
        anchors.fill: rectLED_Indicator
        gradient: Gradient{
            GradientStop {position: 0.0; color: "#80ffffff"}
            GradientStop {position: 0.5; color: "#80000000"}
        }
    }



}
