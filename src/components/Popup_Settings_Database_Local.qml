import QtQuick 2.0

Item {
    id: popup_settings_database_local_root

    property string hostname
    property string password
    property string username
    property string schema
    property int port
    property bool changesMade: false

    Component.onCompleted: {
        hostname = Settings.getDatabaseHostName("")
        password = Settings.getDatabasePassword("")
        schema = Settings.getDatabaseName("")
        port = Settings.getDatabasePort(0)
        username = Settings.getDatabaseUsername("")

        textDatabaseLocalHostname.textEdit.text = hostname
        textDatabaseLocalPassword.textEdit.text = password
        textDatabaseLocalSchema.textEdit.text = schema
        textDatabaseLocalPort.textEdit.text = port
        textDatabaseLocalUsername.textEdit.text = username


    }


    function revertChanges(){
        loaderPopupConfirm.accepted.connect(revertChanges_Confirmed)
        loaderPopupConfirm.showConfirmPopup(
                    "Revert Changes?"
                    ,"Are you sure you want revert the changes that you've made?"
                    , "Revert", "Don't Revert")

    }

    function revertChanges_Confirmed(){
        //console.info("Accepted Revert")
        loaderPopupConfirm.accepted.disconnect(revertChanges_Confirmed)

        textDatabaseLocalHostname.textEdit.text = hostname
        textDatabaseLocalPassword.textEdit.text = password
        textDatabaseLocalSchema.textEdit.text = schema
        textDatabaseLocalPort.textEdit.text = port
        textDatabaseLocalUsername.textEdit.text = username

        tmrDelay.triggered.connect(showPopup_RevertSuccess)
        tmrDelay.start()

    }

    function showPopup_RevertSuccess(){
        tmrDelay.triggered.disconnect(showPopup_RevertSuccess)
        loaderPopupConfirm.showInfoPopup("Changes Reverted Successfully","", "OK")

        changesMade = false
    }

    function saveChanges(){

        loaderPopupConfirm.accepted.connect(saveChanges_Confirmed)
        loaderPopupConfirm.showConfirmPopup(
                    "Save Changes?"
                    ,"Are you sure you want overwrite the stored changes with what you have entered?"
                    , "Save", "Don't Save")


    }

    function saveChanges_Confirmed(){
        //console.info("Accepted Save")
        loaderPopupConfirm.accepted.disconnect(saveChanges_Confirmed)


        hostname = textDatabaseLocalHostname.textEdit.text
        password = textDatabaseLocalPassword.textEdit.text
        schema = textDatabaseLocalSchema.textEdit.text

        var p = textDatabaseLocalPort.textEdit.text
        port = parseInt(p)
        username = textDatabaseLocalUsername.textEdit.text

        Settings.databaseLocalHostname = hostname
        Settings.databaseLocalName = schema
        Settings.databaseLocalPassword = password
        Settings.databaseLocalPort = port
        Settings.databaseLocalUsername = username


        tmrDelay.triggered.connect(showPopup_ChangesSaved)
        tmrDelay.start()

    }

    function showPopup_ChangesSaved(){
        tmrDelay.triggered.disconnect(showPopup_ChangesSaved);
        loaderPopupConfirm.showInfoPopup("Changes Saved Successfully","", "OK")
        changesMade = false
    }

    function checkChangesMade(){

        var ret = false

        ret |= (textDatabaseLocalHostname.textEdit.text !== hostname)
        ret |= (textDatabaseLocalPassword.textEdit.text !== password)
        ret |= (textDatabaseLocalSchema.textEdit.text !== schema)
        ret |= (parseInt(textDatabaseLocalPort.textEdit.text) !== port)
        ret |= (textDatabaseLocalUsername.textEdit.text !== username)

        changesMade = ret

    }

    Timer{
        id: tmrDelay

        interval: 500
        running: false
    }

    Column{
        id: colContents

        spacing: 20

        anchors{
            fill: parent
        }

        CompLabel{
            id: lblTitle

            text: "Database (Local)"

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom

            height: 40
            width: parent.width
        }

        CompPopupBG{
            id: bg
            width: parent.width
            height: parent.height - parent.spacing - lblTitle.height

            anchors.fill: undefined

            Column{
                id: areaContent

                spacing: 20

                anchors{
                    fill: parent
                    margins: bg.radiusBG
                }

                CompLabelledTextEdit {
                    id: textDatabaseLocalHostname

                    width: parent.width
                    isReadonly: false

                    label{
                        text: "Hostname:"
                    }

                    textEdit{
                        text: "?"

                        onAccepted: popup_settings_database_local_root.checkChangesMade()
                    }
                }

                CompLabelledTextEdit {
                    id: textDatabaseLocalPassword

                    width: parent.width
                    isReadonly: false
                    label{
                        text: "Password:"
                    }

                    textEdit{
                        text: "?"
                        echoMode: TextInput.Password
                        inputMethodHints: Qt.ImhSensitiveData | Qt.ImhHiddenText
                        onAccepted: popup_settings_database_local_root.checkChangesMade()
                    }
                }

                CompLabelledTextEdit {
                    id: textDatabaseLocalPort
                    isReadonly: false
                    width: parent.width

                    label{
                        text: "Port:"
                    }

                    textEdit{
                        text: "?"
                        inputMethodHints: Qt.ImhDigitsOnly
                        onAccepted: popup_settings_database_local_root.checkChangesMade()
                    }
                }

                CompLabelledTextEdit {
                    id: textDatabaseLocalSchema
                    isReadonly: false
                    width: parent.width

                    label{
                        text: "Schema:"
                    }

                    textEdit{
                        text: "?"
                        onAccepted: popup_settings_database_local_root.checkChangesMade()
                    }
                }

                CompLabelledTextEdit {
                    id: textDatabaseLocalUsername
                    isReadonly: false
                    width: parent.width

                    label{
                        text: "Username:"
                    }

                    textEdit{
                        text: "?"
                        onAccepted: popup_settings_database_local_root.checkChangesMade()
                    }
                }


                Row{
                    id: rowControls

                    width: parent.width

                    height: 60

                    spacing: 20

                    CompBtnBreadcrumb{
                        id: btnRevert
                        enabled: popup_settings_database_local_root.changesMade

                        text: "Revert"

                        onClicked: popup_settings_database_local_root.revertChanges()
                    }

                    CompBtnBreadcrumb{
                        id: btnSave
                        enabled: popup_settings_database_local_root.changesMade

                        text: "Save"

                        onClicked: popup_settings_database_local_root.saveChanges()
                    }

                }

            }



        }

    }

    Loader{
        id: loaderPopupConfirm

        property string title: "SetMe"
        property string message: "SetMe"
        property string acceptText: "Yes"
        property string declineText: "No"

        signal accepted()
        signal declined()

        function showConfirmPopup(sTitle, sMessage, sYes, sNo)
        {
            title = sTitle
            message = sMessage
            acceptText = sYes
            declineText = sNo

            active = true
        }

        function showInfoPopup(sTitle, sMessage, sYes)
        {
            showConfirmPopup(sTitle, sMessage, sYes, "")
        }

        active: false
        anchors.fill: parent
        asynchronous: true

        sourceComponent: Popup_Confirm {
            id: popup_confirm

            titleControl{
                text: loaderPopupConfirm.title
            }

            messageControl{
                text: loaderPopupConfirm.message
            }

            acceptControl{
                text: loaderPopupConfirm.acceptText
            }

            declineControl{
                text: loaderPopupConfirm.declineText
            }

            onClosed: {
                loaderPopupConfirm.active = false
            }

            onAccepted: {
                //console.info("Accepted outer")
                loaderPopupConfirm.accepted()
                close()
            }

            onDeclined: {
                //console.info("Declined outer")
                loaderPopupConfirm.declined()
                close()
            }

        }
    }

}
