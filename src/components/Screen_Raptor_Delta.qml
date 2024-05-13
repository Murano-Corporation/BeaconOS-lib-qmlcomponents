import QtQuick 2.15
import Qt.labs.qmlmodels 1.0
Screen_Raptor__BASE {
    id: screen_Raptor_Delta_Root

    property real pipWidth: 200
    property real pipHeight: 200
    property int pipMargins: 60


    property int controlSlideInInterval: 250
    property int controlSlideOutInterval: 250

    property bool isControlsDisplayed_Left: true
    property bool isControlsDisplayed_Right: true
    property bool isControlsDisplayed_Bottom: true


    Item{
        id: areaLeftControls

        anchors{
            top: parent.top
            left: parent.left
            bottom: (isControlsDisplayed_Bottom ? areaBottomControls.top : parent.bottom)
        }

        width: 200

        Rectangle{
            id: rectControlsLeft

            anchors{
                fill: parent
            }

            border{
                width: 4
                color: "black"
            }
        }
    }

    Item{
        id: areaRightControls

        anchors{
            top: parent.top
            right: parent.right
            bottom: (isControlsDisplayed_Bottom ? areaBottomControls.top : parent.bottom)
        }

        width: 200

        Rectangle{
            id: rectControlsRight

            anchors{
                fill: parent
            }

            border{
                width: 4
                color: "black"
            }
        }

    }

    Item{
        id: areaBottomControls

        anchors{
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        height: 200

        Rectangle{
            id: rectControlsBottom

            anchors{
                fill: parent
            }

            border{
                width: 4
                color: "black"
            }
        }
    }

    Item{
        id: areaContents

        anchors{
            top: parent.top
            left: (isControlsDisplayed_Left ? areaLeftControls.right : parent.left)
            right: (isControlsDisplayed_Right ? areaRightControls.left : parent.right)
            bottom: (isControlsDisplayed_Bottom ? areaBottomControls.top : parent.bottom)

        }

        CompMapViewer{
            id: mapViewer

            anchors.fill: parent

            onCenterChanged: {console.log("Center is now: " + center)}
            onBearingChanged: {console.log("Bearing is now: " + bearing)}
            onTiltChanged: {console.log("Tilt is now: " + tilt)}

            listAssets: ListModel {

                ListElement {
                    Latitude: 0.0
                    Longitude: 0.0
                    asset_type: "Drone"
                    assetID: "DEV-01"
                    heading: 15
                    is_ally: true
                }

                ListElement {
                    Latitude: 1.0
                    Longitude: 1.0
                    asset_type: "Antenna"
                    assetID: "DEV-01"
                    effective_range_km: 2.0
                    is_ally: false
                }

                ListElement {
                    Latitude: 3.0
                    Longitude: 3.0
                    asset_type: "Aircraft Carrier"
                    assetID: "AAC-001"
                    heading: 270
                    is_ally: true
                }

                ListElement {
                    Latitude: 4.0
                    Longitude: 3.0
                    asset_type: "3D Cube"
                    assetID: "3DC-001"
                    is_ally: true
                }

                //ListElement{
                //    Latitude: 0.1
                //    Longitude: 0.1
                //    asset_type: "Antenna"
                //    assetID: "???"
                //    effective_range_km: 2.0
                //    is_ally: true
                //}
            }

            targetListDelegate: delegateChooser_Targets

            DelegateChooser{
                id: delegateChooser_Targets

                role: "asset_type"

                DelegateChoice{
                    roleValue: "Antenna"

                    Comp_MapMarker_Antenna {
                        lat: model.Latitude
                        lon: model.Longitude
                        isAlly: model.is_ally
                        effectiveRadiusKm: model.effective_range_km
                    }
                }

                DelegateChoice {
                    roleValue: "Drone"

                    Comp_MapMarker_Drone{
                        lat: model.Latitude
                        lon: model.Longitude
                        heading: model.heading
                        isAlly: model.is_ally
                    }

                }

                DelegateChoice {
                    roleValue: "Aircraft Carrier"

                    CompMapItem_ACCarrier {
                        id: compMapItem_ACCarrier

                        lat: model.Latitude
                        lon: model.Longitude
                        heading: model.heading
                        isAlly: model.is_ally
                    }

                }

                DelegateChoice {
                    roleValue: "3D Cube"

                    CompMapItem_3D_Cube {
                        id: compMapItem_3D_Cube
                        lat: model.Latitude
                        lon: model.Longitude
                        heading: model.heading
                        isAlly: model.is_ally

                        tilt: mapViewer.tilt
                    }

                }

            }
        }

        Comp_3DOverlay_Battlespace {
            id: comp_3DOverlay_Battlespace
            anchors.fill: areaContents

            mapCoords: mapViewer.center

        }

        Comp_Pip_Radar {
            id: component_Pip_Radar

            //x: pipMargins
            //y: pipMargins

            //height: pipHeight
            //width: pipWidth

            pipViewX: pipMargins
            pipViewY: pipMargins

            pipViewHeight: pipHeight
            pipViewWidth: pipWidth

            fullViewHeight: areaContents.height
            fullViewWidth: areaContents.width
        }

        Comp_Pip_Camera {
            id: component_Pip_Camera

            //y: pipMargins
            //x: parent.width - width - pipMargins

            //height: pipHeight
            //width: pipWidth

            pipViewX: parent.width - width - pipMargins
            pipViewY: pipMargins

            pipViewHeight: pipHeight
            pipViewWidth: pipWidth

            fullViewHeight: areaContents.height
            fullViewWidth: areaContents.width
        }

        Comp_Pip_Battlespace {
            id: comp_Pip_Battlespace
            //height: pipHeight
            //width: pipWidth
            //x: pipMargins
            //y: parent.height - height - pipMargins

            pipViewX: pipMargins
            pipViewY: parent.height - height - pipMargins

            pipViewHeight: pipHeight
            pipViewWidth: pipWidth

            fullViewHeight: areaContents.height
            fullViewWidth: areaContents.width
        }


    }
}
