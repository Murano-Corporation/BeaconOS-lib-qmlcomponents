import QtQuick 2.12
import QtLocation 5.12
import QtPositioning 5.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

Item {
    id: screen_RaptorFPRoot

    property string beaconIDSelected : ""
    property string selectedMenuItem: ""

    property var testListCoords: TableModelDroneMissionRoot.listOfPolyPath

    CompMapViewer{
        id: devicemap
        anchors{
            fill: parent
        }
        width: parent.width

        showMapTypes: false
        Component.onCompleted: setZoomLevel(1.0)
        listAssets: TableModelDroneMission
        mapPolyLine.path: screen_RaptorFPRoot.testListCoords



        targetListDelegate: Comp__BASE_MapQuickItem {
            id: compMapAssetItemRoot

            property real arrivalRadius: model.arrival_radius
            property string subTask: model.subtask
            property string commandId: model.command_ID
            property alias assetTypelbl: lblAssetType

            lat: model.Latitude
            lon: model.Longitude
            anchorPoint: Qt.point(sourceItem.width * 0.5, sourceItem.height * 0.5)
            coordinate: QtPositioning.coordinate(lat, lon)
            onCoordinateChanged: {
                sourceItem.coords = coordinate
            }

            sourceItem:
                Item {
                id: compMapAssetItemSourceRoot

                property alias assetTypeText: imgSub.assetTypeText
                property alias coords: imgSub.coords

                assetTypeText: compMapAssetItemRoot.subTask + "-" + compMapAssetItemRoot.commandId

                height: 78
                width: 52

                ImgIconMapPos{
                    id: imgSub

                    property alias assetTypeText:lblAssetType.text
                    property var coords

                    visible: false

                    anchors{
                        fill: parent
                    }


                }

                ColorOverlay{
                    id: colorOverlayMapPin

                    anchors{
                        fill: imgSub
                    }

                    source: imgSub
                    color: "#9287ED"
                    opacity: 0.9
                }

                CompLabel{
                    id: lblAssetType

                    text: "TYPE"

                    font{
                        pixelSize: 20
                        weight: Font.Bold
                    }

                    anchors{
                        bottom: parent.top
                        horizontalCenter: parent.horizontalCenter
                    }
                }

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        compMapAssetItemRoot.centerOnPoint(coordinate)
                    }

                    onDoubleClicked: {
                        compMapAssetItemRoot.fitViewportToVisibleMapItems()
                        compMapAssetItemRoot.centerOnPoint(coordinate)
                    }
                }

            }

        }
    }

    function rewind(){}

    function fastForward(){}

    function playPause(){}

    function speedToggle(){}

    Row{
        id: areaControlsRow

        height: 90
        width: childrenRect.width

        //enabled: screen_RaptorFPRoot.beaconIDSelected !== ""
        //opacity: 1.0
        visible: screen_RaptorFPRoot.selectedMenuItem !== "Mission Preview"

        anchors{
            bottom: parent.bottom
            bottomMargin: 40
            horizontalCenter: parent.horizontalCenter
        }


        spacing: 30

        CompRaptorNavMenuItem {
            id: menuItem3DReconstruction
            opacity: screen_RaptorFPRoot.selectedMenuItem === "3D Reconstruction" ? 1.0 : 0.6

            imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/3DReconstruction.svg"
            imgIconColor: "White"

            onClicked: {
                screen_RaptorFPRoot.selectedMenuItem = "3D Reconstruction"
            }

        }
        CompRaptorNavMenuItem {
            id: menuItemissionEstimate
            opacity:screen_RaptorFPRoot.selectedMenuItem === "Mission Estimate" ? 1.0 : 0.6

            imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/MissionEstimate.svg"
            imgIconColor: "White"
            onClicked: {
                console.log("Clicked on mission estimate icon");
                screen_RaptorFPRoot.selectedMenuItem = "Mission Estimate"
                popupMissionEstimate.open()
            }

        }
        CompRaptorNavMenuItem {
            id: menuItemMissionPreview
            opacity: screen_RaptorFPRoot.selectedMenuItem === "Mission Preview" ? 1.0 : 0.6

            imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/MissionPreview.svg"
            onClicked: {
                screen_RaptorFPRoot.selectedMenuItem = "Mission Preview"
            }

        }

        CompRaptorNavMenuItem {
            id: menuItemEdit
            opacity: screen_RaptorFPRoot.selectedMenuItem === "Edit" ? 1.0 : 0.6

            imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/EditPencil.svg"
            imgIconColor: "White"

            onClicked: {
                screen_RaptorFPRoot.selectedMenuItem = "Edit"
            }

        }

        CompRaptorNavMenuItem {
            id: menuItemPlanner
            opacity: screen_RaptorFPRoot.selectedMenuItem === "Planner" ? 1.0 : 0.6

            imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/Planner.svg"
            onClicked: {
                screen_RaptorFPRoot.selectedMenuItem = "Planner"
                popupPlanner.open();
            }

        }

    }

    Row{
        id: areaControlsPreviewRow

        height: 90
        width: childrenRect.width

        //enabled: screen_RaptorFPRoot.beaconIDSelected !== ""
        opacity: 1.0
        visible: screen_RaptorFPRoot.selectedMenuItem === "Mission Preview"

        anchors{
            bottom: parent.bottom
            bottomMargin: 40
            horizontalCenter: parent.horizontalCenter
        }


        spacing: 30

        CompRaptorNavMenuItem {
            id: menuItemCancel
            //opacity: screen_RaptorFPRoot.selectedMenuItem = "3D Reconstruction" ? 1.0 : 0.6

            imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/Cancel.svg"
            imgIconColor: "White"

            onClicked: {
                screen_RaptorFPRoot.selectedMenuItem = "Cancel"
            }

        }
        CompRaptorNavMenuItem {
            id: menuItemLeft
            //opacity:screen_RaptorFPRoot.selectedMenuItem = "Mission Estimate" ? 1.0 : 0.6

            imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/LeftFill.svg"
            imgIconColor: "White"
            onClicked: {
                screen_RaptorFPRoot.rewind();
            }

        }
        CompRaptorNavMenuItem {
            id: menuItemPlay
            //opacity: screen_RaptorFPRoot.selectedMenuItem = "Mission Planner" ? 1.0 : 0.6

            imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/RightArrowFill.svg"
            imgIconColor: "White"
            onClicked: {
                screen_RaptorFPRoot.playPause();
            }

        }

        CompRaptorNavMenuItem {
            id: menuItemRight
            //opacity: screen_RaptorFPRoot.selectedMenuItem = "Edit" ? 1.0 : 0.6

            imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/RightFill.svg"
            imgIconColor: "White"

            onClicked: {
                screen_RaptorFPRoot.fastForward();
            }

        }

        CompRaptorNavMenuItem {
            id: menuItem1x
            //opacity: screen_RaptorFPRoot.selectedMenuItem = "Planner" ? 1.0 : 0.6

            imgIconSrc: "file:///usr/share/BeaconOS-lib-images/images/1x.svg"
            imgIconColor: "White"
            onClicked: {
                screen_RaptorFPRoot.speedToggle();
            }

        }

    }

    Comp__BASE_Popup{
        id: popupMissionEstimate

        popupName: "Mission Estimate"

        anchors.centerIn: parent

        height: 550
        width: 350

        background: Rectangle{
            radius: 20
            color: "#DD000000"
        }

        CompLabel{
            id: lblMissionEstimate
            anchors{
                top: parent.top
                left: parent.left
                margins: 20
            }
            color: "#00FF94"
            text: "Mission Estimate"
            font.pixelSize: 30
        }

        ListView{
            id: missionEstimateList

            anchors{
                top: lblMissionEstimate.bottom
                topMargin: 20
                left: lblMissionEstimate.left
            }
            height: parent.height

            model: [
                {"label": "Total Time", "value": "22.05"},
                {"label": "Max Speed", "value": "15 mph"},
                {"label": "Total Distance", "value": "3.1 mi"},
                {"label": "Altitude", "value": "312 ft"},
                {"label": "Photos", "value": "274"},
                {"label": "Videos", "value": "1"}
            ]

            delegate:Item{
                height: 60
                CompLabel{
                    text: modelData.label + " : " + modelData.value
                    //color: "#00FF94"
                    font.pixelSize: 20
                }
            }
        }

        CompBtnBreadcrumb{
            id: btnClose

            anchors{
                bottom: parent.bottom
                right: parent.right
                margins: 20
            }

            text: "Close"
            height: 60
            width: 100

            onClicked: popupMissionEstimate.close()
        }

    }

    CompRaptorPlayBackBar {
        id: playBackProgressBar

        visible: areaControlsPreviewRow.visible

        anchors{
            bottom: areaControlsPreviewRow.top
            margins: 20
            left: parent.left
            right: parent.right
        }
    }

    CompPopupPlanner {
        id: popupPlanner

        anchors{
            centerIn: parent
        }
    }
}
