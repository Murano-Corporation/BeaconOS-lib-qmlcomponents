import QtQuick 2.12
import QtQuick.Controls 2.12
import Qt.labs.qmlmodels 1.0

Popup{
    id: popupChatAi
    modal: false
    closePolicy: Popup.NoAutoClose

    property real textFont: 16
    property real widthofContents: 0.75
    property real responsesHeight: 32

    property alias messageIcon: iconMessage
    property alias titleLbl: lblTitle
    property alias expandIcon: iconExpand
    property alias textFont: popupChatAi.textFont
    property alias widthofmodelData: popupChatAi.widthofContents
    property alias inputTxtMsg: edtMessage
    property alias heightofResponses: popupChatAi.responsesHeight

    background: Item{}

    CompResizableMoveableContainer {
        id: compConvAiChatRoot

        property string beaconID
        property string assetID
        property var mapData
        property var modelChat: TableModelChat
        //onModelChatChanged: {
        //    console.log("Model Chat changed!!!")
        //}

        property var listMessages

        property var listQuickResponses: []

        signal userMessageSent(string message)

        function clearMessages(){
            //console.log('Clearing messages...')
            TableModelChat.clear()
            listQuickResponses = []
        }


        function onUserMessageEntered(user_msg){
            //console.log('User Message entered: ' + user_msg)
            ChatControllerAI.slot_UserSentMessage(beaconID, assetID, user_msg)
            userMessageSent(user_msg)
        }

        function onUserClickedCancel(){
            dlgYesNo.headerText = qsTr("End Chat Session?")
            dlgYesNo.bodyText = qsTr("Are you sure you want to end this Chat Session?")
            dlgYesNo.funcOnYes = function(){
                dlgYesNo.close();
                ChatControllerAI.chatSessionActive = false;
                popupChatAi.close();

            }

            dlgYesNo.funcOnNo = function(){
                dlgYesNo.close();
            }

            dlgYesNo.open()
        }

        Component.onCompleted:{
            var startOrigin = SingletonOverlayManager.getPopupOrigin("Chat AI")
            var startSize = SingletonOverlayManager.getPopupSize("Chat AI")

            console.log("Chat AI defaulting to: " + startOrigin + " : " + startSize)

            compConvAiChatRoot.x = startOrigin.x
            compConvAiChatRoot.y = startOrigin.y
            compConvAiChatRoot.width = startSize.width
            compConvAiChatRoot.height = startSize.height
        }

        CompPopupBG{
            id: rectPanelBG

            anchors{
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            Item {
                id: groupTopRow

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

                    source: "file:///usr/share/BeaconOS-lib-images/images/Message.svg"
                    color: "#9287ED"
                }

                CompLabel{
                    id: lblTitle

                    anchors{
                        top: parent.top
                        left: iconMessage.right
                        leftMargin: 16
                        right: iconExpand.left
                        rightMargin: 16
                    }

                    text: qsTr("Chat with Beacon AI")

                    font{
                        pixelSize: 25
                    }
                }

                CompImageIcon{
                    id: iconExpand

                    anchors{
                        right: btnClose.left
                        rightMargin: 20
                        verticalCenter: lblTitle.verticalCenter
                    }

                    height: 21
                    width: 21
                    source: "file:///usr/share/BeaconOS-lib-images/images/Expand.png"
                    color: "#ffffff"
                }

                BtnClose {
                    id: btnClose
                    anchors.right: parent.right
                    anchors.verticalCenter: lblTitle.verticalCenter
                    height: iconExpand.height
                    width: iconExpand.width

                    onClicked: {
                        compConvAiChatRoot.onUserClickedCancel()
                    }
                }
            }

            Rectangle{
                id: rectSepTopRow

                anchors{
                    left: groupTopRow.left
                    right: groupTopRow.right
                    top: groupTopRow.bottom
                    topMargin: 18

                }

                height: 2
                radius: height * 0.5
                color: "#33ffffff"
            }

            Item{
                id: groupTimestamp
                anchors{
                    top: rectSepTopRow.bottom
                    topMargin: 24
                    horizontalCenter: rectSepTopRow.horizontalCenter

                }

                height: childrenRect.height
                width: childrenRect.width

                CompLabel{
                    id: lblTimestampDay

                    anchors{
                        left:parent.left
                    }

                    text: qsTr('Today')

                    font{
                        pixelSize: textFont
                        weight: Font.Bold
                    }
                }

                CompLabel{
                    id: lblTimestampTime

                    anchors{
                        left: lblTimestampDay.right
                        leftMargin: 4
                    }

                    text: "1:53 PM"

                    font{
                        pixelSize: textFont
                    }

                }

            }

            Rectangle{
                id: rectChatBg

                anchors{
                    top: groupTimestamp.bottom
                    left: groupTopRow.left
                    right: groupTopRow.right
                    bottom: groupChatControls.top
                    topMargin: 10


                    bottomMargin: 10
                }

                color: "#20000000"
                radius: 16

                ListView{
                    id: listChatEntries

                    property real chatEntryWidth: width * widthofContents

                    clip: true
                    highlightFollowsCurrentItem: true
                    anchors{
                        fill: parent
                        margins: 10
                    }

                    model: compConvAiChatRoot.modelChat

                    onCountChanged: {

                        currentIndex = count-1
                    }

                    //Connections{
                    //    target: compConvAiChatRoot
                    //
                    //    onListMessagesUpdated: {
                    //        listChatEntries.model = compConvAiChatRoot.listMessages
                    //    }
                    //}

                    spacing: 20

                    DelegateChooser{
                        id: delChooser
                        role: 'data_type'
                        DelegateChoice {
                            roleValue: 'message'

                            Rectangle{

                                property string source: model.source
                                property string message: model.message
                                property bool isUserMsg: source === 'user'

                                radius: 10

                                height: childrenRect.height
                                width: Math.min((listChatEntries.chatEntryWidth), ((radius * 3) + (lblMessage.fontMetrics.boundingRect(message).width)))

                                color: source === "user" ? "white" : "blue"

                                anchors.left: isUserMsg ? undefined : parent.left
                                anchors.leftMargin: isUserMsg ? 20 : 0
                                anchors.right: isUserMsg ? parent.right : undefined
                                anchors.rightMargin: isUserMsg ? 0 : 20

                                CompLabel{
                                    id: lblMessage

                                    property alias fontMetrics: fontMx

                                    anchors{
                                        top: parent.top

                                        left: parent.left
                                        leftMargin: 10
                                        right: parent.right
                                        rightMargin: 10
                                    }

                                    FontMetrics{
                                        id: fontMx

                                        font.weight: lblMessage.font.weight
                                        font.family: lblMessage.font.family
                                        font.pixelSize: lblMessage.font.pixelSize

                                    }

                                    color: parent.source === 'user' ? "black" : "white"
                                    text: parent.message
                                    wrapMode: "WordWrap"
                                    horizontalAlignment: parent.source === 'user' ? Text.AlignRight : Text.AlignLeft

                                    font{
                                        pixelSize: 18
                                    }
                                }
                            }
                        }

                        DelegateChoice{
                            roleValue: 'structured_message'

                            CompExpandableBtnBreadcrumb{
                                showQuickActions: false

                                titleText: model.title
                                titleIconSource: ''
                                contents: model.data
                                isExpanded: true
                                anchors.left: parent.left
                                //anchors.leftMargin: 20

                                width: listChatEntries.chatEntryWidth

                            }

                        }

                        DelegateChoice{
                            roleValue: 'html_message'

                            CompMessageHtml{
                                htmlTextRaw: model.message

                                width: listChatEntries.chatEntryWidth

                                anchors.left: parent.left


                            }
                        }

                    }

                    delegate: delChooser

                }

            }




            Item{
                id: groupChatControls

                height: childrenRect.height

                anchors{
                    left: groupTopRow.left
                    right: groupTopRow.right
                    bottom: parent.bottom
                    bottomMargin: 22
                }



                Item{
                    id: grouptQuickResponses
                    height: childrenRect.height
                    anchors{
                        bottom: groupTextEntryControls.top
                        left: groupTextEntryControls.left
                        right: groupTextEntryControls.right
                    }

                    ListView{
                        anchors{
                            bottom: parent.bottom
                            left: parent.left
                            right: parent.right
                        }

                        height: (compConvAiChatRoot.listQuickResponses.length > 0) ? 32 : 0

                        orientation: ListView.Horizontal
                        boundsBehavior: Flickable.StopAtBounds

                        model: compConvAiChatRoot.listQuickResponses
                        delegate: CompBtnBreadcrumb{
                            text: modelData
                            height: responsesHeight
                        }
                    }
                }

                Item{
                    id: groupTextEntryControls

                    height: childrenRect.height

                    anchors{
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                    }

                    CompCustomisableTextField{

                        id: edtMessage
                        anchors{
                            left: parent.left
                            bottom: parent.bottom
                            right: parent.right
                        }

                        onEnterPressed: {
                            compConvAiChatRoot.onUserMessageEntered(edtMessage.text)
                            edtMessage.text = ''
                        }

                    }


                }
            }


        }


        DlgYesNo{
            id: dlgYesNo


        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";formeditorZoom:0.66;height:1000;width:640}
}
##^##*/
