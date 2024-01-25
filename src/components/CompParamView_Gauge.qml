import QtQuick 2.12
import QtQuick.Extras 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Shapes 1.12
import QtGraphicalEffects 1.0

Item {
    id: compParamViewGaugeRoot

    property alias value: gaugeInner.value
    property alias valueText: lblValue.text
    property alias min: gaugeInner.minimumValue
    property alias max: gaugeInner.maximumValue
    property alias paramName: lblParamName.text
    property alias units: lblUnits.text
    property int severity: 0

    property real calcdStepSize: (max - min) / 10
    property alias stepSize: gaugeInner.stepSize
    property color severityColor: (severity === 0 ? severityColor_0 : (severity === 1 ? severityColor_1 : severityColor_2))
    property color severityColor_0: "#73A263"
    property color severityColor_1: "#CDC05B"
    property color severityColor_2: "#B4536A"

    property real gaugeMinAngle: -130
    property real gaugeMaxAngle: 130

    property real gaugeMinRadians: (gaugeMinAngle * (Math.PI/180))
    property real gaugeMaxRadians: (gaugeMaxAngle * (Math.PI/180))
    property real radianOffset: (90 * (Math.PI/180))

    property real gaugeValueMinMaxDiff: (max - min)
    property real gaugeValueMinDiff: (value - min)
    property real valPercent: (gaugeValueMinDiff / gaugeValueMinMaxDiff)
    onValPercentChanged: {
        canvasSeverityMeter.requestPaint()
    }

    width: 340
    height: 355

    Rectangle{
        id: rectBg

        anchors{
            fill: gaugeInner
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

    CircularGauge {
        id: gaugeInner

        property string text: ""
        //tickmarksVisible: false
        maximumValue: 10
        minimumValue: -10
        value: 0
        stepSize: 0.1
        //property real minimumValue: 0
        //property real maximumValue: 0

        height: width
        //        stepSize: 1
        //        value: 150
        //        minimumValue: 0
        //        maximumValue: 220

        anchors{
            top: compParamViewGaugeRoot.top
            topMargin: 20
            left: compParamViewGaugeRoot.left
            leftMargin: 20
            right: compParamViewGaugeRoot.right
            rightMargin: 20
        }

        style: CircularGaugeStyle{
            labelStepSize: ((control.maximumValue - control.minimumValue) / 10)
            tickmarkStepSize: labelStepSize
            minorTickmarkCount: 9
            minimumValueAngle: compParamViewGaugeRoot.gaugeMinAngle
            maximumValueAngle: compParamViewGaugeRoot.gaugeMaxAngle

            tickmark: Rectangle{
                color: "white"
                width: 2
                height: 12
                radius: 0.5 * width
                y: -height * 0.5
            }

            minorTickmark: Rectangle{
                color: "white"
                width: 1
                height: 6
                radius: 0.5 * width
                y: -height * 0.25
            }

            needle: Image {
                source: "file:///usr/share/BeaconOS-lib-images/images/GaugeNeedle.svg"
                sourceSize: Qt.size(width, height)

                width: 4
                height: (gaugeInner.height * 0.5) - 10
                antialiasing: true
            }

            foreground: Item{
                Rectangle{
                    anchors{
                        centerIn: parent
                    }

                    height: outerRadius * 0.1
                    width: height
                    radius: height * 0.5
                    color: "White"
                }
            }

            tickmarkLabel: CompLabel{
                text: styleData.value.toFixed(0)

                font{
                    pixelSize: 12
                }
                color: "White"
            }


        }
    }

    CompLabel {
        id: lblParamName

        anchors{
            top: lblUnits.bottom
            topMargin: 20
            left: compParamViewGaugeRoot.left
            right: compParamViewGaugeRoot.right

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
            bottom: gaugeInner.bottom
            bottomMargin: 40
            horizontalCenter: gaugeInner.horizontalCenter
        }

        font{
            pixelSize: 32
            weight: Font.Normal
        }


    }

    CompLabel {
        id: lblUnits

        anchors{
            top: lblValue.bottom
            horizontalCenter: lblValue.horizontalCenter
        }

        text: compParamViewGaugeRoot.units

        font{
            pixelSize: 17
            weight: Font.Light

        }
    }

    Canvas {
        id: canvasSeverityMeter

        anchors{
            centerIn: gaugeInner

        }
        width: parent.width
        height: width

        onPaint: {
            var ctx = getContext("2d");
            ctx.reset;
            ctx.clearRect(0,0, width, height);

            var centerX = width * 0.5;
            var centerY = height * 0.5;
            var arcRadius = width * 0.48;
            var antiCW = false;
            var strokeWidth = 4

            ///IN RADS
            var angleStart = -(2.26893 + 1.5708);

            var angleEnd = 2.26893- 1.5708;
            var angleDiff = angleEnd - angleStart
            angleEnd = angleStart + (angleDiff * compParamViewGaugeRoot.valPercent)


            ctx.strokeStyle = compParamViewGaugeRoot.severityColor;
            ctx.lineWidth = strokeWidth;
            ctx.lineCap = "round";


            ctx.moveTo(centerX, centerY);

            ctx.beginPath();
            ctx.arc(centerX, centerY, arcRadius, angleStart, angleEnd, antiCW);
            ctx.stroke();
            ctx.closePath();
        }

    }



}

/*##^##
Designer {
    D{i:0;formeditorColor:"#000000"}
}
##^##*/
