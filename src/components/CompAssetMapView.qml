import QtQuick 2.12
import QtQuick.Controls 2.12
import QtLocation 5.12
import QtPositioning 5.2

Comp__BASE {
    id: compAssetMapView

    property bool showStyleControls: false

    CompMapViewer{
        id: mapView

        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom

            right: showStyleControls ? groupStyleControls.left : parent.right
        }

        Component.onCompleted: {

            //console.log("Setting zoom level")
            setZoomLevel(2.6)

            //console.log("Setting active map type")
            //setActiveMapTypeIndex(4)

            //console.log("Centering on point")
            centerOnPointXY(40, -100)
        }
    }

    Item{
        id: groupStyleControls

        visible: showStyleControls

        width: Math.max(lblCurrentMapTypeIndex.width, groupBtns.width, switchCaptCoords.width, lblZoom.width)

        anchors{
            right: parent.right
            bottom: parent.bottom
            top: parent.top
        }

        CompLabel{
            id: lblCurrentMapTypeIndex

            anchors{
                top: parent.top
                right: parent.right
            }

            text: "Current Index: " + mapView.activeMapTypeIndex

            font{
                pixelSize: 20
            }
        }

        Item{
            id: groupBtns

            height: 40
            width: 80

            anchors{
                top: lblCurrentMapTypeIndex.bottom
                horizontalCenter: switchCaptCoords.horizontalCenter
            }

            CompImageIcon{
                id: btnDecrement

                enabled: mapView.activeMapTypeIndex > 0
                source: "file:///usr/share/BeaconOS-lib-images/images/LeftArrowFill.svg"
                height: 40
                width: 40

                anchors{
                    left: parent.left
                    top: parent.top
                }

                MouseArea{
                    anchors{
                        fill: parent
                    }

                    onClicked: {
                        mapView.activeMapTypeIndex -= 1
                    }
                }
            }

            CompImageIcon{
                id: btnDIncrement

                enabled: mapView.activeMapTypeIndex <= mapView.maxMapTypeIndex
                source: "file:///usr/share/BeaconOS-lib-images/images/RightArrowFill.svg"
                height: 40
                width: 40

                anchors{
                    left: btnDecrement.right
                    top: parent.top
                }

                MouseArea{
                    anchors{
                        fill: parent
                    }

                    onClicked: {
                        mapView.activeMapTypeIndex += 1
                    }
                }
            }

        }

        CompLabel{
            id: lblZoom
            anchors{
                top: groupBtns.bottom
                topMargin: 20

                right: lblCurrentMapTypeIndex.right
            }

            text: "Current Zoom: " + mapView.zoomCurrent.toFixed(2)

            font{
                pixelSize: lblCurrentMapTypeIndex.font.pixelSize
            }
        }

        Switch{
            id: switchCaptCoords
            text: 'Capt Coords'

            anchors{
                top: lblZoom.bottom
                topMargin: 20
                right: lblZoom.right
            }

            checked: mapView.captureMouseCoords

            onCheckedChanged: mapView.captureMouseCoords = checked
        }


    }
}
