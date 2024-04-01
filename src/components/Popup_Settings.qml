import QtQuick 2.0

Comp__BASE_Popup {
    id: popup_settings_root

    property string selectedNavName

    property var listOfNavigationOptions: listModelNavigation
    property color colorNavItemIdle:"#80ffffff"
    property color colorNavItemSelected: "#9287ED"

    ListModel{
        id: listModelNavigation

        ListElement{
            name: "Applications"
            icon_path: "file:///usr/share/BeaconOS-lib-images/images/HelpFill.svg"
            is_enabled: true
        }

        ListElement{
            name: "Camera"
            icon_path: "file:///usr/share/BeaconOS-lib-images/images/CameraFill.svg"
            is_enabled: true
        }

        ListElement{
            name: "System"
            icon_path: "file:///usr/share/BeaconOS-lib-images/images/GearFill.svg"
            is_enabled: true
        }


    }

    CompPopupBG{
        id: bg

        height: parent.height * 0.90
        width: parent.width * 0.90

        anchors{
            centerIn: parent
            fill: undefined
        }

    }

    Item{
        id: areaControls

        anchors{
            top: bg.top
            left: bg.left
            right: bg.right
            margins: bg.radiusBG
        }

        height: 60

        CompLabel{
            id: lblSettings

            text: "Settings"
            font.pixelSize: 40

            anchors{
                left: parent.left
                leftMargin: 20
                verticalCenter: parent.verticalCenter
            }
        }

        CompCustomisableTextField{
            id: searchField

            width: 600

            anchors{
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
        }

        BtnClose{
            id: btnClose

            anchors{
                top: parent.top
                right: parent.right
                bottom: parent.bottom

                rightMargin: 20
            }

            width: height

            onClicked: popup_settings_root.close()
        }

    }

    Item{
        id: areaNavigation

        anchors{
            left: areaControls.left
            top: areaControls.bottom
            topMargin: 20
            bottom: bg.bottom
            bottomMargin: bg.radiusBG
        }

        width: 400

        ListView{
            id: listViewNavigation
            clip: true
            anchors.fill: parent
            boundsBehavior: Flickable.StopAtBounds

            model: popup_settings_root.listOfNavigationOptions
            delegate: Item{
                id: popup_Settings_Delegate_NavigationItem

                property bool isCurrent: listViewNavigation.currentIndex === index
                property color colorCurrent: isCurrent ? popup_settings_root.colorNavItemSelected : popup_settings_root.colorNavItemIdle

                enabled: model.is_enabled
                opacity: enabled ? 1.0 : 0.3

                width: listViewNavigation.width
                height: 60

                CompImageIcon{
                    id: navDelIcon
                    anchors{
                        top: parent.top
                        left: parent.left
                        bottom: parent.bottom
                        margins: 10
                    }

                    width: height

                    source: model.icon_path

                    color: parent.colorCurrent

                }

                CompLabel{

                    anchors{
                        left: navDelIcon.right
                        right: parent.right
                        bottom: parent.bottom
                        top: parent.top

                        leftMargin: 20
                        topMargin: 10
                        bottomMargin: 10
                        rightMargin: 10
                    }

                    text: model.name
                    color: parent.colorCurrent

                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        listViewNavigation.currentIndex = index
                        popup_settings_root.selectedNavName = model.name
                    }
                }

            }
        }
    }

    Item{
        id: areaContents

        anchors{
            top: areaControls.bottom
            topMargin: 40

            bottom: bg.bottom
            bottomMargin: bg.radiusBG
        }

        width: searchField.width
        x: bg.mapFromItem(areaControls, searchField.x, searchField.y).x + bg.x
    }

    Loader{
        id: loaderCameraSettings

        anchors.fill: areaContents

        active: popup_settings_root.selectedNavName === "Camera"
        asynchronous:  true
        sourceComponent: Popup_Settings_Camera {
            id: popup_Settings_Camera

            controlWidth: searchField.width
        }
    }

    Loader{
        id: loaderSystemSettings

        anchors.fill: areaContents

        active: popup_settings_root.selectedNavName === "System"
        asynchronous:  true
        sourceComponent: Popup_Settings_System {
            id: popup_Settings_System

            width: searchField.width
        }
    }

}
