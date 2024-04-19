import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQml.Models 2.15

Popup__BASE{
    id: popup_application_info_root

    contentWidth: 1200
    property var applicationInfoStruct
    property var applicationInfoStruct_Original
    property bool changesMade: false
    property string originalAppName: applicationInfoStruct_Original.name
    property string titleText: "Application Info - " + originalAppName
    popupName: "Application Info"

    onApplicationInfoStruct_OriginalChanged: {
        if(applicationInfoStruct_Original === undefined)
            return;

        edtAppEnabled.isOn =  popup_application_info_root.applicationInfoStruct_Original.enabled
    }


    function checkChangesMade(){


        //console.log("Checking changes made...")
        //console.log("...Original " + applicationInfoStruct_Original)
        //console.log("...Changes " + applicationInfoStruct)
        var ret = false

        ret |= (popup_application_info_root.applicationInfoStruct.name !== popup_application_info_root.applicationInfoStruct_Original.name)
        ret |= (popup_application_info_root.applicationInfoStruct.description !== popup_application_info_root.applicationInfoStruct_Original.description)
        ret |= (popup_application_info_root.applicationInfoStruct.navPath !== popup_application_info_root.applicationInfoStruct_Original.navPath)
        ret |= (popup_application_info_root.applicationInfoStruct.iconPath !== popup_application_info_root.applicationInfoStruct_Original.iconPath)
        ret |= (popup_application_info_root.applicationInfoStruct.enabled !== popup_application_info_root.applicationInfoStruct_Original.enabled)

        //console.log("..." + ret)
        popup_application_info_root.changesMade = ret
    }

    function saveChanges(){
        loaderPopupConfirm.accepted.connect(saveChanges_Confirmed)
        loaderPopupConfirm.showConfirmPopup(
                    "Save Changes?"
                    ,"Are you sure you want overwrite the stored changes with what you have entered?"
                    , "Save", "Don't Save")
    }

    function saveChanges_Confirmed(){
        loaderPopupConfirm.accepted.disconnect(saveChanges_Confirmed)


        Applications.setApplicationInfo(applicationInfoStruct_Original.name, applicationInfoStruct)
        popup_application_info_root.applicationInfoStruct_Original = Applications.copyFromOther(popup_application_info_root.applicationInfoStruct)


        tmrDelay.triggered.connect(showPopup_ChangesSaved)
        tmrDelay.start()
    }

    function showPopup_ChangesSaved(){
        tmrDelay.triggered.disconnect(showPopup_ChangesSaved);
        loaderPopupConfirm.showInfoPopup("Changes Saved Successfully","", "OK")
        popup_application_info_root.changesMade = false
    }

    function revertChanges(){
        loaderPopupConfirm.accepted.connect(revertChanges_Confirmed)
        loaderPopupConfirm.showConfirmPopup(
                    "Revert Changes?"
                    ,"Are you sure you want revert the changes that you've made?"
                    , "Revert", "Don't Revert")
    }

    function revertChanges_Confirmed(){
        loaderPopupConfirm.accepted.disconnect(revertChanges_Confirmed)

        popup_application_info_root.applicationInfoStruct = Applications.copyFromOther(popup_application_info_root.applicationInfoStruct_Original)

        tmrDelay.triggered.connect(showPopup_RevertSuccess)
        tmrDelay.start()
    }

    function showPopup_RevertSuccess(){
        tmrDelay.triggered.disconnect(showPopup_RevertSuccess)
        loaderPopupConfirm.showInfoPopup("Changes Reverted Successfully","", "OK")

        popup_application_info_root.changesMade = false
    }

    Timer{
        id: tmrDelay

        interval: 500
        running: false
    }


    CompPopupBG{
        id: bg

        anchors{
            fill: undefined
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }

        width: popup_application_info_root.contentWidth
        height: colContents.height + colContents.anchors.topMargin + colContents.anchors.bottomMargin
    }

    Column{
        id: colContents

        anchors{
            top: bg.top
            left: bg.left
            right: bg.right

            margins: 20
        }

        spacing: 20

        CompLabel{
            id: lblTitle

            width: parent.width
            height: 40

            text: popup_application_info_root.titleText
        }

        CompLabelledTextEdit{
            id: edtAppName

            isReadonly: false

            width: parent.width

            label{
                text: "App. Name:"
            }

            textEdit{
                text: popup_application_info_root.applicationInfoStruct.name

                onTextChanged: {
                    //console.log("TExt changed to " + edtAppName.textEdit.text)
                    popup_application_info_root.applicationInfoStruct.name = edtAppName.textEdit.text
                    popup_application_info_root.checkChangesMade()
                }
            }

        }

        CompLabelledTextEdit{
            id: edtAppDescription

            isReadonly: false

            width: parent.width

            label{
                text: "App. Description:"
            }

            textEdit{
                text: popup_application_info_root.applicationInfoStruct.description

                onTextChanged: {
                    popup_application_info_root.applicationInfoStruct.description = edtAppDescription.textEdit.text
                    popup_application_info_root.checkChangesMade()
                }
            }

        }

        CompLabelledTextEdit{
            id: edtAppIconPath

            isReadonly: false

            width: parent.width

            label{
                text: "App. Icon Path:"
            }

            textEdit{
                text: popup_application_info_root.applicationInfoStruct.iconPath
                wrapMode: Text.WordWrap

                onTextChanged: {
                    popup_application_info_root.applicationInfoStruct.iconPath = edtAppIconPath.textEdit.text
                    popup_application_info_root.checkChangesMade()
                }
            }

        }

        CompLabelledTextEdit{
            id: edtAppNavPath

            isReadonly: false

            width: parent.width

            label{
                text: "App. Nav. Path:"
            }

            textEdit{
                text: popup_application_info_root.applicationInfoStruct.navPath

                onTextChanged: {
                    popup_application_info_root.applicationInfoStruct.navPath = edtAppNavPath.textEdit.text
                    popup_application_info_root.checkChangesMade()
                }
            }

        }

        CompToggle{
            id: edtAppEnabled

            isReadOnly: false

            width: parent.width

            text:"App. Enabled?:"

            onIsOnChanged:{
                popup_application_info_root.applicationInfoStruct.enabled = edtAppEnabled.isOn
                popup_application_info_root.checkChangesMade()
            }

        }

        Row{
            id: rowControls

            height: 60
            width: parent.width

            spacing: 30

            layoutDirection: Qt.RightToLeft

            CompBtnBreadcrumb{
                id: btnBack

                enabled: true

                text: "Back"

                height: parent.height
                width: btnRevert.width

                onClicked: popup_application_info_root.close()
            }

            CompBtnBreadcrumb{
                id: btnRevert

                enabled: popup_application_info_root.changesMade

                text: "Revert"

                height: parent.height
                width: 0.333 * (parent.width - (parent.spacing * 2))

                onClicked: popup_application_info_root.revertChanges()
            }

            CompBtnBreadcrumb{
                id: btnSave

                enabled: popup_application_info_root.changesMade

                text: "Save"

                height: parent.height
                width: btnRevert.width

                onClicked: popup_application_info_root.saveChanges()
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
