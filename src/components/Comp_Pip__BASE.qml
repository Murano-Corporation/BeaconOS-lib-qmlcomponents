import QtQuick 2.15

Item{
    id: component_Pip__BASE

    property bool isPIPMode: true
    property bool dev_ShowRect: true
    property int fullViewWidth: 1920
    property int fullViewHeight: 1080

    property int pipViewWidth: 200
    property int pipViewHeight: 200

    property int pipViewX
    property int pipViewY

    property int fullViewX: 0
    property int fullViewY: 0

    height: pipViewHeight
    width: pipViewWidth
    x: pipViewX
    y: pipViewY
    z: isPIPMode ? 1 : 10

    onIsPIPModeChanged: {
        if( isPIPMode )
        {
            animToPiP.start()
        } else {
            animToFull.start()
        }
    }


    ParallelAnimation{
        id: animToFull

        NumberAnimation {
            target: component_Pip__BASE
            property: "height"
            duration: 100
            //from: pipViewHeight
            to: component_Pip__BASE.fullViewHeight
        }

        NumberAnimation {
            target: component_Pip__BASE
            property: "width"
            duration: 100
            //from: pipViewWidth
            to: component_Pip__BASE.fullViewWidth
        }

        NumberAnimation {
            target: component_Pip__BASE
            property: "x"
            duration: 100
            //from: pipViewX
            to: component_Pip__BASE.fullViewX
        }

        NumberAnimation {
            target: component_Pip__BASE
            property: "y"
            duration: 100
            //from: pipViewY
            to: component_Pip__BASE.fullViewY
        }


    }

    ParallelAnimation{
        id: animToPiP


        NumberAnimation {
            target: component_Pip__BASE
            property: "x"
            duration: 50
            //from: fullViewX
            to: component_Pip__BASE.pipViewX
        }

        NumberAnimation {
            target: component_Pip__BASE
            property: "y"
            duration: 50
            //from: fullViewY
            to: component_Pip__BASE.pipViewY
        }

        NumberAnimation {
            target: component_Pip__BASE
            property: "height"
            duration: 50
            //from: fullViewHeight
            to: component_Pip__BASE.pipViewHeight
        }

        NumberAnimation {
            target: component_Pip__BASE
            property: "width"
            duration: 50
            //from: fullViewWidth
            to: component_Pip__BASE.pipViewWidth
        }



    }

    //Behavior on x {
    //    NumberAnimation {
    //        duration: 50
    //    }
    //}

    //Behavior on y {
    //    NumberAnimation {
    //        duration: 50
    //    }
    //}


    //Behavior on height {
    //    NumberAnimation{
    //        duration: 50
    //    }
    //}

    //Behavior on width {
    //    NumberAnimation{
    //        duration: 50
    //    }
    //}

    Rectangle {
        id: rectBG_FullView

        opacity: isPIPMode ? 0.0 : 1.0
        color: "#AA000000"
        anchors.fill: parent

        Behavior on opacity {
            NumberAnimation {
                duration: 250
            }
        }
    }


    Rectangle{
        visible: component_Pip__BASE.dev_ShowRect
        anchors.fill: parent

        color: "red"

        border {
            width: 2
            color: "red"
        }
    }

    MouseArea {

        anchors.fill: parent

        onClicked: {
            component_Pip__BASE.isPIPMode = !component_Pip__BASE.isPIPMode
        }
    }
}
