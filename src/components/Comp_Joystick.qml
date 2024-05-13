import QtQuick 2.0
import QtQuick3D 1.15
import QtQuick.Controls 2.15

Item{
    id: compJoystickRoot

    required property string joystickName
    property real inputX: 0.0
    property real inputY: 0.0

    anchors{
    }

    height: 180
    width: 180

    function getInputVector(){
        var x = 0.0
        var y = 0.0

        var vector2D
        vector2D.x = x
        vector2D.y = y

        return vector2D
    }

    function returnToCenter(){
        rectJoystickCenter.x = (rectOutter.width * 0.5) - (rectJoystickCenter.width * 0.5)
        rectJoystickCenter.y = (rectOutter.height * 0.5) - (rectJoystickCenter.height * 0.5)
    }

    Rectangle{
        id: rectOutter
        anchors.fill: parent

        color: "#80000000"
        radius: 0.5 * height
        border{
            width: 8
            color: "#AA000000"
        }

        Rectangle{
            id: rectJoystickCenter

            //anchors.centerIn: parent

            x: (parent.width * 0.5) - (width * 0.5)
            y: (parent.height * 0.5) - (height * 0.5)

            height: 60
            width: 60
            radius: 0.5 * height


            color: "green"

            onXChanged: {


                var x_center = (x + (width * 0.5))
                var x_ratio = (x_center / (rectOutter.width - (width * 2))) - 1.5

                if(x_ratio > 1.0)
                    x_ratio = 1.0
                else if(x_ratio < -1.0)
                    x_ratio = -1.0

                compJoystickRoot.inputX = x_ratio

            }

            onYChanged: {

                var y_center = (y + (height * 0.5))
                var y_ratio = (y_center / (rectOutter.height - (height * 2))) - 1.5

                //console.log("Y Ratio: " + -y_ratio)
                if(y_ratio > 1.0)
                    y_ratio = 1.0
                else if(y_ratio < -1.0)
                    y_ratio = -1.0

                compJoystickRoot.inputY = -y_ratio
            }

            function centerOnPoint(point2D)
            {
                var x_adjusted = point2D.x - (width * 0.50)
                var y_adjusted = point2D.y - (height * 0.50)

                x = x_adjusted
                y = y_adjusted
            }

        }
    }

    MultiPointTouchArea{
        anchors.fill: parent

        property int minimumX: 0
        property int maximumX: width
        property int minimumY: 0
        property int maximumY: height

        maximumTouchPoints: 1

        onTouchUpdated: {
            //console.log("Joystick: " + joystickName + " touch updated: " + touchPoints.length)

            if( touchPoints.length === 1 )
            {
                var touchPoint = touchPoints[0]

                var touch_x = touchPoint.x
                var touch_y = touchPoint.y

                if(touch_x < minimumX)
                {
                    touch_x = minimumX
                }  else if(touch_x > maximumX)
                {
                    touch_x = maximumX
                }

                if(touch_y < minimumY)
                {
                    touch_y = minimumY
                }  else if(touch_y > maximumY)
                {
                    touch_y = maximumY
                }

                var pt = {x: touch_x, y: touch_y}

                rectJoystickCenter.centerOnPoint(pt)

            }

        }

        onReleased: {
            compJoystickRoot.returnToCenter();
        }
    }

    // MouseArea{
        // id: mouseAreaMove

        // anchors.fill: parent

        //drag{
        //    target: rectJoystickCenter
        //    minimumX: 0
        //    maximumX: width - rectJoystickCenter.width
        //    axis: Drag.XandYAxis
        //    minimumY: 0
        //    maximumY: height - rectJoystickCenter.height
        //}

        //allowStealing: true

        //onMouseXChanged: {
        //    console.log(joystickMove.joystickName + " MouseX Changed: " + mouseX)
        //}

        //onMouseYChanged: {
        //    console.log(joystickMove.joystickName + " MouseY Changed: " + mouseY)
        //}

        //onReleased: {
        //    joystickMove.returnToCenter();
        //}


    //}


}
