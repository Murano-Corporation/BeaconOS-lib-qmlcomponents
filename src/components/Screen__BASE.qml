import QtQuick 2.0

Item {
    id: screenBaseRoot

    property bool bCanLeaveScreen: true
    property bool bAttemptingToLeaveScreen: false;
    property bool bOverRideOverLaySettings: true


    Connections{
        target: SingletonScreenManager

        function onSignal_AttemptingToLeaveScreen(){

            if(bCanLeaveScreen === true)
            {
                screenBaseRoot.sendLeaveResponse_OK();
            } else {
                screenBaseRoot.bAttemptingToLeaveScreen = true
            }
        }
    }

    function sendLeaveResponse_OK(){
        SingletonScreenManager.screenLeaveResponse_OK();
    }

    function sendLeaveResponse_NotOK(){
        SingletonScreenManager.screenLeaveResponse_NotOK();
    }

    Component.onCompleted:{
        console.log("Parent level on completed")
        if(bOverRideOverLaySettings)
            setOverlayDefaults();
    }

    function setOverlayDefaults(){
        console.log("Setting parent level values...")
        var openSize = Qt.size(400,300)
        var openOrigin = Qt.point(((root.contentItem.width * 0.5) - openSize.width), ((root.contentItem.height * 0.5) - openSize.height))

        SingletonOverlayManager.setPerScreenPopupOpenRect("Chat AI", openOrigin, openSize);
        SingletonOverlayManager.setPerScreenPopupOpenRect("NSN Viewer", openOrigin, openSize);
    }
}
