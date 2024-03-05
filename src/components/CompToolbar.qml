import QtQuick 2.12
import QtQuick.Controls 2.12
import CONSTANTS 1.0

Item {
    id: compToolbarRoot

    property real btnHeight: 30
    property real battPercent: 100.0
    property real wifiStrength: 100.0
    property color btnIconColor: "#80FFFFFF"
    property int btnIconSize: 30
    property var listOfBreadcrumbNames: SingletonScreenManager.listOfBreadcrumbs
    //onListOfBreadcrumbNamesChanged: {
    //    console.log("List of breadcrumbs now: " + listOfBreadcrumbNames + " : " + listOfBreadcrumbNames.length)
    //}

    height: 30

    anchors.centerIn: parent

    Rectangle {
        visible: false
        anchors.fill: parent

        color: "#8b000000"
    }

    Row {
        id: rowOfBreadcrumbs

        visible: listOfBreadcrumbNames.length > 0

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: rowOfBtns.left

        spacing: 10

        CompIconBtn {
            id: btnHome
            height: compToolbarRoot.btnHeight


            iconHeight: compToolbarRoot.btnIconSize
            iconColor: compToolbarRoot.btnIconColor
            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/Home.svg"

            visible: SingletonScreenManager.currentScreenName !== "Home"

            onClicked: {
                console.log("Attempting to go home")
                SingletonScreenManager.slot_GoToBreadcrumbScreen("Home", true)
            }
        }

        CompImageIcon {

            anchors{
                verticalCenter: parent.verticalCenter
            }

            image.source: "file:///usr/share/BeaconOS-lib-images/images/RightFill.svg"
            color: compToolbarRoot.btnIconColor
            visible: SingletonScreenManager.currentScreenName !== "Home"
            verticalAlignment: Text.AlignVCenter



            height: 18
            width: 18


        }

        Row {

            anchors{
                verticalCenter: parent.verticalCenter
            }

            spacing: 10

            Repeater {

                model: compToolbarRoot.listOfBreadcrumbNames.length
                Row {
                    property int myIndex: index

                    spacing: 10

                    CompToolbarBreadcrumbBtn {
                        id: btnBreadcrumb
                        text: compToolbarRoot.listOfBreadcrumbNames[index]
                        textColor: compToolbarRoot.btnIconColor
                        fontPixelSize: 25
                        fontWeight: Font.Light
                    }

                    CompImageIcon {

                        image.source: "file:///usr/share/BeaconOS-lib-images/images/RightFill.svg"
                        color: compToolbarRoot.btnIconColor
                        visible: parent.myIndex < (compToolbarRoot.listOfBreadcrumbNames.length - 1)
                        verticalAlignment: Text.AlignVCenter
                        height: 18
                        width: 18

                        anchors{
                            verticalCenter: parent.verticalCenter
                        }

                    }

                }
            }

        }


    }

    Row {
        id: rowOfBtns

        anchors{
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }

        spacing: 26

        CompIconBtn{
            id: btnBattery
            height: btnHeight

            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/Battery100_All.svg"
            iconColor: btnIconColor
        }

        CompIconBtn{
            id: btnConnection
            height: btnHeight

            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/WiFi.svg"
            iconColor: btnIconColor
            iconHeight: btnIconSize
        }

        CompIconBtn{
            id: btnHelp
            height: btnHeight

            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/Help.svg"
            iconColor: btnIconColor
            iconHeight: btnIconSize

            onClicked: ApplicationsController.slot_Request_OpenApp(Constants.ESourceUUID_Popup_Help, {})
        }

        CompIconBtn{
            id: btnSettings
            height: btnHeight

            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/Gear.svg"
            iconColor: btnIconColor
            iconHeight: btnIconSize
        }

        CompIconBtn{
            id: btnPowerOff
            height: btnHeight

            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/Power.svg"
            iconColor: btnIconColor
            iconHeight: btnIconSize

            onClicked: {
                popupPowerOptions.open()
            }


        }

        Popup {
            id: popupPowerOptions
            height: colContents.implicitHeight + 20
            width: colContents.implicitWidth + 20

            x: btnPowerOff.x - width
            y: btnPowerOff.y + btnPowerOff.height

            background: Rectangle{
                color: "#DFDFDF"

                radius: 16
            }

            Column{
                id: colContents
                CompButton{
                    id: btnOptionLogout

                    text: qsTr("Logout")

                    height: btnHeight

                    onClicked: {
                        Actions.signal_Request_Logout()
                        popupPowerOptions.close()
                    }
                }

                CompButton{
                    id: btnOptionPowerOff

                    text: qsTr("Power Off");

                    height: btnHeight

                    onClicked: {
                        Actions.signal_Request_Shutdown()
                        popupPowerOptions.close()
                    }
                }
            }
        }

    }


}
