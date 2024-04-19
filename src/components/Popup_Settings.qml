import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQml.Models 2.15

Comp__BASE_Popup {
    id: popup_settings_root

    popupName: "Settings"
    property bool isDelta: base.isDelta
    property string selectedNavName

    property var listOfNavigationOptions: listModelNavigation
    property color colorNavItemIdle:"#80ffffff"
    property color colorNavItemSelected: "#9287ED"
    property DrawerSettingsOmega drawerSettingsroot

    onDrawerSettingsrootChanged: console.log("drawerSettingsroot changd to " + drawerSettingsroot)

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

        ListElement{
            name: "Database (Local)"
            icon_path: "file:///usr/share/BeaconOS-lib-images/images/HelpFill.svg"
            is_enabled: true
        }

        ListElement{
            name: "Display"
            icon_path: "file:///usr/share/BeaconOS-lib-images/images/HelpFill.svg"
            is_enabled: true
        }


    }

    Component.onDestruction: {
        InputHandler.slot_OnPopupFocusChanged(popup_settings_root.popupName, false)
    }

    FocusScope{

//        transform: Translate{
//            y: -InputHandler.yTranslatePopup
//        }

        Behavior on y{
            NumberAnimation{
                duration: 250
            }
        }
        anchors.fill: parent

        onFocusChanged: {
            InputHandler.slot_OnPopupFocusChanged(popup_settings_root.popupName, focus)

        }

        CompPopupBG{
            id: bg

            height: isDelta ? parent.height * 0.90 : parent.height*0.98
            width: isDelta ? parent.width * 0.90 : parent.width*0.98

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
                visible: isDelta

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

        Loader {
            id: loadOmegaSettingsDrawer

            active: !isDelta
            width: parent.width
            height: parent.height
            sourceComponent: DrawerSettingsOmega {
                id: drawerSettingsroot

                width: parent.width
                height: parent.height

                navigationModel: popup_settings_root.listOfNavigationOptions
                onItemClicked: function(itemName)
                {
                    popup_settings_root.selectedNavName = itemName
                }
                Component.onCompleted: {
                   popup_settings_root.drawerSettingsroot = this
                   delayOpen(200)
                    //open()
                }
            }
        }
    Loader{
        active: !isDelta

        CompIconBtn {

            id: iconBtnAssetInfo

            visible: !isDelta

            anchors {
                top: parent.top
                left: parent.left
                topMargin: 120
                leftMargin: 66
            }

            height: 100
            width: 100
            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/ListFill.svg"
            iconColor: "White"

            onClicked: {
                drawerSettingsroot.open()
            }
        }
    }

    // TODO: Move position bindings from the component to the Loader.
    //       Check all uses of 'parent' inside the root element of the component.
    //       Rename all outer uses of the id "areaNavigation" to "loader_areaNavigation.item".
    //       Rename all outer uses of the id "navDelIcon" to "loader_areaNavigation.item.navDelIcon".
    //       Rename all outer uses of the id "popup_Settings_Delegate_NavigationItem" to "loader_areaNavigation.item.popup_Settings_Delegate_NavigationItem".
    //       Rename all outer uses of the id "listViewNavigation" to "loader_areaNavigation.item.listViewNavigation".
    Component {
        id: component_areaNavigation
        Item{
//            property CompImageIcon navDelIcon: inner_navDelIcon
//            property Item popup_Settings_Delegate_NavigationItem: inner_popup_Settings_Delegate_NavigationItem
//            property ListView listViewNavigation: inner_listViewNavigation

            id: areaNavigation
            ListView{
                id: inner_listViewNavigation
                clip: true
                anchors.fill: parent
                boundsBehavior: Flickable.StopAtBounds

                model: popup_settings_root.listOfNavigationOptions
                delegate: Item{
                    id: inner_popup_Settings_Delegate_NavigationItem

                    property bool isCurrent: inner_listViewNavigation.currentIndex === index
                    property color colorCurrent: isCurrent ? popup_settings_root.colorNavItemSelected : popup_settings_root.colorNavItemIdle

                    enabled: model.is_enabled
                    opacity: enabled ? 1.0 : 0.3

                    width: inner_listViewNavigation.width
                    height: 60

                    CompImageIcon{
                        id: inner_navDelIcon
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
                            left: inner_navDelIcon.right
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
                            inner_listViewNavigation.currentIndex = index
                            popup_settings_root.selectedNavName = model.name
                        }
                    }

                }
            }
        }
    }
    Loader {
        id: loader_areaNavigation
        sourceComponent: component_areaNavigation
        active: isDelta
        width: 400

        anchors{
            left: areaControls.left
            top: areaControls.bottom
            topMargin: 20
            bottom: bg.bottom
            bottomMargin: bg.radiusBG
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

            width: isDelta ? searchField.width : parent.width
            x: isDelta ? (bg.mapFromItem(areaControls, searchField.x, searchField.y).x + bg.x) : (bg.mapFromItem(parent, parent.x, parent.y).x + bg.x)
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

                width: parent.width
                height : parent.height
            }
        }

        Loader{
            id: loaderSDatabaseLocalSettings

            anchors.fill: areaContents

            active: popup_settings_root.selectedNavName === "Database (Local)"
            asynchronous:  true
            sourceComponent: Popup_Settings_Database_Local {
                id: popup_settings_database_local

                width: parent.width
                height : parent.height
            }
        }

        Loader{
            id: loaderApplicationSettings

            anchors.fill: areaContents

            active: popup_settings_root.selectedNavName === "Applications"
            asynchronous:  true

            sourceComponent: Popup_Settings_Applications {
                id: popup_settings_applications

//                listItemHeight:120
//                labeltitle.font.pixelSize: 60
//                labelItemSize: 50

                width: parent.width
                height : parent.height
            }
        }

        Loader{
            id: loaderDisplaySettings

            anchors.fill: areaContents

            active: popup_settings_root.selectedNavName === "Display"
            asynchronous:  true
            sourceComponent: Popup_Settings_Display {

                controlWidth: isDelta ? searchField.width : 800

            }
        }

    }


}
