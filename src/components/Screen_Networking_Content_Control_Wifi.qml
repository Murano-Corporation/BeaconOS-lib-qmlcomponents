import QtQuick 2.12
import QtQuick.Controls 2.15

Comp__BASE_Popup{
    id: popupNetworkingContentControlWifi
    popupName: "Networking"
    modal: false
    closePolicy: Popup.NoAutoClose
    background: Item{}
    property bool isDelta: base.isDelta

    Item{
        id: screenNetworkingContentControlWifi
        property CompBtnBreadcrumb selectedSubTab


        property real itemSpacingVertical: 24
        property bool isOk: true

        property point globalSelectedSubTab
        property point localSelectedSubTab

        property real minimumWidth: 600
        property real minimumHeight: 300



        onSelectedSubTabChanged: {
            if(!selectedSubTab)
                return

            screenNetworkingContentControlWifi.globalSelectedSubTab = selectedSubTab.mapToGlobal(0,0)
        }

        onGlobalSelectedSubTabChanged: {
            screenNetworkingContentControlWifi.localSelectedSubTab = screenNetworkingContentControlWifi.mapFromGlobal(screenNetworkingContentControlWifi.globalSelectedSubTab)
        }

        Component.onCompleted: {
            screenNetworkingContentControlWifi.selectedSubTab = isDelta ? btnAuto : btnAutoOmega
        }
        CompResizableMoveableContainer{
            id: contentsRoot

            minimumHeight: screenNetworkingContentControlWifi.minimumHeight
            minimumWidth: screenNetworkingContentControlWifi.minimumWidth


            Component.onCompleted:{
                var startOrigin = SingletonOverlayManager.getPopupOrigin("WiFi Viewer")
                var startSize = SingletonOverlayManager.getPopupSize("WiFi Viewer")

                console.log("Setting start size to: " + startSize)
                console.log("Setting start origin to: " + startOrigin);

                contentsRoot.x = startOrigin.x
                contentsRoot.y = startOrigin.y
                contentsRoot.width = startSize.width
                contentsRoot.height = startSize.height
            }

            CompPopupBG{
                id: rectBG

                anchors{
                    fill: parent
                }

            }

            Item {
                id: itemGroupTopRow

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

                    height: 60
                    width: 60

                    source: "file:///usr/share/BeaconOS-lib-images/images/WiFi.svg"
                    color: "#9287ED"
                }

                CompLabel{
                    id: lblTitle

                    anchors{
                        top: parent.top
                        left: iconMessage.right
                        leftMargin: 16
                        right: btnClose.left
                        rightMargin: 16
                    }

                    text: qsTr("Networking Details")
                    font{
                        pixelSize: 40

                    }
                }

                BtnClose{
                    id: btnClose

                    imageIcon{

                        image{
                            antialiasing: true
                            smooth: true
                            cache: true
                        }

                        colorOverlay{
                            antialiasing: true
                            smooth: true
                            cached: true
                        }

                    }

                    anchors{
                        right: parent.right
                        verticalCenter: lblTitle.verticalCenter
                    }

                    height: isDelta ? 40 : 60
                    width: isDelta ? 40 : 60

                    onClicked: {
                        console.log("Closing popup WiFi viewer")
                        popupNetworkingContentControlWifi.close()
                    }

                }


            }
            Rectangle{
                id: rectSubTabSelected

                property real overPadding: 14

                width: screenNetworkingContentControlWifi.selectedSubTab.width + overPadding
                height: isDelta ? (btnAuto.height + overPadding) : (btnAutoOmega.height + overPadding)

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
                        return 0//(itemGroupTopRow.height*2.4)

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
                    left: itemGroupTopRow.left
                    right: itemGroupTopRow.right
                    top: itemGroupTopRow.bottom
                    topMargin: 18
                }
                spacing: screenNetworkingContentControlWifi.itemSpacingVertical



                Row{
                    id: row
                    visible: isDelta

                    width: parent.width
                    height: isDelta ? 60 : 120

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

                Row{
                    id: row1
                    visible: !isDelta

                    width: parent.width
                    height: 120

                    spacing: 24

                    CompToggle {
                        id: compToggleOmega

                        anchors.verticalCenter: parent.verticalCenter
                        text: "Allow WiFi Traffic:"
                        font.pixelSize: 40
                        width: 765
                        height: 60
                    }

                }

                Row{
                    id: row2
                    visible: !isDelta

                    width: parent.width
                    height: 120

                    spacing: 50
                    Item{
                        anchors.fill: parent
                        CompBtnBreadcrumb{
                            id: btnAutoOmega

                            anchors{
                                //top: row.bottom
                                //topMargin: 20
                                verticalCenter: parent.verticalCenter
                                leftMargin: 50
                                left:parent.left
                            }
                            text: "Auto"
                            font.pixelSize: 40
                            opacity: (screenNetworkingContentControlWifi.selectedSubTab === this ? 1.0 : 0.6)
                            onClicked: screenNetworkingContentControlWifi.selectedSubTab = this
                            height: 110
                            width: 400
                        }

                        CompBtnBreadcrumb{
                            id: btnManualOmega

                            anchors{
                                verticalCenter: parent.verticalCenter
                                right: parent.right
                                rightMargin: 50

                            }
                            text: "Manual"
                            font.pixelSize: 40
                            opacity: (screenNetworkingContentControlWifi.selectedSubTab === this ? 1.0 : 0.6)
                            onClicked: screenNetworkingContentControlWifi.selectedSubTab = this
                            height: 110
                            width: 400
                        }
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
                    bottomMargin: 50
                }

            }

            Loader{
                id: loaderManual

                asynchronous: true
                active: screenNetworkingContentControlWifi.selectedSubTab === btnManual || screenNetworkingContentControlWifi.selectedSubTab === btnManualOmega
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
                            height: isDelta ? 80 : 120
                            width: parent.width
                            placeholderText: "Enter Network SSID..."
                            lblFontPixelSize: isDelta ? 28 : 40
                            edtFontPixelSize: isDelta ? 20 : 40
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
                            //text: "Password"
                        }

                        CompLabelledComboBox {
                            id: compLabelledComboBox
                            height: isDelta ? 80 : 120
                            width: parent.width
                            textFontPixelSize: isDelta ? 28 : 40
                            valueComboBox: isDelta ? 24 : 40

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

            Loader{
                id: loaderAuto
                active: screenNetworkingContentControlWifi.selectedSubTab === btnAuto || screenNetworkingContentControlWifi.selectedSubTab === btnAutoOmega
                asynchronous: true
                anchors.fill: areaContent

                sourceComponent: Screen_Networking_Content_Control_Wifi_Auto {

                }
            }
        }
    }
}
