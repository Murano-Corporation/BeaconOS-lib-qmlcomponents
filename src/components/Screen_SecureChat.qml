import QtQuick 2.12
import QtQuick.Controls 2.15
//import Qt.labs.json 1.0

Screen__BASE {
    id: screenMessagesRoot
    screenName: "Messages"
    property string sender: "user1"
    property var list_of_users: ["user1", "user2", "user3", "user4"]
    property string reciever: "user2"
    property var chat_history: ListModel {}

    function onUserSelected() {

        chat_history.clear()

    }


    SecureChatApp {
        id: secureChatApp
    }

    Connections {

        target: secureChatApp

        function onSignal_OnMsgRecieved(message) {
            console.log("Message recieved from a user")
            chat_history.append({name: sender, chat: message})
        }
    }

    Row {
        anchors.fill: parent
        width: parent.width
        height: parent.height

        Rectangle {
            width: parent.width * 0.5
            height: parent.height

            ScrollView {
                width: parent.width
                height: parent.height

                ListView {
                    width: parent.width
                    height: parent.width

                    model: list_of_users//list_of_recievers

                    delegate: Item {
                        width: parent.width
                        height: 50

                        Button {
                            text: modelData//model.ID
                            width: parent.width
                            height: parent.height

                            onClicked: {
                                // reciever: model.ID
                                // console.log("Opening chat with User " model.ID)
                                screenMessagesRoot.onUserSelected()
                                // updateTimer.running = true
                                chatpopup.open()
                            }
                        }
                    }
                }
            }

            Popup {
                id: chatpopup
                width: parent.width
                height: parent.height
                modal: false
                closePolicy: Popup.CloseOnEscape

                Column {

                    anchors.fill: parent

                    ScrollView {

                        width: parent.width
                        height: parent.height * 0.7
                        anchors.topMargin: parent.height * 0.05
                        anchors.bottomMargin: parent.height * 0.05


                        Column {
                            id: chatHistory
                            width: parent.width

                            Repeater {
                                model: chat_history
                                Text {
                                    text: model.name + ": " + model.chat
                                    font.pixelSize: 30
                                    color: "black"
                                    wrapMode: Text.Wrap
                                    padding: 5
                                }
                            }
                        }
                    }

                    Row {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        width: parent.width
                        height: parent.height * 0.1

                        TextField {
                            id: messageInput
                            width: parent.width * 0.8
                            height: parent.height
                            placeholderText: "Type a message"
                            font.pixelSize: 25
                            // TODO
                            onAccepted: {
                                if (messageInput.text != "") {
                                    chat_history.append({name: reciever, chat: messageInput.text})
                                    SecureChatApp.PublishMessage(messsageInput.text) //Placeholder
                                    messageInput.text = ""
                                }
                            }
                        }

                        Button {
                            text: "Send"
                            anchors.bottom: parent.bottom
                            width: parent.width * 0.2
                            //TODO
                            onClicked: {
                                var date = new Date()
                                if (messageInput.text != "") {
                                    chat_history.append({name: reciever, chat: messageInput.text})
                                    SecureChatApp.PublishMessage()
                                    messageInput.text = ""
                                }
                            }
                        }
                    }
                }
            }
        }

        // Section here for data
        Rectangle {
            width: parent.width * 0.5
            height: parent.height

            Text {
                anchors.centerIn: parent
                text: "test"
                font.pointSize: 24
            }
        }

    }

}

//Set the contextproperty
