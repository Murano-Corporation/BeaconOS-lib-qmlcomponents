import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQml.Models 2.15

Comp__BASE {
    id: popup_settings_applications_root
    property bool isDelta: base.isDelta
    property real listHeight: isDelta ? 90 : 120
    property alias labeltitle: lblTitle

    function showAppInfoPopup(appName)
    {
        var appInfo = Applications.getApplicationInfo(appName);
        var copy = Applications.copyFromOther(appInfo)

        if( !appInfo.isValid )
        {
            console.error("Invalid AppInfo returned!")
            return;
        }

        loaderPopupEdit.appInfo = copy
        loaderPopupEdit.appInfo_Original = appInfo
        loaderPopupEdit.active = true

        //console.log("Got Info For: " + appInfo);
        //console.log("...AppName: " + appInfo.name);
        //console.log("...IconPath: " + appInfo.iconPath);
        //console.log("...NavPath: " + appInfo.navPath);
    }

    Column{
        id: colContents

        spacing: 20

        anchors{
            fill: parent
        }

        CompLabel{
            id: lblTitle

            text: "Applications"

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom

            height: 40
            width: parent.width
            font.pixelSize: isDelta ? 25 : 60
        }

        CompPopupBG{
            id: bg
            width: parent.width
            height: parent.height - parent.spacing - lblTitle.height

            anchors.fill: undefined

            ListView{
                id: listApplications

                boundsBehavior: Flickable.StopAtBounds

                clip: true
                spacing: 20
                anchors{
                    fill: parent
                    margins: bg.radiusBG
                }

                model: TableModelApplications

                delegate: Item{
                    id: compApplicationsListItem

                    opacity: model.enabled ? 1.0 : 0.6

                    height: popup_settings_applications_root.listHeight
                    width: listApplications.width

                    Row{
                        id: row

                        anchors{
                            fill: parent
                            margins: 20
                        }
                        spacing: 20

                        CompLabel{
                            id: lblAppName
                            text: model.app_display_name
                            anchors{
                                verticalCenter: parent.verticalCenter

                            }

                            height: row.height
                            width: row.width - row.spacing - iconArrow.width
                            color: "white"
                            font.pixelSize: isDelta ? 25 : 50

                            verticalAlignment: Text.AlignVCenter
                        }

                        CompImageIcon{
                            id: iconArrow

                            anchors{
                                verticalCenter: parent.verticalCenter
                            }

                            source: "file:///usr/share/BeaconOS-lib-images/images/RightFill.svg"

                            color: "white"
                            height: lblAppName.height
                            width: height

                        }

                    }

                    MouseArea{
                        anchors.fill: parent

                        onClicked: {
                            listApplications.currentIndex = index
                            popup_settings_applications_root.showAppInfoPopup(model.app_display_name)
                        }
                    }


                }

            }
       }

    }


    Loader{
        id: loaderPopupEdit

        property var appInfo
        property var appInfo_Original

        active: false
        asynchronous: true
        anchors.fill: parent

        sourceComponent: Popup_Application_Info {
            id: popup_application_info

            applicationInfoStruct: loaderPopupEdit.appInfo
            applicationInfoStruct_Original: loaderPopupEdit.appInfo_Original
            contentWidth: parent.width

            Component.onCompleted: {
                open()
            }

            onClosed: {
                loaderPopupEdit.active = false
            }
        }
    }

}
