import QtQuick 2.15
import QtQuick.Controls 2.15
import CONSTANTS 1.0

Item {
    id: compTargetBoundingBox1

    property alias boundingBox: boundingBoxItem
    property real imageWidth: 1920
    property real imageHeight: 1080

    property var detectionInfo: {
        x: 10
        y: 10
        width: 200
        height: 200
    }

    onDetectionInfoChanged: {

        // Scale the output based on the size difference
        var widthRatio = 1920 / imageWidth
        var heightRatio = 1080 / imageHeight

        compTargetBoundingBox1.width = detectionInfo.width * widthRatio
        compTargetBoundingBox1.height = detectionInfo.height * heightRatio
        compTargetBoundingBox1.x = detectionInfo.x * widthRatio
        compTargetBoundingBox1.y = detectionInfo.y * widthRatio

        // Center the bb
        compTargetBoundingBox1.y -= 0.5 * compTargetBoundingBox1.height
        compTargetBoundingBox1.x -= 0.5 * compTargetBoundingBox1.width

        // Scale the corner sizes
        var widthMax = 270
        var heightMax = 123
        var widthMin = 10
        var heightMin = 10

        var newWidth = widthMax
        var newHeight = heightMax

        if( detectionInfo.width < ((widthMax * 2) - 40) )
        {
            newWidth = 0.5 * (detectionInfo.width - 40)
        }

        if( detectionInfo.height < ((heightMax * 2) - 40) )
        {
            newHeight = 0.5 * (detectionInfo.height - 40)
        }

        if( newWidth < widthMin )
            newWidth = widthMin

        if( newHeight < heightMin )
            newHeight = heightMin

        boundingBoxItem.lengthHorizontal = newWidth
        boundingBoxItem.lengthVertical = newHeight
    }





    Item {
        id: boundingBoxItem

        property int thickness: 2
        property int lengthHorizontal: 270
        property int lengthVertical: 123
        property int radius: 16
        property color color: "#00FF94"
    }

    Item {
        id: bbTopLeft

        anchors{
            top: parent.top
            left: parent.left
        }

        height: boundingBoxItem.lengthVertical
        width: boundingBoxItem.lengthHorizontal

        Rectangle{
            anchors.top: parent.top
            color: boundingBoxItem.color
            height: boundingBoxItem.thickness
            width: boundingBoxItem.lengthHorizontal
            radius: boundingBoxItem.radius
        }
        Rectangle{
            anchors.left: parent.left
            color: boundingBoxItem.color
            height: boundingBoxItem.lengthVertical
            width:boundingBoxItem.thickness
            radius: boundingBoxItem.radius
        }

    }

    Item {
        id: bbTopRight

        anchors{
            top: parent.top
            right: parent.right
        }

        height: boundingBoxItem.lengthVertical
        width: boundingBoxItem.lengthHorizontal

        Rectangle{
            anchors.top: parent.top
            color: boundingBoxItem.color
            height: boundingBoxItem.thickness
            width: boundingBoxItem.lengthHorizontal
            radius: boundingBoxItem.radius
        }
        Rectangle{
            anchors.left: parent.right
            color: boundingBoxItem.color
            height: boundingBoxItem.lengthVertical
            width:boundingBoxItem.thickness
            radius: boundingBoxItem.radius
        }

    }

    Item {
        id: bbBotRight

        anchors{
            bottom: parent.bottom
            right: parent.right
        }
        height: boundingBoxItem.lengthVertical
        width: boundingBoxItem.lengthHorizontal

        Rectangle{
            anchors.top: parent.bottom
            color: boundingBoxItem.color
            height: boundingBoxItem.thickness
            width: boundingBoxItem.lengthHorizontal
            radius: boundingBoxItem.radius
        }
        Rectangle{
            anchors.left: parent.right
            color: boundingBoxItem.color
            height: boundingBoxItem.lengthVertical
            width:boundingBoxItem.thickness
            radius: boundingBoxItem.radius
        }

    }

    Item {
        id: bbBotLeft

        anchors{
            bottom: parent.bottom
            left: parent.left
        }

        height: boundingBoxItem.lengthVertical
        width: boundingBoxItem.lengthHorizontal

        Rectangle{
            anchors.top: parent.bottom
            color: boundingBoxItem.color
            height: boundingBoxItem.thickness
            width: boundingBoxItem.lengthHorizontal
            radius: boundingBoxItem.radius
        }
        Rectangle{
            anchors.left: parent.left
            color: boundingBoxItem.color
            height: boundingBoxItem.lengthVertical
            width:boundingBoxItem.thickness
            radius: boundingBoxItem.radius
        }

    }




}
