import QtQuick 2.15

Popup__BASE {
    id: popup_NetworkDeviceInfo_Root

    required property string deviceName
    property CompBtnBreadcrumb selectedSectionButton: btnNull
    property string selectedSection: selectedSectionButton.text

    onSelectedSectionChanged: {
        if(selectedSection === "")
            return

        WifiController.deviceInfoTargetSection = selectedSection
        console.log("set target section to " + selectedSection)
    }

    Component.onCompleted: {
        WifiController.fetchDeviceInfo(deviceName)
        popup_NetworkDeviceInfo_Root.open()
        listTabButtons.children[0].click()
    }

    CompRoundButton{
        id: btnNull
        text: ""
        visible:  false
    }

    CompPopupBG{
        id: bg

        width: 800
        height: areaTopControls.height
                + areaTopControls.anchors.topMargin
                + listTabButtons.height
                + listTabButtons.anchors.topMargin
                + listContents.anchors.topMargin
                + listContents.height
                + listContents.anchors.bottomMargin

        anchors.centerIn: parent
        anchors.fill: undefined
    }

    Item{
        id: areaTopControls

        anchors{
            top: bg.top
            left: bg.left
            right: bg.right
        }

        height: 64

        CompLabel{
            id: lblDevice

            anchors{
                top: parent.top
                left: parent.left
                bottom: parent.bottom
            }

            text: "Device:  " + popup_NetworkDeviceInfo_Root.deviceName


        }

        BtnClose{
            id: btnClose

            anchors{
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }

            onClicked: {
                popup_NetworkDeviceInfo_Root.close()
            }
        }
    }

    ListView {
        id: listTabButtons

        anchors{
            top: areaTopControls.bottom
            left: areaTopControls.left
            right: areaTopControls.right

            margins: 20
        }

        height: 64
        orientation: ListView.Horizontal

        clip: true
        boundsBehavior: Flickable.StopAtBounds

        model: WifiController.listDeviceInfoSections
        spacing: 30
        delegate: CompBtnBreadcrumb{
            height: listTabButtons.height

            text: modelData
            onClicked: {
                popup_NetworkDeviceInfo_Root.selectedSectionButton = this
            }
        }
    }

    TextEdit {}

    ListView {
        id: listContents

        anchors {
            top: listTabButtons.bottom
            left: listTabButtons.left
            right: listTabButtons.right

            topMargin: 40
            bottomMargin: 20
        }

        height: 600

        clip: true
        boundsBehavior: Flickable.StopAtBounds

        model: WifiController.listDeviceInfoSectionKeys
        spacing: 30

        delegate: CompLabel{
            property string labelText: modelData + ": " + WifiController.getDeviceInfoSectionKeyValue(
                                           popup_NetworkDeviceInfo_Root.selectedSection,
                                           modelData
                                           )

            text: labelText
        }
    }


}
