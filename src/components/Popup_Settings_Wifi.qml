import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml.Models 2.15

Popup_Settings_View__BASE {
    id: popup_Settings_Wifi_Root

    viewName: "WiFi Settings"

    //controlWidth: isDelta ? searchField.width : parent.width * 0.8
    property int controlWidth: 400
    property string currentTab: currentTab_Auto
    property int itemSpacingVertical: 20
    property CompBtnBreadcrumb selectedSubTab: btnAuto
    property bool isFirstHighlight: true
    readonly property string currentTab_Auto: "Auto"
    readonly property string currentTab_Manual: "Manual"

    onSelectedSubTabChanged: {
        currentTab = selectedSubTab.text

        rectSubTabSelected.updatePos()
    }

    Component.onCompleted: {
        tmr_DelayDefaultSelection.start()
    }

    Timer{
        id: tmr_DelayDefaultSelection

        interval: 100

        onTriggered: {
            rectSubTabSelected.updatePos()

            isFirstHighlight = false
        }
    }

    CompBtnBreadcrumb {
        id: btnNull
        visible: false
        text: "null"
    }

    Rectangle {
        id: rectSubTabSelected

        property real overPadding: 14

        width: popup_Settings_Wifi_Root.selectedSubTab.width + overPadding
        height: isDelta ? (btnAuto.height + overPadding) : (btnAutoOmega.height + overPadding)

        color: "#809287ED"

        radius: 24

        function updatePos(){
            var newY = popup_Settings_Wifi_Root.selectedSubTab.mapToItem(popup_Settings_Wifi_Root, Qt.point(0,0)).y
            newY -= overPadding * 0.5
            y = newY

            var newX = popup_Settings_Wifi_Root.selectedSubTab.mapToItem(popup_Settings_Wifi_Root, Qt.point(0,0)).x
            newX -= overPadding * 0.5
            x = newX


        }

        Behavior on y {
            enabled: !isFirstHighlight

            NumberAnimation{
                duration: 10
            }
        }


        Behavior on x {

            enabled: !isFirstHighlight

            NumberAnimation{
                duration: 250
            }
        }

        Behavior on width{
            enabled: !isFirstHighlight

            NumberAnimation{
                duration: 125
            }
        }
    }

    Item {
        id: areaContent_Root

        anchors {
            fill: contents
            margins: contentsBgRadius
        }

        Column {
            id: column
            anchors{
                left: parent.left
                right: parent.right
                top: parent.top

            }
            spacing: popup_Settings_Wifi_Root.itemSpacingVertical

            CompToggle {
                id: compToggle

                text: "WiFi Enabled:"
                height: 60
                width: parent.width

                isOn: WifiController.isWirelessEnabled

                onIsOnChanged: {

                    WifiController.isWirelessEnabled = isOn

                    if( !isOn )
                    {
                        WifiController.stopUpdateWifiNetworkConfigLists()
                    } else if ( popup_Settings_Wifi_Root.selectedSubTab === btnAuto )
                    {
                        WifiController.updateWifiNetworkConfigLists()
                    }
                }
            }

            Row {
                id: row

                enabled: compToggle.isOn

                width: parent.width
                height: isDelta ? 60 : 120

                spacing: 24


                CompBtnBreadcrumb {
                    id: btnAuto

                    text: "Auto"
                    opacity: (popup_Settings_Wifi_Root.selectedSubTab === this ? 1.0 : 0.6)
                    onClicked: popup_Settings_Wifi_Root.selectedSubTab = this

                    Component.onCompleted: {
                        popup_Settings_Wifi_Root.selectedSubTab = this;
                    }
                }

                CompBtnBreadcrumb {
                    id: btnManual

                    text: "Manual"

                    opacity: (popup_Settings_Wifi_Root.selectedSubTab === this ? 1.0 : 0.6)
                    onClicked: popup_Settings_Wifi_Root.selectedSubTab = this
                }

            }

            Rectangle {
                id: rectSep

                width: parent.width
                height: 6
                radius: 0.5 * height

                color: "#80000000"
            }
        }

        Item {
            id: areaContent

            anchors {
                top: column.bottom
                left: column.left
                right: column.right
                bottom: parent.bottom

                topMargin: 20
            }
        }

        Loader {
            id: loaderWifiAuto
            enabled: compToggle.isOn
            active: popup_Settings_Wifi_Root.currentTab === currentTab_Auto
            asynchronous: true
            anchors.fill: areaContent

            sourceComponent: Screen_Networking_Content_Control_Wifi_Auto{}
        }

        Loader{
            id: loaderWifiManual
            enabled: compToggle.isOn
            active: popup_Settings_Wifi_Root.currentTab === currentTab_Manual
            asynchronous: true
            anchors.fill: areaContent
            sourceComponent: Item {

                Column {

                    width: parent.width

                    spacing: popup_Settings_Wifi_Root.itemSpacingVertical

                    anchors{
                        horizontalCenter: parent.horizontalCenter

                    }



                    CompTextField {
                        id: edtSSID
                        lblText: "Network SSID:"
                        height: isDelta ? 80 : 120
                        width: parent.width
                        placeholderText: "Enter Network SSID..."
                        lblFontPixelSize: isDelta ? 28 : 40
                        edtFontPixelSize: isDelta ? 20 : 40

                        textEditWidth: 0.3 * width
                    }

                    CompTextField {
                        id: edtPassword
                        lblText: "Network Password:"
                        height: isDelta ? 80 : 120
                        width: parent.width
                        edtEchoMode: TextInput.Password
                        placeholderText: "Enter Network Password..."
                        lblFontPixelSize: isDelta ? 28 : 40
                        edtFontPixelSize: isDelta ? 20 : 40

                        textEditWidth: 0.3 * width
                        //text: "Password"
                    }

                    CompLabelledComboBox {
                        id: compLabelledComboBox
                        height: isDelta ? 80 : 120
                        width: parent.width
                        textFontPixelSize: isDelta ? 28 : 40
                        valueComboBox: isDelta ? 24 : 40

                        comboWidth: 0.3 * width

                        text: "Security Protocol:"
                    }

                    CompRoundButton{
                        id: btnConnect

                        height: isDelta ? 80 : 120
                        width: parent.width
                        font.pixelSize: isDelta ? 10 : 40
                        text: "Connect"

                    }
                }

            }


        }



    }


}
