import QtQuick 2.12
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
//import Qt.labs.json 1.0

Screen__BASE {
    id: screenMessagesRoot
    screenName: "Messages"
    property string sender: "user1"
    property string reciever: "user2"
    property string sensor_data_display: "imu"
    property var list_of_users: ["user1", "user2", "user3", "user4"]
    property var list_of_sensor_topics: ["imu", "env"]
    property var chat_history: ListModel {}
    property var sensor_data: ListModel {}

    // TODO:
    // We need userID along with message
    // After implementing userID we can filter out the list and chat_history
    // When start getting user chat_history will store according to user (diff. history, diff users)

    Connections {

        target: SecureChatApp

        // Slot for chat recieved
        function onSignal_OnMsgRecieved(message, topic) {
            console.log("Message recieved from a user")
            console.log(message)
            if (topic === "COMM") {
                chat_history.append({name: sender, chat: message,
                                        time: Qt.formatTime(new Date(), "hh:mm:ss AP")})
            }
            else if (topic === "imu" || topic === "env") {
                console.log(message)
                sensor_data.append({data:message, time: Qt.formatTime(new Date(), "hh:mm:ss AP")})
            }
        }
    }

    // Split the window into three sections
    RowLayout {
        anchors.fill: parent
        spacing: 0.5
        width: parent.width
        height: parent.height

        // Chat section
        Rectangle {

            id: chatSection
            width: parent.width * 0.33
            height: parent.height

            // StackView to navigate between windows
            StackView {
                id: stackViewChat
                anchors.fill: parent

                initialItem: screenUsers
            }
        }

        // Sensor section
        Rectangle {

            id: sensorSection

            width: parent.width * 0.33
            height: parent.height

            StackView {
                id: stackViewSensor
                anchors.fill: parent

                initialItem: screenListOfSensors
            }
        }

        // Video Section
        Rectangle {

            id: videoSection
            width: parent.width * 0.33
            height: parent.height
        }
    }

    Component {
        id: screenListOfSensors

        // List of sensors
        ListView {
            width: parent.width
            height: parent.height

            model: list_of_sensor_topics

            delegate: Item {

                width: parent.width
                height: 50

                Button {
                    text: modelData
                    width: parent.width
                    height: parent.height

                    onClicked: {
                        stackViewSensor.push(screenSensors)
                        screenMessagesRoot.sensor_data_display = modelData
                        SecureChatApp.signal_toSubscribeTopic(modelData)
                    }

                }
            }
        }

    }

    Component {

        id: screenSensors

        // Sensor Data display screen
        ColumnLayout {

            id: headerSensorInfo
            spacing: 1

            // Header of the Sensor Info
            Rectangle {
                width: parent.width
                height:  50

                Button {
                    width: parent.width * 0.2
                    height: parent.height
                    anchors.left: parent.left
                    text: "Back"

                    onClicked: {
                        stackViewSensor.pop()
                        SecureChatApp.signal_toUnubscribeTopic(screenMessagesRoot.sensor_data_display)
                        sensor_data.clear()
                    }
                }

                Rectangle {
                    width: parent.width * 0.8
                    height: parent.height
                    anchors.right: parent.right

                    Text {
                        text: screenMessagesRoot.sensor_data_display
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: 20
                        color: "black"
                    }
                }
            }

            // Sensor Stream
            ListView {

                id: sensorDataView
                width: parent.width
                height: parent.height * 0.8
                spacing: 2

                model: sensor_data

                delegate: Item {

                    width: parent.width
                    height: childrenRect.height

                    Column {
                        width: parent.width
                        Text {
                            text: model.time
                            Layout.alignment: Qt.AlignLeft
                            font.pixelSize: 10
                        }
                        TextArea {
                            text: model.data
                            wrapMode: TextArea.Wrap
                            verticalAlignment: TextArea.AlignTop
                            font.pixelSize: 20
                            padding: 2
                        }
                    }
                }
            }
        }
    }

    Component {
        id: screenUsers

        // List of users we want to chat with
        ListView {
            width: parent.width
            height: parent.height

            model: list_of_users

            delegate: Item {

                width: parent.width
                height: 50

                Button {
                    text: modelData // model.ID
                    width: parent.width
                    height: parent.height

                    onClicked: {
                        screenMessagesRoot.reciever = modelData // model.ID
                        stackViewChat.push(screenChat)
                    }
                }
            }
        }

    }

    Component {
        id: screenChat

        // Chat screen of a particular user
        ColumnLayout {

            id: headerUserInfo
            spacing: 1

            // Header of the chat screen
            Rectangle {
                width: parent.width
                height: 50

                Button {
                    width: parent.width * 0.2
                    height: parent.height
                    anchors.left: parent.left
                    text: "Back"

                    onClicked: {
                        stackViewChat.pop()
                    }
                }
                Rectangle {
                    width: parent.width * 0.8
                    height: parent.height
                    anchors.right: parent.right

                    Text {
                        text: reciever
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: 20
                        color: "black"
                    }
                }
            }

            // Chats
            ListView {

                id: chatsView
                width: parent.width
                height: parent.height * 0.8
                spacing: 5

                model: chat_history

                delegate: Item {

                    width: parent.width
                    height: childrenRect.height

                    // User name, time and chat
                    Rectangle {

                        width: parent.width
                        height: childrenRect.height

                        Column {

                            width: parent.width
                            spacing: 0.5

                            RowLayout {
                                width: parent.width
                                Text {
                                    text: model.name + ":"
                                    Layout.alignment: Qt.AlignLeft
                                    Layout.fillWidth: true
                                    font.pixelSize: 25
                                }

                                Text {
                                    text: model.time
                                    Layout.alignment: Qt.AlignRight
                                }

                            }

                            TextArea {
                                text: model.chat
                                wrapMode: TextArea.Wrap
                                verticalAlignment: TextArea.AlignTop
                                font.pixelSize: 20
                                padding: 2
                            }
                        }
                    }
                }
            }

            // Chatbox
            Rectangle {
                width: parent.width
                height: parent.height * 0.1

                ScrollView {
                    id: chatBoxScroll
                    width: parent.width * 0.8
                    height: parent.height
                    anchors.left: parent.left

                    TextArea {
                        id: messageInput
                        width: parent.width
                        height: parent.height

                        placeholderText: "Type a message"
                        font.pixelSize: 20
                        wrapMode: TextField.Wrap
                    }
                }

                Button {
                    text: "Send"
                    width: parent.width * 0.2
                    height: parent.height
                    anchors.right: parent.right

                    onClicked: {
                        if (messageInput.text != "") {
                            chat_history.append({name: reciever, chat: messageInput.text,
                                                    time: Qt.formatTime(new Date(), "hh:mm:ss AP")})
                            var text = messageInput.text
                            SecureChatApp.PublishMessage(text)
                            messageInput.text = ""
                        }
                    }
                }
            }
        }
    }

}

