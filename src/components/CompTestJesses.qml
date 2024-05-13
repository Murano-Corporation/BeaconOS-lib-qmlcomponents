import QtQuick 2.0

Item {

    height: 500
    width: 1080

    Rectangle{
        width: 60
        height: 60

        color: "#80FF0000"

        anchors{
            fill: parent

            topMargin: parent.height * 0.5
            leftMargin: 20
        }
    }

    Rectangle{
        color: "Blue"

        height: 90
        width: 90

        x: 200
        y: 1000
    }

}
