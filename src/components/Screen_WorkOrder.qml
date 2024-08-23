import QtQuick 2.0

Screen__BASE {
    id: popupWorkOrderViewer

    property string workOrderCurrent: ""
    property string sectionCurrent: ""
    readonly property bool allSectionsComplete: false
    property var listOfSections: ListModel{
        ListElement {
            section_name: 'Parts List'
            is_complete: false
            is_enabled: true
        }

        ListElement {
            section_name: 'Review'
            is_complete: false
            is_enabled: false
        }

        ListElement {
            section_name: 'Submit'
            is_complete: false
            is_enabled: false
        }
    }


    screenName: "Work Orders"


    function onCloseClicked(){
        console.log("Attempting to close Work Order Popup")
    }


    Rectangle{
        id: rectBg

        anchors.fill: parent
        color: "#80000000"


    }

    Rectangle{
        id: rectPopupInfo

        color: "#80000000"
        height: 64
        anchors{
            top: parent.top
            topMargin: 20
            left: parent.left
            leftMargin: 20
            right: parent.right
            rightMargin: 20
        }


        CompLabel{
            id: lblTitle

            text: "Work Order - " + popupWorkOrderViewer.workOrderCurrent
            anchors{
                top: parent.top
                left: parent.left
                bottom: parent.bottom
            }
        }

        CompButton{
            id: btnClose

            text: "X"

            anchors{
                top: parent.top
                right: parent.right
                bottom: parent.bottom
            }

            width: height

            onClicked: popupWorkOrderViewer.onCloseClicked()
        }
    }

    Rectangle{
        id: rectCheckList

        width: 400
        color: "#80000000"
        anchors{
            top: rectPopupInfo.bottom
            topMargin: 20
            left: rectPopupInfo.left
            bottom: rectControls.top
            bottomMargin: 20
        }

        ListView {
            id: listviewSections

            property int itemHeight: 64

            anchors.fill: parent
            anchors.margins: 10

            model: popupWorkOrderViewer.listOfSections
            delegate: Item {
                id: compWorkOrderSectionItem

                property string sectionName: model.section_name
                property bool isEnabled: model.is_enabled
                property bool isComplete: model.is_complete

                width: listviewSections.width
                height: listviewSections.itemHeight

                signal itemClicked(var model)

                CompImageIcon{
                    id: iconState

                    width: height
                    anchors{
                        top: parent.top
                        left: parent.left
                        bottom: parent.bottom
                    }


                }

                CompLabel{
                    id: lblSectionName

                    text: parent.sectionName
                    anchors{
                        top: parent.top
                        left: iconState.right
                        bottom: parent.bottom
                        right: parent.right
                    }
                }

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        compWorkOrderSectionItem.itemClicked(parent.model)
                    }
                }
            }
        }
    }

    Rectangle{
        id: rectContents

        color: "#80000000"
        anchors{
            top: rectCheckList.top
            left: rectCheckList.right
            leftMargin: 20
            bottom: rectCheckList.bottom
            right: rectPopupInfo.right
        }
    }

    Rectangle{
        id: rectControls

        color: "#80000000"
        anchors{
            left: rectPopupInfo.left
            bottom: rectBg.bottom
            bottomMargin: 20
            right: rectPopupInfo.right
        }

        height: 90
    }
}
