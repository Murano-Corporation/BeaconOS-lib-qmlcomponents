import QtQuick 2.12
import QtQuick.Controls 2.12

Comp__BASE {
    id: compCameraViewFinderRoot

    property real viewFinderWidth: 137
    property real viewFinderHeight: 4
    property color viewFinderColor: isViewMode ? "#9287ED" : "#8F9499"
    property real viewFinderRadius: 2
    property real viewFinderVerticalOffset: 10
    property real viewFinderHorizontalOffset: (10 + viewFinderHeight)

    property bool isViewMode: false

    Rectangle{
        id: viewFinderTL

        anchors{
            bottom: parent.top
            bottomMargin: compCameraViewFinderRoot.viewFinderVerticalOffset
            left: parent.left
            leftMargin: -compCameraViewFinderRoot.viewFinderHorizontalOffset
        }

        height: compCameraViewFinderRoot.viewFinderHeight
        width:   compCameraViewFinderRoot.isViewMode ? parent.width : compCameraViewFinderRoot.viewFinderWidth
        radius: compCameraViewFinderRoot.viewFinderRadius

        color: compCameraViewFinderRoot.viewFinderColor
    }

    Rectangle{
        anchors{
            top: viewFinderTL.top
            left: viewFinderTL.left
        }

        height: compCameraViewFinderRoot.viewFinderWidth
        width: compCameraViewFinderRoot.viewFinderHeight
        color: compCameraViewFinderRoot.viewFinderColor
        radius: compCameraViewFinderRoot.viewFinderRadius
    }

    Rectangle{
        id: viewFinderTR

        anchors{
            bottom: parent.top
            bottomMargin: compCameraViewFinderRoot.viewFinderVerticalOffset
            right: parent.right
            rightMargin: -compCameraViewFinderRoot.viewFinderHorizontalOffset
        }

        height: compCameraViewFinderRoot.viewFinderHeight
        width: compCameraViewFinderRoot.viewFinderWidth
        radius: compCameraViewFinderRoot.viewFinderRadius

        color: compCameraViewFinderRoot.viewFinderColor
    }

    Rectangle{
        anchors{
            top: viewFinderTR.top
            right: viewFinderTR.right
        }

        height: compCameraViewFinderRoot.isViewMode ? parent.height : compCameraViewFinderRoot.viewFinderWidth
        width: compCameraViewFinderRoot.viewFinderHeight
        color: compCameraViewFinderRoot.viewFinderColor
        radius: compCameraViewFinderRoot.viewFinderRadius
    }

    Rectangle{
        id: viewFinderBR

        anchors{
            top: parent.bottom
            topMargin: compCameraViewFinderRoot.viewFinderVerticalOffset
            right: parent.right
            rightMargin: -compCameraViewFinderRoot.viewFinderHorizontalOffset
        }

        height: compCameraViewFinderRoot.viewFinderHeight
        width: compCameraViewFinderRoot.isViewMode ? parent.width : compCameraViewFinderRoot.viewFinderWidth
        radius: compCameraViewFinderRoot.viewFinderRadius

        color: compCameraViewFinderRoot.viewFinderColor
    }

    Rectangle{
        anchors{
            bottom: viewFinderBR.bottom
            right: viewFinderBR.right
        }

        height: compCameraViewFinderRoot.viewFinderWidth
        width: compCameraViewFinderRoot.viewFinderHeight
        color: compCameraViewFinderRoot.viewFinderColor
        radius: compCameraViewFinderRoot.viewFinderRadius
    }

    Rectangle{
        id: viewFinderBL

        anchors{
            top: parent.bottom
            topMargin: compCameraViewFinderRoot.viewFinderVerticalOffset
            left: parent.left
            leftMargin: -compCameraViewFinderRoot.viewFinderHorizontalOffset
        }

        height: compCameraViewFinderRoot.viewFinderHeight
        width: compCameraViewFinderRoot.viewFinderWidth
        radius: compCameraViewFinderRoot.viewFinderRadius

        color: compCameraViewFinderRoot.viewFinderColor
    }

    Rectangle{
        anchors{
            bottom: viewFinderBL.bottom
            left: viewFinderBL.left
        }

        height: compCameraViewFinderRoot.isViewMode ? parent.height : compCameraViewFinderRoot.viewFinderWidth
        width: compCameraViewFinderRoot.viewFinderHeight
        color: compCameraViewFinderRoot.viewFinderColor
        radius: compCameraViewFinderRoot.viewFinderRadius
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.9;height:480;width:640}
}
##^##*/
