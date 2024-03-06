import QtQuick 2.0

Comp__BASE {
    id: compResizableMoveableContainerRoot

    property bool showDevLabels: false

    property real dragAreaHeight: 40
    property real dragAreaWidth: 40

    property int minX: 0
    property int minY: 0

    property int maxX: root.contentItem.width - dragAreaWidth
    property int maxY: root.contentItem.height - dragAreaHeight

    property real minimumWidth: 400
    property real minimumHeight: 300

    property real moveAreaRightOffset: 40

    property int xBeforeStash
    property int yBeforeStash

    Component.onCompleted:{
        rectBG_Resize.ignoreChanges = true

        rectBG_Resize.x = mouseAreaResize.x
        rectBG_Resize.y = mouseAreaResize.y

        rectBG_Resize.ignoreChanges = false
    }


    Rectangle{
        id: rectBG_Resize

        z: 1000
        height: compResizableMoveableContainerRoot.dragAreaHeight
        width: compResizableMoveableContainerRoot.dragAreaWidth

        visible: false
        color: "#80000000"


        property real xLast: x
        property real yLast: y
        property bool ignoreChanges: true

        onXChanged: {
            if(mouseAreaResize.isDragging === false || (x === xLast) || ignoreChanges)
            {
                return
            }

            var delta = (xLast - x)
            var widthDelta = parent.width - delta

            if(widthDelta < compResizableMoveableContainerRoot.minimumWidth)
                widthDelta = compResizableMoveableContainerRoot.minimumWidth

            compResizableMoveableContainerRoot.width = widthDelta
            xLast = x
        }

        onYChanged: {
            if(mouseAreaResize.isDragging === false || (y === yLast) || ignoreChanges)
            {
                return
            }

            var delta = (yLast - y)
            var heightDelta = parent.height - delta

            if(heightDelta < compResizableMoveableContainerRoot.minimumHeight)
                heightDelta = compResizableMoveableContainerRoot.minimumHeight

            compResizableMoveableContainerRoot.height = heightDelta
            yLast = y
        }


    }




    MouseArea{
        id: mouseAreaMove

        property bool isDragging: false

        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
            rightMargin: compResizableMoveableContainerRoot.moveAreaRightOffset
        }

        height: compResizableMoveableContainerRoot.dragAreaHeight


        drag{
            target: parent
            axis: Drag.XAndYAxis
            minimumX: compResizableMoveableContainerRoot.minX
            minimumY: compResizableMoveableContainerRoot.minY

            maximumX: compResizableMoveableContainerRoot.maxX
            maximumY: compResizableMoveableContainerRoot.maxY

            onActiveChanged: {
                if(active === true)
                {
                    parent.anchors.centerIn = undefined
                    mouseAreaMove.isDragging = true
                }
                else
                    console.log("Drag Ended")
            }

        }
    }

    MouseArea{
        id: mouseAreaResize

        property real dragStartX: 0
        property real dragStartY: 0
        property bool isDragging: false

        anchors{
            right: parent.right
            bottom: parent.bottom

        }

        height: 40
        width: 40

        drag{
            target: rectBG_Resize
            axis: Drag.XAndYAxis
            minimumX: compResizableMoveableContainerRoot.minimumWidth + (rectBG_Resize.x - x)
            minimumY: compResizableMoveableContainerRoot.minimumHeight + (rectBG_Resize.y - y)

            onActiveChanged: {
                if(active === true)
                {
                    mouseAreaResize.isDragging = true
                    mouseAreaResize.dragStartX = rectBG_Resize.x
                    mouseAreaResize.dragStartY = rectBG_Resize.y
                }
                else
                    console.log("Drag Ended")
            }

        }



    }


    Loader{
        id: loaderDevLabels

        active: compResizableMoveableContainerRoot.showDevLabels
        anchors{
            left: parent.left
            leftMargin: 40
            bottom: parent.bottom
        }

        sourceComponent: CompLabel{
            id: dev_lblSize
            z: 100


            text: "w: " + compResizableMoveableContainerRoot.width + " h: " + compResizableMoveableContainerRoot.height + " x: " + compResizableMoveableContainerRoot.x + " y: " + compResizableMoveableContainerRoot.y
            color: "#80ffffff"

            font{
                pixelSize: 10
                weight: Font.Bold
            }
        }

    }




}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
