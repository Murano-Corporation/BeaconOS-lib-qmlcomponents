import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQml 2.12


Comp__BASE {
    id: compInfoPanel

    height: 200
    width: 589

    property int taskCompleteValue: 75
    property int workOrdersRemain: 2
    property date currentDate: new Date()
    property string dateString: " "
    property var dateFormatOptions: {
        weekday: 'long'
        month: 'long'
        day: 'numeric'
    }

    Component.onCompleted: {

        dateString = SingletonUtils.slot_GetDateFormat("dddd, MMMM d")
    }

    Column {

        anchors.fill: parent

        Label {
            id: lblDateTime

            text: compInfoPanel.dateString
            color: "White"
            font {
                pixelSize: 40
                family: "Lato"
            }

            height: 53
        }

        Rectangle {
            id: lineH

            width: parent.width
            height: 2
            color: "#80FFFFFF"
        }

        Item {
            id: spacer
            height: 57
            width: 2
        }

        Row {

            spacing: 22

            ProgressBar {
                height: 74
                width: 74
            }

            Column {
                spacing: 5

                Row {
                    Label {
                        text: "Today's tasks: "
                        color: "White"
                        font.family: "Lato"
                        font.pixelSize: 32
                        font.weight: Font.Medium
                    }

                    Label {
                        text: "" + compInfoPanel.taskCompleteValue + "% Complete."
                        color: "White"
                        font.family: "Lato"
                        font.pixelSize: 32
                        font.weight: Font.Light
                    }
                }

                Label {
                    text: compInfoPanel.workOrdersRemain + " work orders remaining."
                    color: "White"
                    font.family: "Lato"
                    font.pixelSize: 32
                    font.weight: Font.Light
                }
            }
        }
    }
}
