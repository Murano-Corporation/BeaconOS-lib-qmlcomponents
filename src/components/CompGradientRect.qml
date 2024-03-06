import QtQuick 2.12
import QtGraphicalEffects 1.0

Comp__BASE {
    id: compGradientRectRoot

    property alias color1: gradientStop1.color
    property alias color2: gradientStop2.color
    property alias radius: unflippedBg.radius

    Rectangle {
        id: unflippedBg
        anchors.fill: parent
        radius: 24
        visible: false
        color: "red"
    }


    LinearGradient {
        id: linearGradientUnflippedBg
        source: unflippedBg
        cached: true
        anchors.fill: unflippedBg

        start: Qt.point(0, 0)
        end: Qt.point(0, unflippedBg.height)

        gradient: Gradient{
            GradientStop{
                id: gradientStop1
                position: 1.0;
                color: "#0F9287ED";
            }

            GradientStop{
                id: gradientStop2
                position: 0.0;
                color: "#599287ED";
            }
        }



    }

}
