import QtQuick 2.12
import QtQuick.Controls 2.15

Item{
    id: screen_Networking_Content_Control_Wifi_Auto

    property alias spacing: column.spacing
    property real btnHeight: 60
    property real btnWidth_Action: 300
    property real btnHeight_Action: 90
    property alias headerHeight: rowHeaders.height
    property real listItemHeight: 90
    property real listItemWidth_SSID: 0.60
    property real listItemWidth_Security: 0.2575
    property real listItemWidth_Bars: 0.0325

    property var selectedListItem

    property var listOfWifiNetworks: listDev

    ListModel{
        id: listDev

        ListElement{
            isCurrent: true
            ssid: "Murano"
            security: "WPA-3"
            bars: 4
        }

        ListElement{
            isCurrent: false
            ssid: "Tatum"
            security: "WPA-X"
            bars: 1
        }

        ListElement{
            isCurrent: false
            ssid: "Med-Something"
            security: "WPA-2"
            bars: 2
        }

        ListElement{
            isCurrent: false
            ssid: "Med-Something"
            security: ""
            bars: 3
        }
    }


    Column{
        id: column

        spacing: 26

        anchors.fill: parent

        Item{
            id: groupList

            width: parent.width
            height: column.height - column.spacing - rowActions.height

            Row {
                id: rowHeaders

                height: 40
            }

            Rectangle{
                id: rectBG_List

                height: groupList.height - rowHeaders.height
                width: parent.width
                radius: 20

                color: "#80000000"
            }

            ListView{
                id: listOfWifiNetworks

                clip: true

                anchors{
                    fill: rectBG_List
                    margins: rectBG_List.radius
                }

                model: screen_Networking_Content_Control_Wifi_Auto.listOfWifiNetworks

                delegate: Item{
                    id: delegateWiFiListItem

                    signal clicked(string ssid)
                    onClicked: ssid=>{
                                   listOfWifiNetworks.currentIndex = index
                                   screen_Networking_Content_Control_Wifi_Auto.selectedListItem = model
                               }


                    height: screen_Networking_Content_Control_Wifi_Auto.listItemHeight
                    width: listOfWifiNetworks.width

                    Row{
                        id: rowDelegateWiFiListItem

                        anchors.fill: parent

                        CompLabel{
                            id: lblSSID

                            text: model.ssid
                            width: parent.width * (listItemWidth_SSID)
                            height: parent.height

                            verticalAlignment: Text.AlignVCenter

                            color: model.isCurrent ? "#00dd00" : "White"
                        }

                        CompLabel{
                            id: lblSecurity

                            text: model.security
                            width: parent.width * (listItemWidth_Security)
                            height: parent.height

                            verticalAlignment: Text.AlignVCenter

                            color: model.isCurrent ? "#00dd00" : "White"
                        }

                        Item{
                            id: groupBars

                            property int bars: model.bars
                            property color colorWeak: "#80000000"
                            property color colorStrong: model.isCurrent ? "#00dd00" : "White"
                            property real barWidth: width * 0.25

                            height: parent.height * 0.50
                            width: parent.width * (listItemWidth_Bars)
                            anchors.verticalCenter: parent.verticalCenter

                            Row{
                                anchors.fill: parent

                                Rectangle{
                                    anchors.bottom: parent.bottom

                                    height: parent.height * 0.25
                                    width: groupBars.barWidth

                                    color: (groupBars.bars >= 1 ? groupBars.colorStrong : groupBars.colorWeak)
                                }
                                Rectangle{
                                    anchors.bottom: parent.bottom

                                    height: parent.height * 0.50
                                    width: groupBars.barWidth

                                    color: (groupBars.bars >= 2 ? groupBars.colorStrong : groupBars.colorWeak)
                                }
                                Rectangle{
                                    anchors.bottom: parent.bottom

                                    height: parent.height * 0.75
                                    width: groupBars.barWidth

                                    color: (groupBars.bars >= 3 ? groupBars.colorStrong : groupBars.colorWeak)
                                }
                                Rectangle{
                                    anchors.bottom: parent.bottom

                                    height: parent.height * 1.0
                                    width: groupBars.barWidth

                                    color: (groupBars.bars >= 4 ? groupBars.colorStrong : groupBars.colorWeak)
                                }
                            }


                        }

                    }

                    MouseArea{
                        anchors.fill: parent

                        onClicked: delegateWiFiListItem.clicked(model.ssid)
                    }
                }

                highlightMoveVelocity: 4000
                highlightFollowsCurrentItem: true
                highlight: Rectangle{id: rectHighlight
                    color: "#9287ED"

                    onYChanged: {

                        if(!animWidth.running)
                            animWidth.start()
                    }

                    NumberAnimation {
                        id: animWidth
                        target: rectHighlight
                        property: "width"
                        from: 0
                        to: listOfWifiNetworks.width
                        duration: 250
                        easing.type: Easing.InOutQuad
                    }

                }
            }
        }

        Row{
            id: rowActions

            height: screen_Networking_Content_Control_Wifi_Auto.btnHeight_Action

            spacing: 0.5 * height

            anchors.right: parent.right

            CompRoundButton{
                height: parent.height

                text: "Connect"

                enabled: (screen_Networking_Content_Control_Wifi_Auto.selectedListItem !== undefined && !screen_Networking_Content_Control_Wifi_Auto.selectedListItem.isCurrent )

                width: screen_Networking_Content_Control_Wifi_Auto.btnWidth_Action

                font.pixelSize: 40
            }

            CompRoundButton{
                height: parent.height

                text: "Disconnect"
                enabled: (screen_Networking_Content_Control_Wifi_Auto.selectedListItem !== undefined && screen_Networking_Content_Control_Wifi_Auto.selectedListItem.isCurrent )

                width: screen_Networking_Content_Control_Wifi_Auto.btnWidth_Action

                font.pixelSize: 40
            }
        }

    }


}
