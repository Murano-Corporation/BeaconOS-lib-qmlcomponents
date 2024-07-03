import QtQuick 2.0

Comp__BASE_Popup{
        id: popupSelectedAssets

        popupName: "AssetsListPopup"
        modal: true

        anchors{
            centerIn: parent
        }

        background: CompBtnBreadcrumb {
            anchors.fill: parent
        }

        height: 700
        width: 700

        CompLabel{

            id: lblPopupTitle
            anchors{
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }

            text: "Select an asset to control"
        }

        ListView{
            id: assetsList

            anchors{
                top: lblPopupTitle.bottom
                margins: 20
                left: parent.left
                right: parent.right
            }
            height: 540
            width: 600
            clip: true

            spacing: 10

            model: TableModelRaptorMap

            delegate: CompBtnBreadcrumb{

                width: parent.width
                Rectangle{
                    anchors.fill: parent
                    color: "Transparent"
                    border{
                        width: 3
                        color: "#9287ED"
                    }
                    visible: model.is_selected
                }
                CompImageIcon{

                    anchors{
                        left: parent.left
                        top: parent.top
                        bottom: parent.bottom
                        leftMargin: 20
                    }
                    width: 60
                    source: model.asset_type === "Antenna" ? "file:///usr/share/BeaconOS-lib-images/images/Antenna.svg" : "file:///usr/share/BeaconOS-lib-images/images/Drone.svg"
                }

                //appSourceName: myModelData ? myModelData.appSource : '?'
                text: model.Beacon_ID// + " - " + model.Latitude + ", " + model.Longitude
                onClicked: {
                    screen_RaptorControlRoot.beaconIDSelected = model.Beacon_ID;
                    screen_RaptorControlRoot.selectedItem = model;
                    signalBeaconIDSelected(model.Beacon_ID);
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

            onClicked: popupSelectedAssets.close()
        }
    }
