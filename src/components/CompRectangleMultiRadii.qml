import QtQuick 2.0
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12
import QtQuick.Shapes 1.12

Shape {
    id: compRectangleMultiRadii

    vendorExtensionsEnabled: true
    layer.enabled: true
    layer.samples: 4
    layer.smooth: true

    // set following properties to specify radius
    property real tlRadius: 42.0
    property real trRadius: 15.0
    property real brRadius: 0.0
    property real blRadius: 0.0
    property color color: "#8000ffff"

    ShapePath {
        strokeColor: compRectangleMultiRadii.color
        fillColor: compRectangleMultiRadii.color

        startX: 0; startY: compRectangleMultiRadii.tlRadius
        PathArc {
            x: compRectangleMultiRadii.tlRadius; y: 0
            radiusX: compRectangleMultiRadii.tlRadius; radiusY: compRectangleMultiRadii.tlRadius
            useLargeArc: false
        }
        PathLine {
            x: compRectangleMultiRadii.width - compRectangleMultiRadii.trRadius; y: 0
        }
        PathArc {
            x: compRectangleMultiRadii.width; y: compRectangleMultiRadii.trRadius
            radiusX: compRectangleMultiRadii.trRadius; radiusY: compRectangleMultiRadii.trRadius
            useLargeArc: false
        }
        PathLine {
            x: compRectangleMultiRadii.width; y: compRectangleMultiRadii.height - compRectangleMultiRadii.brRadius
        }
        PathArc {
            x: compRectangleMultiRadii.width - compRectangleMultiRadii.brRadius; y: compRectangleMultiRadii.height
            radiusX: compRectangleMultiRadii.brRadius; radiusY: compRectangleMultiRadii.brRadius
            useLargeArc: false
        }
        PathLine {
            x: compRectangleMultiRadii.blRadius; y: compRectangleMultiRadii.height
        }
        PathArc {
            x: 0; y: compRectangleMultiRadii.height - compRectangleMultiRadii.blRadius
            radiusX: compRectangleMultiRadii.blRadius; radiusY: compRectangleMultiRadii.blRadius
            useLargeArc: false
        }
        PathLine {
            x: 0; y: compRectangleMultiRadii.tlRadius
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
