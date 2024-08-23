import QtQuick 2.0

Comp__BASE {
    id: screenBaseRoot

    required property string screenName
    property bool bCanLeaveScreen: true
    property bool bAttemptingToLeaveScreen: false;
    property bool bOverRideOverLaySettings: true
    property bool bIsPopup: false

    Connections{
        target: SingletonScreenManager

        function onSignal_AttemptingToLeaveScreen(){

            console.log("Attemtping to leave the screen '" + screenName + "'")
            if(bCanLeaveScreen === true)
            {
                screenBaseRoot.sendLeaveResponse_OK();
            } else {
                screenBaseRoot.bAttemptingToLeaveScreen = true
            }
        }
    }

    function sendLeaveResponse_OK(){
        console.log("Attemtping to leave the screen '" + screenName + "' OK")
        SingletonScreenManager.screenLeaveResponse_OK();
    }

    function sendLeaveResponse_NotOK(){
        console.log("Attemtping to leave the screen '" + screenName + "' NOT OK")
        SingletonScreenManager.screenLeaveResponse_NotOK();
    }

    Component.onCompleted:{
        //console.log("Parent level on completed")
        if(bOverRideOverLaySettings)
            setOverlayDefaults();
    }

    function setOverlayDefaults(){
        console.log("Setting root level values...")
        var openSize = Qt.size(400,300)
        var openOrigin = Qt.point(((root.contentItem.width * 0.5) - openSize.width), ((root.contentItem.height * 0.5) - openSize.height))

        SingletonOverlayManager.setPerScreenPopupOpenRect("Chat AI", openOrigin, openSize);
        SingletonOverlayManager.setPerScreenPopupOpenRect("NSN Viewer", openOrigin, openSize);

        openSize = Qt.size(1920,1080)
        openOrigin = Qt.point(0, 0)
        SingletonOverlayManager.setPerScreenPopupOpenRect("WiFi Viewer", openOrigin, openSize);
    }
}
