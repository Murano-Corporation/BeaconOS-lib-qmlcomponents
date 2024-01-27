import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

Popup {
    id: popupNsnViewerRoot

    property string nsn: "2530-01-598-5981"
    property color colorBG: "#80ffffff"
    property alias colorTitleText: lblTitle.color
    property alias titleText: lblTitle.text
    property alias btnHeight: btnClose.height
    property alias btnWidth: btnClose.width
    property alias listNsnValuesHeight: listNsnValues.height
    property alias listNsnValuesSpacing: listNsnValues.spacing
    property real minimumWidth: 600
    property real minimumHeight: 300
    property var nsnDetails: TableModelNsnDetails

    modal: false
    closePolicy: Popup.NoAutoClose
    background: Item{}
    //onNsnDetailsChanged: {
    //    console.log("NSN Details now: " + nsnDetails)
    //}
    onNsnChanged: {

        if(nsn === "")
        {
            console.warn("NO NSN HAS BEEN PROVIDED!!!")
            return
        }
        open()
        tmrDelayGetDetails.running = true;
    }

    Connections{
        target: DatabaseController

        onSignal_NsnInfoFetched: function(mapData)
        {
            rectPleaseWait.visible = false
        }

        onSignal_GetNsnInfo: function(){
            rectPleaseWait.visible = true
        }

        onSignal_Error_Open: function(){
            rectPleaseWait.visible = false
        }

        onSignal_Error: function(sTitle, sMessage){
            progress.visible = false
            lblPleaseWait.text = sTitle
            lblErrorMessage.text = sMessage
            lblErrorMessage.visible = true

        }
    }

    function close(){
        visible = false
        nsnDetails = undefined

    }



    Timer{
        id: tmrDelayGetDetails

        interval: 500
        onTriggered: {

            DatabaseController.signal_GetNsnInfo(popupNsnViewerRoot.nsn)
        }
    }

    CompResizableMoveableContainer{
        id: contentsRoot

        minimumHeight: popupNsnViewerRoot.minimumHeight
        minimumWidth: popupNsnViewerRoot.minimumWidth


        Component.onCompleted:{
            var startOrigin = SingletonOverlayManager.getPopupOrigin("NSN Viewer")
            var startSize = SingletonOverlayManager.getPopupSize("NSN Viewer")

            console.log("Setting start size to: " + startSize)
            console.log("Setting start origin to: " + startOrigin);

            contentsRoot.x = startOrigin.x
            contentsRoot.y = startOrigin.y
            contentsRoot.width = startSize.width
            contentsRoot.height = startSize.height
        }

        CompPopupBG{
            id: rectBG

            anchors{
                fill: parent
            }

        }

        Item{
            id: itemGroupTopRow

            anchors{
                left: parent.left
                leftMargin: 27
                right: parent.right
                rightMargin: 27
                top: parent.top
                topMargin: 22
            }

            height: childrenRect.height

            CompImageIcon{
                id: iconMessage

                anchors{
                    left: parent.left
                    verticalCenter: lblTitle.verticalCenter
                }

                height: 26
                width: 23

                source: "file:///usr/share/BeaconOS-lib-images/images/Reference.svg"
                color: "#9287ED"
            }

            CompLabel{
                id: lblTitle

                anchors{
                    top: parent.top
                    left: iconMessage.right
                    leftMargin: 16
                    right: btnClose.left
                    rightMargin: 16
                }

                text: qsTr("NSN Details - " + popupNsnViewerRoot.nsn)
                font{
                    pixelSize: 25

                }
            }

            BtnClose{
                id: btnClose

                imageIcon{

                    image{
                        antialiasing: true
                        smooth: true
                        cache: true
                    }

                    colorOverlay{
                        antialiasing: true
                        smooth: true
                        cached: true
                    }

                }

                anchors{
                    right: parent.right
                    verticalCenter: lblTitle.verticalCenter
                }

                height: 22
                width: 22

                onClicked: {
                    console.log("Closing popup NSN viewer")
                    popupNsnViewerRoot.close()
                }

            }


        }

        Rectangle{
            id: rectSepTopRow

            anchors{
                left: itemGroupTopRow.left
                right: itemGroupTopRow.right
                top: itemGroupTopRow.bottom
                topMargin: 18

            }

            height: 2
            radius: height * 0.5
            color: "#33ffffff"
        }


        Rectangle{
            id: rectBG_List

            anchors{
                top: rectSepTopRow.bottom
                topMargin: 10
                left: rectSepTopRow.left

                right: rectSepTopRow.right
                bottom: parent.bottom
                bottomMargin: 22

            }

            color: "#20000000"
            radius: 16

            ListView{
                id: listNsnValues

                property real rowHeight: 64
                property real longestKeyNameWidth: 200

                spacing: 20

                clip: true
                anchors{
                    fill: parent
                    margins: 20
                }


                model: popupNsnViewerRoot.nsnDetails
                delegate: CompNsnTableItem {
                    id: compNsnTableItem

                    keyName: model.field_name_pretty
                    value: model.value

                    height: listNsnValues.rowHeight
                    width: listNsnValues.width

                    listLongestKeyWidth: listNsnValues.longestKeyNameWidth

                    onKeyWidthUpdated: {
                        listNsnValues.longestKeyNameWidth = newWidth
                    }

                }
            }

            Rectangle{
                id: rectPleaseWait

                visible: false

                anchors{
                    fill: parent
                }
                radius: 16
                color: "#B0000000"

                clip: true

                Item{
                    id: groupPleaseWait

                    anchors{
                        centerIn: parent
                    }

                    width: rectPleaseWait.width
                    height: childrenRect.height

                    CompLabel{
                        id: lblPleaseWait
                        anchors{
                            top: parent.top
                            horizontalCenter: groupPleaseWait.horizontalCenter
                        }

                        text: qsTr("Fetching Data")

                        font{
                            pixelSize: 40
                        }
                    }

                    CompLabel{
                        id: lblErrorMessage
                        visible:  false
                        anchors{
                            top: lblPleaseWait.bottom
                            horizontalCenter: lblPleaseWait.horizontalCenter
                        }

                        width: rectPleaseWait.width
                        wrapMode: Text.WordWrap

                        text: qsTr("Fetching Data")

                        font{
                            pixelSize: 28
                            weight: Font.Light
                        }
                    }

                    ProgressBar{
                        id: progress
                        indeterminate: true

                        anchors{
                            top: lblPleaseWait.bottom
                            horizontalCenter: lblPleaseWait.horizontalCenter
                        }

                    }


                }


            }

        }



    }


}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";formeditorZoom:0.2;height:1080;width:1920}
}
##^##*/
