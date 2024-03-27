import QtQuick 2.12
import QtQuick.Controls 2.15

Item {
    id: screenNetworkingContentControlWifi

    property CompBtnBreadcrumb selectedSubTab

    property real itemSpacingVertical: 24
    property bool isOk: true

    property point globalSelectedSubTab
    property point localSelectedSubTab

    onSelectedSubTabChanged: {
        if(!selectedSubTab)
            return

        screenNetworkingContentControlWifi.globalSelectedSubTab = selectedSubTab.mapToGlobal(0,0)
    }

    onGlobalSelectedSubTabChanged: {
        screenNetworkingContentControlWifi.localSelectedSubTab = screenNetworkingContentControlWifi.mapFromGlobal(screenNetworkingContentControlWifi.globalSelectedSubTab)
    }

    Component.onCompleted: {
        screenNetworkingContentControlWifi.selectedSubTab = btnAuto
    }

    Rectangle{
        id: rectSubTabSelected

        property real overPadding: 14

        width: screenNetworkingContentControlWifi.selectedSubTab.width + overPadding
        height: btnAuto.height + overPadding

        color: "#809287ED"

        radius: 24

        x: {

            if(!screenNetworkingContentControlWifi.selectedSubTab)
                return 0

            var ret = screenNetworkingContentControlWifi.localSelectedSubTab.x
            ret -= overPadding * 0.5
            return ret
        }

        y: {

            if(!screenNetworkingContentControlWifi.selectedSubTab)
                return 0

            var ret = screenNetworkingContentControlWifi.localSelectedSubTab.y
            ret -= overPadding * 0.5
            return ret
        }

        Behavior on x {
            NumberAnimation{
                duration: 250
            }
        }

        Behavior on width{
            NumberAnimation{
                duration: 125
            }
        }
    }

    Column {
        id: column
        anchors{
            left: parent.left
            right: parent.right
            top: parent.top
        }
        spacing: screenNetworkingContentControlWifi.itemSpacingVertical



        Row{
            id: row

            width: parent.width
            height: 60

            spacing: 24

            CompToggle {
                id: compToggle

                text: "Allow WiFi Traffic:"
                width: 450
                height: 60
            }

            CompBtnBreadcrumb{
                id: btnAuto

                text: "Auto"
                opacity: (screenNetworkingContentControlWifi.selectedSubTab === this ? 1.0 : 0.6)
                onClicked: screenNetworkingContentControlWifi.selectedSubTab = this
            }

            CompBtnBreadcrumb{
                id: btnManual

                text: "Manual"

                opacity: (screenNetworkingContentControlWifi.selectedSubTab === this ? 1.0 : 0.6)
                onClicked: screenNetworkingContentControlWifi.selectedSubTab = this
            }

        }

        Rectangle{
            id: rectSep

            width: parent.width

            height: 6
            radius: 0.5 * height

            color: "#80000000"
        }
    }

    Item{
        id: areaContent

        anchors{
            top: column.bottom
            topMargin: screenNetworkingContentControlWifi.itemSpacingVertical
            left: column.left
            right: column.right
            bottom: parent.bottom
        }

    }

    Loader{
        id: loaderManual

        asynchronous: true
        active: screenNetworkingContentControlWifi.selectedSubTab === btnManual
        anchors.fill: areaContent

        sourceComponent: Item{

            Column{
                id: columnAuto

                width: 800

                spacing: screenNetworkingContentControlWifi.itemSpacingVertical

                anchors{
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }



                CompTextField {
                    id: edtSSID
                    lblText: "Network SSID:"
                    height: 80
                    width: parent.width
                    placeholderText: "Enter Network SSID..."
                }

                CompTextField {
                    id: edtPassword
                    lblText: "Network Password:"
                    height: 80
                    width: parent.width
                    edtEchoMode: TextInput.Password
                    placeholderText: "Enter Network Password..."
                    //text: "Password"
                }

                CompLabelledComboBox {
                    id: compLabelledComboBox
                    height: 80
                    width: parent.width

                    text: "Security Protocol:"
                }


                CompRoundButton{
                    id: btnConnect

                    height: 80
                    width: parent.width



                }
            }

        }
    }

    Loader{
        id: loaderAuto
        active: screenNetworkingContentControlWifi.selectedSubTab === btnAuto
        asynchronous: true
        anchors.fill: areaContent

        sourceComponent: Screen_Networking_Content_Control_Wifi_Auto {

        }
    }


}
