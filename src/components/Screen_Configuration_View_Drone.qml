import QtQuick 2.15
import QtQuick.Controls 2.12

Screen_Configuration_View__BASE{
    id: screen_Configuration_View_Drone_ROOT

    function onReadClicked(){
        console.log("Read Clicked!!!")
    }

    function onWriteClicked(){
        console.log("Write Clicked!!!")
    }


    ListView{
        id: listView

        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: rowControls.top
            bottomMargin: 60
        }
    }

    Row{
        id: rowControls

        anchors{
            left: parent.left
            bottom: parent.bottom
            right: parent.right
        }

        height: 60
        spacing: 30
        RoundButton{
            id: btnRead

            text: "Read"
            height: parent.height
            onClicked:{
                screen_Configuration_View_Drone_ROOT.onReadClicked()
            }
        }

        RoundButton{
            id: btnWrite

            text: "Write"
            height: parent.height
            onClicked:{
                screen_Configuration_View_Drone_ROOT.onWriteClicked()
            }
        }
    }
}
