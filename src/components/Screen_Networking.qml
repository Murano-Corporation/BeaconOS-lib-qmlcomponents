import QtQuick 2.12

Screen__BASE {
    id: screen_NetworkingRoot

    property CompLabel selectedTab: btnControl
    state: "Control"


    states: [
        State{
            name: "Control"
            when: screen_NetworkingRoot.selectedTab === btnControl
        },
        State{
            name: "Monitor"
            when: screen_NetworkingRoot.selectedTab === btnMonitor
        },
        State{
            name: "Analyse"
            when: screen_NetworkingRoot.selectedTab === btnAnalyse
        }
    ]

    Item{
        id: rowTabs

        property real btnWidth: width * 0.3333333
        property real btnHeight: 48
        property real btnFontPixelSize: 28


        height: btnHeight

        anchors{
            left: parent.left
            top: parent.top
            right: parent.right
        }

        CompLabel{
            id: btnControl

            anchors.left: parent.left

            width: rowTabs.btnWidth
            height: rowTabs.btnHeight

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            text: "CONTROL"
            font.pixelSize: rowTabs.btnFontPixelSize

            opacity: screen_NetworkingRoot.selectedTab === this ? 1.0 : 0.6

            MouseArea{
                anchors.fill: parent
                onClicked: screen_NetworkingRoot.selectedTab = parent
            }
        }

        CompLabel{
            id: btnMonitor

            anchors.left: btnControl.right
            anchors.right: btnAnalyse.left

            width: rowTabs.btnWidth
            height: rowTabs.btnHeight

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            text: "MONITOR"
            font.pixelSize: rowTabs.btnFontPixelSize

            opacity: screen_NetworkingRoot.selectedTab === this ? 1.0 : 0.6

            MouseArea{
                anchors.fill: parent
                onClicked: screen_NetworkingRoot.selectedTab = parent
            }
        }

        CompLabel{
            id: btnAnalyse


            anchors.right: parent.right

            width: rowTabs.btnWidth
            height: rowTabs.btnHeight

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.rightMargin: 0

            text: "ANALYSE"
            font.pixelSize: rowTabs.btnFontPixelSize

            opacity: screen_NetworkingRoot.selectedTab === this ? 1.0 : 0.6

            MouseArea{
                anchors.fill: parent
                onClicked: screen_NetworkingRoot.selectedTab = parent
            }
        }

        Rectangle{
            id: rectSelectBG

            anchors{
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            height: 6
            radius: 0.5 * height

            color: "#4D4A5F"

            Rectangle{
                id: rectSelectHandle

                height: parent.height
                width: rowTabs.btnWidth * 0.5

                color: "#9287ED"

                radius: 0.5 * height

                x: screen_NetworkingRoot.selectedTab.x + (screen_NetworkingRoot.selectedTab.width * 0.25)

                Behavior on x {
                    NumberAnimation{
                        duration: 250
                    }
                }
            }
        }


    }

    Rectangle{
        id: groupContentBg

        anchors{
            top: rowTabs.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        color: "#14818087"
        rotation: 0
    }

    Item{
        id: areaContent

        anchors{
            fill: groupContentBg
            margins: 10
        }

        clip: true
    }

    Loader{
        id: loaderControl
        active: screen_NetworkingRoot.state == "Control"
        anchors.fill: areaContent
        asynchronous: true


        sourceComponent:    Screen_Networking_Content_Control {
            id: contentControl
        }
    }







}
